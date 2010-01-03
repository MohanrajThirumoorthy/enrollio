<tr>
    <td>${student}</td>
    <td>${student.grade ?: ""}</td>
    <td>${student.gender ?: ""}</td>
    <td>${student.birthDate?.toString()}</td>
    <td>
    %{-- TODO create .activeInterests property on Student,
         so we don't need the g:if interest.active --}%
    <g:each var="interest" in="${student.interests}">
        <g:if test="${interest.active}">
            <g:link controller="program" action="show" id="${interest.program.id}">
                ${interest.program.name}
            </g:link>
        </g:if>
    </g:each>
    </td>
</tr>
