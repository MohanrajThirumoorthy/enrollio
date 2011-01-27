<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
        <script type="text/javascript">
             $(document).ready(function(){

                var url = "${createLink(action:'foobarform', controller:'course', id:courseInstance.id)}";
                $('.enrollStudent').click(function() {
                    var studentId = $(this).attr('studentid')
                    // populate enrollmentform
                    $.get(url,
                        { studentId : studentId } , function(data) { $('#dialog-form').html(data); }
                    );
                    $( "#dialog-form" ).dialog({
                        title : $(this).attr('studentName'), 
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
        <title>Interested Students</title>
    </head>
    <body>
        <!-- form to use when enrolling.  Not visible -->
        <div id="dialog-form"> </div>

        <g:render template="/common/messages" />
        <div id="contentContainer" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
            <g:render template="/course/coursesHeader"
                model="[ currentCourse : courseInstance ]" />

            <div style="overflow:hidden;" class="ui-tabs-panel ui-widget-content ui-corner-bottom">
                <h4 style="float:left;" class="mainInfo">Waiting List (${activeInterests.size() + ' students'})</h4>
                    <g:link class="printer" name="printableCallListLink" 
                        controller="course"
                        action="printableCallList" 
                        id="${courseInstance.id}" 
                        params="[ pdf:true,
                                  reservedForUser : reservedForUserId,
                                  q : q ]">Printable list (PDF)
                        
                        </g:link>
                <div style="float:right;width:auto;margin-top:0;">
                    <g:form controller="course" action="interestedStudents" id="${courseInstance.id}" method="GET">
                        <g:textField name="q" value="${params.q}" size="20" />
                        <g:submitButton name="submitFilter" value="Search Contact Names" />
                        <g:link action="interestedStudents" controller="course" id="${courseInstance.id}"> Clear </g:link>
                    </g:form>
                </div>
                <table id="interestedStudents" style="width:100%;float:left;" class="ui-widget ui-widget-content">
                    <thead>
                        <tr class="ui-widget-header2 ">
                            <th colspan="3">Waiting List</th>
                        </tr>
                    </thead>

                <g:each var="con" in="${contactInstanceList}">
                <g:render template="interestedContact" model="[ users : users,
                    contactInstance : con,
                    selectedContactId : selectedContactId,
                    callListContacts : callListContacts,
                    courseInstance : courseInstance,
                    classSessionInstance : classSessionInstance ]" />
                    </g:each>
                </table>
                <div style="float:left;" class="paginateButtons">
                    <g:paginate id="${courseInstance.id}" total="${contactInstanceTotal}"
                    params="[ reservedForUser : reservedForUserId ?: '', classSessionId:classSessionInstance?.id]" />
                </div>
            </div>
        </div>
    </body>
</html>
