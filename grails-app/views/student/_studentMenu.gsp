<ul>
    <li>
        <g:link name="newStudentLink" class="useradd" controller="contact" action="create">New Student</g:link>
    </li>
    <g:if test="${contactInstance && actionName != 'create' }">
        <g:if test="${actionName == 'show'}">
            <li>
                <g:link name="editStudentLink" class="useredit" controller="contact" action="edit" id="${contactInstance.id}">Edit Contact Info</g:link>
            </li>
        </g:if>
        <g:else>
            <li>
                <g:link name="showContactLink" class="useredit" controller="contact" action="show" id="${contactInstance.id}">Show Contact Info</g:link>
            </li>
        </g:else>
    </g:if>
</ul>
