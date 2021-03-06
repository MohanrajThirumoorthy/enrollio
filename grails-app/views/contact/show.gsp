<%@ page import="org.bworks.bworksdb.Contact" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="contact" />
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'jquery.multiselect.css')}" />
	<script type="text/javascript" src="${resource(dir:'js', file:'jquery.multiselect.min.js')}"></script>
	<script type="text/javascript" src="${resource(dir:'js', file:'enrollioContact.js')}"></script>
        <script type="text/javascript">
             $(document).ready(function(){

                  // toggle students' starred status, depending on students current starred status                
                  // We have to use a <span></span> to hold the image, because we
                  // replace the contents of the span with the result of this POST.
                  // if we used only an image w/o a parent span it doesn't work
                  // NOTE: THIS BREAKS if it's in its own .js file.
                  // (the createLink method doesn't execute successfully, and you get a garbage URL back
                  $(".star").click(function(){
                    $(this).load('${createLink(controller:"student", action:"toggleStar")}', 
                        { 'starred' : $(this).children('img').attr('starred'), 'id' : $(this).attr("starId") }); });
                 $('.hasDatePicker').datepicker({
                     defaultDate: '-10y',
                     yearRange: '-100:+10', 
                     changeMonth: true,
                     changeYear:  true
                 });
                 $('.hasDatePicker').datepicker({changeYear:true});
                $("#saveStudent,  #addNote").button();

                $("#showMoreNotes").click(function() {
                    $("#moreNotes").toggle();
                    return false;
                });

                var url = "${createLink(action:'quickEnroll', controller:'classSession')}";
                $('.enrollStudent').click(function() {
                    var studentId = $(this).attr('data-student-id')
                    // populate enrollmentform
                    $.get(url, { studentId : studentId } , function(data) { 
                            $('#dialog-form').html(data); 
                    });
                    $( "#dialog-form" ).dialog({
                        title : 'Quick Enroll: ' + $(this).attr('data-student-name'), 
                        position : 'center',
                        height: 300,
                        width: 350,
                        modal: true,
                        buttons: {
                            "Save": function() {
                                // hack an ajax call by using the form's action
                                var action = $(this).children('form').attr('action');
                                var formData = $(this).children('form').serialize();
                                $.post(action, formData, function(resultData) {
                                    $("#studentEnrollmentData" + studentId).html(resultData)
                                });
                                $(this).dialog( "close" );
                            },
                            Cancel: function() {
                                $( this ).dialog( "close" );
                            }
                        }
                    });
                    return false;
                });

              });

        </script>
        <title>${studentInstance ? "Student: " + studentInstance : "Contact:" + contactInstance}</title>
        <style>
            input.text { margin-bottom:12px; width:95%; padding: .4em; }
        </style>
    </head>
    <body>
    <g:render template="/common/messages" />
    <g:render template="/contact/contactMenu" />
    <div id="newContactNoteForm" style="display:none;">
        <g:form controller="contact" action="addNote" id="${contactInstance.id}">
            <g:textArea style="margin:auto;" rows="5" cols="30" name="noteText" class="text ui-widget-content ui-corner-all"/> 
        </g:form>
    </div>
    <div id="contentContainer" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
        <table style="width:100%" class="ui-widget ui-widget-content ui-corner-all">
            <tr class="ui-widget-header2">
                        
                <th colspan="2">Contact Info</th>
                <th colspan="1">
                    Notes <a href="#" id="createContactNote" contactId="${contactInstance.id}"><img src="${resource(dir:'/images/icons', file:'note.png')}" /></a>
                </th>
            </tr>
            <tbody>
                <g:if test="${contactInstance.cannotReach}">
                    <tr>
                        <td colspan="4" class="ui-corner-all ui-state-error">Cannot Reach</td>
                    </tr>
                </g:if>
                <tr id="contactInfo">
                    <td>
                        <g:link name="editContactLink" class="useredit" controller="contact" action="edit" id="${contactInstance.id}">${contactInstance}</g:link><br />
                        ${contactInstance.address1} <br />
                        <g:if test="${contactInstance.address2}">
                            ${contactInstance.address2} <br />
                        </g:if>
                        <g:if test="${contactInstance.city}">
                            ${contactInstance.city},&#160;&#160;</g:if>
                        <g:if test="${contactInstance.state}">
                            ${contactInstance.state}
                        </g:if>
                        <g:if test="${contactInstance.zipCode}">
                            ${contactInstance.zipCode}&#160;&#160; <br />
                        </g:if>
                    </td>
                    <td>
                        <ul>
                        <g:each var="phone" in="${contactInstance.phoneNumbers}">
                            <li>${phone.label} - ${phone.phoneNumber}</li>
                        </g:each>
                        <g:if test="${contactInstance.emailAddress}">
                            <li>${contactInstance.emailAddress}</li>
                        </g:if>
                        </ul>
                    </td>
                    <td>
                        <div id="contactNotes">
                            <enrollio:commentList limit="3" thingy="${contactInstance}" />
                        </div>
                        <g:if test="${contactInstance.getTotalComments() > 3}">
                            <small style="float:right;"><a href="#" id="showMoreNotes">(...more)</a></small>
                        </g:if>
                    </td>
                </tr>
                <tr id="moreNotes" style="display:none;">
                    <td colspan="2">
                        <ul>
                            <enrollio:commentList thingy="${contactInstance}" />
                        </ul>
                    </td>
                </tr>
            </tbody>
        </table>
        <table id="studentInfo" style="width:100%;float:left;" class="ui-corner-all ui-widget-content ui-corner-bottom">
            <tr class="ui-widget-header2">
                <th width="40%">Student</th>
                <th>Interests</th>
                <th>Enrollments</th>
            </tr>
            <g:each var="stu" in="${contactInstance.students}">
            <tr class="studentInfo ${studentInstance?.id == stu.id ? 'selected' : ''} ">
                <g:render template="/student/studentQuickView" model="[ selected : stu.id == studentInstance?.id, studentInstance:stu]" />
            </tr>
            </g:each>
        </table>
        <g:form action="saveStudent" controller="contact" method="POST" name="newStudentForm">
            <g:render template='/contact/createStudent' 
                         model="[contactInstance:contactInstance, possibleInterests : possibleInterests, studentInstance : newStudentInstance]" />
             <div class="buttonBox">
                 <g:submitButton name="saveStudent" value="Save" />
             </div>
        </g:form>
        </div>
        <div id="dialog-form" ></div>

    </body>
</html>
