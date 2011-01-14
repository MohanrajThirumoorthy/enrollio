<tr class="${contactInstance.id.toString() == selectedContactId.toString() ? 'selectedLight' : ''}">
    <td width="65%">
        <g:link controller="contact" 
           action="show" id="${contactInstance.id}">${callListContacts[contactInstance.id]?.callListPosition}) ${contactInstance}</g:link>

           <span style="float:right">${contactInstance.abbrevPhoneNumbers()}</span>
        <ul class="prop">
        
            <li>
            <g:if test="${contactInstance.address1}"> ${contactInstance.address1}</g:if>
            <g:if test="${contactInstance.address2}"> ${contactInstance.address2}</g:if>
            <g:if test="${contactInstance.city}">${contactInstance.city},&#160;&#160;</g:if>
            <g:if test="${contactInstance.state}">${contactInstance.state}&#160;</g:if>
            <g:if test="${contactInstance.zipCode}">${contactInstance.zipCode}&#160;&#160;</g:if>
            </li>
            <g:if test="${contactInstance.emailAddress}"> <li> ${contactInstance.emailAddress}</li> </g:if>
        </ul>
    </td>

    <td width="35%">
        <ul class="prop">
        <g:each var="stud" in="${contactInstance.students}">
        
        <li>
        <g:render template="/utility/starredThingy" model="[thingy:stud, hideGreyStar : true]" />
         <g:if test="${classSessionInstance}">
             <g:checkBox id="enrollStudent${stud.id}"
             name="enrollStudent${stud.id}" 
             class="enrollStudent" 
             classSessionId="${classSessionInstance.id}" 
             studentId="${stud.id}"
             value="${classSessionInstance.enrollments.find { it.student.id == stud.id }}" />
         </g:if>
        <g:link controller="student" action="edit" id="${stud.id}">${stud}</g:link>
        </li>
        </g:each>

        </ul>
    
    
    </td>
</tr>
