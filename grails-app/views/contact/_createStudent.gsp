<%@ page import="org.bworks.bworksdb.Course;" %>
<fieldset class="horizontal ui-widget ui-widget-content" style="float: left;">
<g:hasErrors bean="${studentInstance}">
    <div class="ui-widget">
        <div style="" class="ui-state-error ui-corner-all"> 
            <p>
            <span style="float: left; margin-right: 0.3em;" 
                class="ui-icon ui-icon-alert">
            </span> 
            <strong>Alert:</strong> 
            <g:renderErrors bean="${studentInstance}" as="list" />
            </p>
        </div>
    </div>
</g:hasErrors>
    <input type="hidden" id="contact.id" name="contact.id" value="${contactInstance?.id}" />
    <legend class="ui-corner-all">Student
    <g:if test="${optionalForm}">
         <g:checkBox name="newStudentOption" class="enrollStudent" value="${true}" />
    </g:if>
    </legend>
    <div>
    <div class="field">
        <label for="student.firstName">First Name : </label> 
        <g:textField name="student.firstName" value="${studentInstance.firstName}" />
    </div>

    <div class="field">
        <label for="student.middleName">Middle Name: </label> 
        <g:textField name="student.middleName" value="${studentInstance.middleName}" />
    </div>

    <div class="field">
        <label for="student.lastName">Last Name: </label> 
        <g:textField name="student.lastName" value="${studentInstance.lastName}" />
    </div>                                
    <div class="field">
        <label for="studentSignupDate">Signup Date:</label>
        <input class="hasDatePicker" type="text" 
                    id="studentSignupDate" 
                    name="studentSignupDate" 
                    value="${studentSignupDate ?: new Date().format('MM/dd/yyyy')}" />
    </div>
</div>
<div style="margin-top:10px;float:left;">
        <g:each var="course" in="${Course.list()}">
        <div class="field" 
            style="padding:2px;margin:2px;border:1px solid;background-color:#F5F5F5">
            <label style="display:inline;" for="interestInCourse[${course.id}]">${course}</label>
            <g:checkBox style="display:inline;" 
                         name="interestInCourse" 
                         value="${course.id}" 
                         checked="${possibleInterests?.indexOf(course.id)}"/>
        </div>
        </g:each>
</div>
</fieldset>
