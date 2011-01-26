<g:each var="enrollment" in="${studentInstance.enrollments}">
<g:if test="${enrollment.classSession.startDate > new Date()}">
    ${enrollment.classSession}
</g:if>
<g:else>
    ${enrollment.classSession} past
</g:else>
</g:each>
