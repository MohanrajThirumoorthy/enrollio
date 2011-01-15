<%@ page import="org.bworks.bworksdb.Contact" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <meta name="tabName" content="contact" />    
        <title>Create Contact</title>         
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'jquery.multiselect.css')}" />
        <g:javascript src="jquery-1.4.2.min.js" />
        <g:javascript src="jquery.maskedinput-1.2.2.min.js" />
        <g:javascript src="jquery.multiselect.min.js" />
	<script type="text/javascript" src="${resource(dir:'js', file:'ui.datepicker.js')}"></script>
        <g:javascript src="enrollioContact" />
        <script type="text/javascript">
            
             $(document).ready(function(){
                  $("select.multiselect").multiSelect({
                      showHeader : false,
                      noneSelectedText : 'Select Interests',
                       selectedList:2   // selectedList shows the names of the selected interests!
                  });
                  // Show date picker for the "Signup Date" that shown on the
                  // new student form.  (It's rendered in the createStudent.gsp template below)
                 $('#studentSignupDate').datepicker({changeYear:true});
                 $('#newStudentOption').change(function() {
                     if($(this).attr('checked')) {
                         $('#newStudentForm').show('slow');
                     }
                     else {
                         $('#newStudentForm').hide('slow');
                         }
                 });
             });
        
        </script>
    </head>
    <body>
        <script type="text/javascript">
            $(document).ready(function() {
                    $(".phoneNumber").mask("(999) 999-9999")
            });
        </script>
        <div id="someMenu" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
            <g:link url="${[controller:'course', action:'create']}" id="newCourseLink" class="module_add">&#160;New</g:link>
        </div>
        <div id="secondMenu" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
        <div class="float-container ui-tabs-panel ui-widget-content ui-corner-bottom">
            <g:hasErrors bean="${contactInstance}">
                <div class="errors">
                    <g:renderErrors bean="${contactIntance}" as="list" />
                </div>
            </g:hasErrors>
            <g:hasErrors bean="${studentInstance}">
                <div class="errors">
                    <g:renderErrors bean="${studentInstance}" as="list" />
                </div>
            </g:hasErrors>
            <g:form method="post" action="save" controller="contact" >
               <g:render template="editContact" 
                                 model="[contactInstance:contactInstance]" />                      <br />

                 <fieldset style="float:left;" class="horizontal ui-widget ui-widget-content">
                     <legend class="ui-widget-header2 ui-corner-all">Student Info
                     
                         <g:checkBox name="newStudentOption" 
                         class="enrollStudent" 
                         value="${true}" />
                     
                     
                     </legend>
                    <div class="field">
                        <label for="student.firstName">First Name : </label> 

                        <input type="text" id="firstName" 
                        name="student.firstName" 
                        value="${fieldValue(bean:studentInstance,field:'firstName')}"/><br />
                    </div>
                                 
                    <div class="field">
                        <label for="student.middleName">Middle Name: </label> 

                        <input type="text" id="middleName" 
                        name="student.middleName" 
                        value="${fieldValue(bean:studentInstance,field:'middleName')}"/><br />
                    </div>
                                 
                    <div class="field">
                        <label for="student.lastName">Last Name: </label> 

                        <input type="text" id="lastName" 
                        name="student.lastName" 
                        value="${fieldValue(bean:studentInstance,field:'lastName')}"/><br />
                    </div>                                
                    <div class="field">
                        <label for="studentSignupDate">Signup Date</label>
                        <input class="hasDatePicker" type="text" 
                                    id="studentSignupDate" 
                                    name="studentSignupDate" 
                                    value="${studentSignupDate ?: new Date().format('MM/dd/yyyy')}" />
                    </div>
                    <div class="field">
                        <label for="lastName">Interests</label> 
                        <enrollio:courseDropDown studentInstance="${studentInstance}" 
                                               possibleInterests="${possibleInterests}" />
                    </div>
                </fieldset>
                <div style="float:left">
                    <g:actionSubmit value="Save" action="save" />
                </div>
            </g:form>
        </div>
    </body>
</html>
