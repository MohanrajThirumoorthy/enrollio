<tr id="studentData${studentInstance.id}">
    <td>
        <g:render template="/utility/starredThingy" model="[thingy:studentInstance, hideGreyStar : true]" />
        <a href="#" studentId="${studentInstance.id}" studentName="${studentInstance}" class="enrollStudent">    <img border="none" alt="Enroll" src="${resource(dir:'/images/icons', file:'date_add.png')}" />
        </a>
        <g:link controller="student" action="edit" id="${studentInstance.id}">${studentInstance}</g:link>
    </td>
    <td>
        <g:each var="enrollment" in="${studentInstance.enrollments}">
        <g:if test="${enrollment.classSession.startDate > new Date()}">
        ${enrollment.classSession}
        </g:if>
        <g:else>
        ${enrollment.classSession} past
        </g:else>
        </g:each>
    </td>
    <td class="studentDetails">&nbsp;</td>
</tr>
