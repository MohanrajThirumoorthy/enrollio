<g:each var="classSession" in="${classSessionInstanceList}">
<label for="classSession${classSession.id}">${classSession.name} <enrollio:formatDate date="${classSession.startDate}" /></label>
<g:checkBox id="enrollInSession${classSession.id}"
    class="enrollStudent"
    classSessionId="${classSession.id}" 
    value="${classSession.enrollments.find { it.student.id == studentInstance.id }}" />
</g:each> 
