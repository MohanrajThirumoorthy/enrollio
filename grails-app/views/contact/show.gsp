<%@ page import="org.bworks.bworksdb.Contact" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="contact" />
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'jquery.multiselect.css')}" />

	<script type="text/javascript" src="${resource(dir:'js', file:'jquery-1.4.2.min.js')}"></script>
	<script type="text/javascript" src="${resource(dir:'js', file:'jquery.multiselect.min.js')}"></script>
	<script type="text/javascript" src="${resource(dir:'js', file:'ui.datepicker.js')}"></script>
	<script type="text/javascript" src="${resource(dir:'js', file:'enrollioContact.js')}"></script>
        <script type="text/javascript">
             $(document).ready(function(){

                  // toggle students' starred status, depending on students current starred status                
                  // We have to use a <span></span> to hold the image, because we
                  // replace the contents of the span with the result of this POST.
                  // if we used only an image w/o a parent <span> it doesn't work
                  // NOTE: THIS BREAKS if it's in its own .js file.
                  // (the createLink method doesn't execute successfully, and you get a garbage URL back
                  $(".star").click(function(){
                    $(this).load('${createLink(controller:"student", action:"toggleStar")}', 
                        { 'starred' : $(this).children('img').attr('starred'), 'id' : $(this).attr("starId") }); });

              });

        </script>
        <title>${studentInstance ? "Student: " + studentInstance : "Contact:" + contactInstance}</title>
    </head>
    <body>
    <div id="someMenu" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
        <g:link action="create" controller="contact" 
                elementId="newStudentLink" class="user_add">&#160;New Student</g:link>
    </div>
    <div id="contentContainer" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
        <div id="mainContent" style="float:left;" class="ui-corner-all ui-widget-content ui-corner-bottom">
            <div class="ui-widget ui-widget-content ui-corner-all">
                <g:if test="${flash.message}">
                    <div class="message">${flash.message}</div>
                </g:if>
                <h3 style="padding:0.5em 1em;" class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header2 ui-corner-all">
                    Parent Info
                </h3>
                <table>
                    <tbody>
                        <g:if test="${contactInstance.cannotReach}">
                        <tr>
                            <td colspan="4" class="errors">Cannot Reach</td>
                        </tr>
                        </g:if>
                        <tr>
                            <td>${contactInstance}</td>
                            <td>${contactInstance.address1} 
                                <br />
                                <g:if test="${contactInstance.address2}">
                                ${contactInstance.address2} 
                                <br /></g:if>
                                <g:if test="${contactInstance.city}">
                                ${contactInstance.city},&#160;&#160;</g:if>
                                <g:if test="${contactInstance.state}">
                                ${contactInstance.state} 
                                <br /></g:if>
                                <g:if test="${contactInstance.zipCode}">
                                ${contactInstance.zipCode}&#160;&#160;</g:if>
                                <br /></td>
                        </tr>
                        <tr>
                            <td>Email:</td>
                            <td>${contactInstance.emailAddress}</td>
                        </tr>
                        <g:each var="phone" in="${contactInstance.phoneNumbers}">
                        <tr>
                            <td>${phone.label}</td>
                            <td>${phone.phoneNumber}</td>
                        </tr>
                        </g:each>
                        <g:if test="${contactInstance.comments}">
                        </g:if>
                    </tbody>
                </table>
                <table style="width:40%;" class="ui-widget ui-widget-content">
                    <thead>
                        <tr class="ui-widget-header2">
                            <th colspan="2">Notes</th>
                        </tr>
                    </thead> 
                    <g:form id="${contactInstance.id}" controller="contact" action="addNote">
                        <tbody>
                            <comments:each bean="${contactInstance}">
                                <g:render template="/common/showNote"
                                          model="[ noteInstance : comment ]"/>
                            </comments:each>
                            <tr>
                                <td>
                                <g:textField name="noteText" />
                            </td>
                            <td>
                                <input type="submit" value="Add Note" />
                                </td>
                                  </tr>
                        </tbody>
                    </g:form>
                </table>
            </div>
        </div>
        <div style="float:left;" class="ui-corner-all ui-widget-content ui-corner-bottom">
            <h3 style="padding:0.5em 1em;" class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header2 ui-corner-all">
                Students
            </h3>
            <g:if test="${contactInstance.students}">
                <g:each var="stu" in="${contactInstance.students}">
                    <g:render template="/student/studentQuickView" model="[studentInstance:stu]" />
                </g:each>
            </g:if>
            <g:else>
                <h3>Students</h3>
                <p>No students</p>
            </g:else>
        </div>
        </div>










        <div style="overflow:hidden" class="ui-corner-all ui-widget-content ui-corner-bottom">
            <fieldset class="horizontal ui-widget ui-widget-content" style="float: left;">
                     <legend class="ui-widget-header2 ui-corner-all">Student Info
                         <input type="hidden" name="_newStudentOption"><input type="checkbox" id="newStudentOption" class="enrollStudent" checked="checked" name="newStudentOption">
                     </legend>
                    
                    <div class="field">
                        <label for="student.firstName">First Name : </label> 

                        <input type="text" value="" name="student.firstName" id="firstName"><br>
                    </div>
                                 
                    <div class="field">
                        <label for="student.middleName">Middle Name: </label> 

                        <input type="text" value="" name="student.middleName" id="middleName"><br>
                    </div>
                                 
                    <div class="field">
                        <label for="student.lastName">Last Name: </label> 

                        <input type="text" value="" name="student.lastName" id="lastName"><br>
                    </div>                                
                    <div class="field">
                        <label for="studentSignupDate">Signup Date</label>
                        <input type="text" value="01/16/2011" name="studentSignupDate" id="studentSignupDate" class="hasDatePicker hasDatepicker">
                    </div>
                    <div class="field">
                        <label for="lastName">Interests</label> 
                        <a class="ui-multiselect ui-widget ui-state-default ui-corner-all ui-state-hover" id="" style="width: 205px;"><input type="text" value="Children's EAC" class="ui-state-default" readonly="readonly" style="width: 189px;" title="Children's EAC"><span class="ui-icon ui-icon-triangle-1-s"></span></a><div class="ui-multiselect-options ui-widget ui-widget-content ui-corner-all"><ul class="ui-multiselect-checkboxes ui-helper-reset"><li class=""><label class="ui-corner-all"><input type="checkbox" checked="checked" title="Children's EAC" value="1" name="interestInCourse">Children's EAC</label></li><li class=""><label class="ui-corner-all"><input type="checkbox" title="Adult EAC" value="2" name="interestInCourse">Adult EAC</label></li><li class=""><label class="ui-corner-all"><input type="checkbox" title="Earn-A-Bike" value="3" name="interestInCourse">Earn-A-Bike</label></li><li class=""><label class="ui-corner-all"><input type="checkbox" title="Mentorship Course" value="4" name="interestInCourse">Mentorship Course</label></li></ul></div>
                    </div>
                </fieldset>
        </div>











    </body>
</html>
