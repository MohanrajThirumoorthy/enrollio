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
