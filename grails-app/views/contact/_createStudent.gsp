<%@ page import="org.bworks.bworksdb.Course;" %>
<g:form action="saveStudent" controller="contact" method="POST" name="newStudentForm">
    <div class="errors">
        <g:renderErrors bean="${studentInstance}" as="list" />
    </div>
    <fieldset class="horizontal ui-widget ui-widget-content" style="float: left;">
        <legend class="ui-widget-header2 ui-corner-all">Add  Student</legend>

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
            <enrollio:courseDropDown studentInstance="${studentInstance}"/>
        </div>
        <div class="field">
            <g:submitButton style="float:right" class="save" name="saveButton" value="Save" />
        </div>
    </fieldset>
</g:form>
