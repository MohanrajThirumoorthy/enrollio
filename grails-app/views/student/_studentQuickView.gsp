<td>
    <span starId="${studentInstance.id}" class="star">
        <g:render template="/utility/starredThingy" model="[thingy:studentInstance]" />
    </span>
    <g:link action="edit" name="editStudentLink${studentInstance.id}" 
    id="${studentInstance.id}" controller="student"
    title="${studentInstance}">
    ${studentInstance}<br />
    </g:link>
        <g:if test="${studentInstance.birthDate}">
        Birth Date: <enrollio:formatDate date="${studentInstance.birthDate}" /><br />
        </g:if>
        <g:if test="${studentInstance.grade}">
            Grade: ${fieldValue(bean:studentInstance, field:'grade')}<br />
        </g:if>
        <g:if test="${studentInstance.emailAddress}">
            Email Address: ${fieldValue(bean:studentInstance, field:'emailAddress')}<br />
        </g:if>
        <g:if test="${studentInstance.gender}">
           Gender: ${fieldValue(bean:studentInstance, field:'gender')}<br />
        </g:if>
</td>
<td>
    <table>
        <tr class="prop">
            <td  valign="top" style="text-align:left;" class="value">
                <g:activeInterestLinks student="${studentInstance}"
                contactCallListPositions="${contactCallListPositions}"/>
            </td>
        </tr>
    </table>
</td>
<td>
    <table>
        <g:each var="enr" in="${studentInstance.enrollments}">
            <tr>
                <td>
                ${enr.classSession.course.name} <g:link controller="classSession" action="show" id="${enr.classSession.id}"> <enrollio:formatDate date="${enr.classSession.startDate}" /> </g:link>
                </td>
            </tr>
        </g:each>
    </table>
</td>
