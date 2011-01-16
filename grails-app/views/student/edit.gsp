
<%@ page import="org.bworks.bworksdb.Student" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
	<script type="text/javascript" src="${resource(dir:'js', file:'date.js')}"></script>
        <script type="text/javascript">
            $(document).ready(function(){
                 // Birth Date picker.
                 // We want to display from -110 years ago to today's year.
                 // NOTE: yearRange is relative to defaultDate (hence the -100:+10)
                 $('#birthDate').datepicker({
                     defaultDate: '-10y',
                     yearRange: '-100:+10', 
                     changeMonth: true,
                     changeYear:  true
                 });
                 $('.hasDatePicker').datepicker({changeYear:true});
                 // When checkbox is clicked, hide/show its buddy DIV that
                 // has the signupDate input box in it.
                 $('[name=interestInCourse]').change(function(){
                     var courseId = $(this).val();
                     $('#signupDateDiv_' + courseId).toggle();
                 });
            });

          </script>
                <meta name="tabName" content="student" />
        <title>Edit Student</title>
    </head>
    <body>
        <div id="wrapper">
            <div id="content">
                <div class="infowrap">
                <div class="infobox">
                    <h3 class="reallynow">Edit Student: ${studentInstance}</h3>
                        <g:if test="${flash.message}">
                        <div class="message">${flash.message}</div>
                        </g:if>
                        <g:hasErrors bean="${studentInstance}">
                        <div class="errors">
                            <g:renderErrors bean="${studentInstance}" as="list" />
                        </div>
                        </g:hasErrors>
            <g:form action="update" name="editStudentForm" method="post" >
                <input type="hidden" name="id" value="${studentInstance?.id}" />
                <input type="hidden" name="version" value="${studentInstance?.version}" />
            <div class="dialog">
                <table>
                    <tbody>

                        <tr class="prop">
                            <td><label for="firstName">First Name : </label> </td>
                            <td>
                                <input type="text" id="firstName" 
                                name="firstName" 
                                value="${fieldValue(bean:studentInstance,field:'firstName')}"/><br />
                            </td> 
                        </tr>
                        <tr class="prop">
                            <td><label for="middleName">Middle Name: </label> </td>
                            <td>
                                <input type="text" id="middleName" 
                                name="middleName" 
                                value="${fieldValue(bean:studentInstance,field:'middleName')}"/><br />
                            </td> 
                        </tr>

                        <tr class="prop">
                            <td><label for="lastName">Last Name: </label> </td>
                            <td>
                                <input type="text" id="lastName" 
                                name="lastName" 
                                value="${fieldValue(bean:studentInstance,field:'lastName')}"/><br />
                            </td> 
                        </tr>


                        <tr class="prop">
                            <td><label for="birthDate">Birth Date : </label></td> 
                            <td>    

                                <g:set var="existingBday"
                                value="${fieldValue(bean:studentInstance, field:'birthDate')}" />

                                <input type="text" id="birthDate" 
                                name="birthDate" 
                                value="${formatDate(format:'MM/dd/yyyy', date:studentInstance?.birthDate)}"
                                />
                                <br />
                            </td> 
                        </tr>

                        <tr class="prop">
                            <td><label for="grade">Grade : </label> </td> 

                            <td>

                                <input type="text" id="grade" 
                                name="grade" 
                                value="${fieldValue(bean:studentInstance,field:'grade')}"/><br />
                            </td>
                        </tr>

                        <tr class="prop">
                            <td><label for="gender">Gender :</label></td> 

                            <td>                <g:select name="gender" from="${['Male', 'Female']}" /><br /></td>
                        </tr>

                        <tr>

                            <td>                <label for="contact">Contact:</label></td>
                            <td>                <g:select optionKey="id" from="${org.bworks.bworksdb.Contact.list()}" name="contact.id" value="${studentInstance?.contact?.id}" ></g:select><br /></td>
                        </tr>

                        <tr>
                            <td>             <label for="emailAddress">Email Address:</label></td>
                            <td>             <input type="text" id="emailAddress" name="emailAddress" value="${fieldValue(bean:studentInstance,field:'emailAddress')}"/></td>
                        </tr>
                    </tbody>
                </table>

            </div>

            </div>
            <div class="infobox margin-left">                <!-- only auto-select the default prog if we have a new student -->
                <h3 class="reallynow">Interests</h3>
                    <g:interestCheckBoxes student="${studentInstance}"  />
                <div class="buttons">
                    <span class="button">
                        <input class="save" type="submit" value="Save" />
                    </span>
                    or&nbsp;
                    <g:link name="cancelLink" class="cancelLink" action="show" id="${studentInstance.id}" >Cancel</g:link>
                </div>
            </div>
            </g:form>
        </div>
        </div>
        </div>
        <div id="sidebar">
                <g:render template="studentMenu" />
        </div>
    </body>
</html>
