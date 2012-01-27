<g:form action="saveEnrollments" controller="course">
<g:hiddenField name="studentId" value="${studentId}" />
<g:each var="classSession" in="${classSessionInstanceList}">
<div class="field">
    <label for="classSession${classSession.id}">${classSession.course.name}: ${classSession.name}</label>
    <enrollio:classSessionCheckbox studentId="${studentId}" 
        classSession="${classSession}" />
</div>
</g:each> 
</g:form>
