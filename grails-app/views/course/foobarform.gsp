<g:form action="saveEnrollments" controller="course">
<g:each var="classSession" in="${classSessionInstanceList}">
<div class="field">
<label for="classSession${classSession.id}">${classSession.name} <enrollio:formatDate date="${classSession.startDate}" /></label>
<g:checkBox id="enrollInSession${classSession.id}"
    name="classSession['${classSession.id}']"
    class="enrollStudent"
    value="${classSession.enrollments.find { it.student.id == studentInstance.id }}" />
</div>
</g:each> 
</g:form>
