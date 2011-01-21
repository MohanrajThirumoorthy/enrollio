<tr class="${contactInstance.id.toString() == selectedContactId.toString() ? 'selectedLight' : ''}">
    <td>
        <g:link controller="contact" 
           action="show" id="${contactInstance.id}">${callListContacts[contactInstance.id]?.callListPosition}) ${contactInstance}</g:link>

        <ul class="prop">
        
            <li>
           <!-- ${contactInstance.abbrevPhoneNumbers()} -->
            <g:if test="${contactInstance.address1}"> ${contactInstance.address1}</g:if>
            <g:if test="${contactInstance.address2}"> ${contactInstance.address2}</g:if>
            <g:if test="${contactInstance.city}">${contactInstance.city},&#160;&#160;</g:if>
            <g:if test="${contactInstance.state}">${contactInstance.state}&#160;</g:if>
            <g:if test="${contactInstance.zipCode}">${contactInstance.zipCode}&#160;&#160;</g:if>
            </li>
            <g:if test="${contactInstance.emailAddress}"> <li> ${contactInstance.emailAddress}</li> </g:if>
        </ul>
    </td>

    <td>
        <table>
        <g:each var="stud" in="${contactInstance.students}">
        
        <tr>
            <td>
            <g:render template="/utility/starredThingy" model="[thingy:stud, hideGreyStar : true]" />
            <g:link controller="student" action="edit" id="${stud.id}">${stud}</g:link>
            </td>
            <td>
            <a href="#">Enroll</a>
            </td>
        </tr>
        </g:each>
        </table>
    
    
    </td>
</tr>
