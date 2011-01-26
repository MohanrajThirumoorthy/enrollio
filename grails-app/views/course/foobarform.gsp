Snarf
<!--
<g:each var="classSession" in="${classSessionInstanceList}">
<label for="classSession${classSession.id}">${classSession.abbrev()}</label>
<g:checkBox id="enrollInSession${classSession.id}"
    name="enrollStudent${studentInstance.id}" 
    class="enrollStudent"
    classSessionId="${classSessionInstance.id}" 
    studentId="${studentInstance.id}"
    value="${classSessionInstance.enrollments.find { it.student.id == studentInstance.id }}" />
</g:each> 
-->
