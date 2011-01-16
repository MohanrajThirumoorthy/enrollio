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
            <g:link url="${[controller:'contact', action:'create']}" id="newContactLink" class="module_add">&#160;New</g:link>
        </div>
        <div id="secondMenu" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
        <div class="float-container ui-tabs-panel ui-widget-content ui-corner-bottom">
            <g:hasErrors bean="${contactInstance}">
                <div class="ui-widget">
                    <div style="" class="ui-state-error ui-corner-all"> 
                        <p>
                        <span style="float: left; margin-right: 0.3em;" 
                            class="ui-icon ui-icon-alert">
                        </span> 
                        <strong>Alert:</strong> 
                        <g:renderErrors bean="${contactInstance}" as="list" />
                        </p>
                    </div>
                </div>
            </g:hasErrors>
            <g:form method="post" action="save" controller="contact" >
               <g:render template="editContact" model="[contactInstance:contactInstance]" />
               <g:render template="createStudent" model="[studentInstance:newStudentInstance, optionalForm:true]" />

                <div style="float:left">
                    <g:actionSubmit value="Save" action="save" />
                </div>
            </g:form>
        </div>
    </body>
</html>
