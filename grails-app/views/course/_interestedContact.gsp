<tr class="newContact ${contactInstance.id.toString() == selectedContactId.toString() ? 'selectedLight' : ''}">
    <td class="contactDetails">

        <g:link controller="contact" 
           action="show" id="${contactInstance.id}">${callListContacts[contactInstance.id]?.callListPosition}) ${contactInstance}</g:link>
   </td>
   <td>
           <!-- ${contactInstance.abbrevPhoneNumbers()} -->
            <g:if test="${contactInstance.address1}"> ${contactInstance.address1}</g:if>
            <g:if test="${contactInstance.address2}"> ${contactInstance.address2}</g:if>
            <g:if test="${contactInstance.city}">${contactInstance.city},&#160;&#160;</g:if>
            <g:if test="${contactInstance.state}">${contactInstance.state}&#160;</g:if>
            <g:if test="${contactInstance.zipCode}">${contactInstance.zipCode}&#160;&#160;</g:if>
            <g:if test="${contactInstance.emailAddress}"> ${contactInstance.emailAddress} </g:if>
    </td>
   <td>
       <g:each var="phone" in="${contactInstance.phoneNumbers}">
       <div>
           ${phone.label} - ${phone.phoneNumber}</div>
       </g:each>
   </td>
</tr>
<g:each var="stud" in="${contactInstance.students}">
<tr >
    <td>
        <g:render template="/utility/starredThingy" model="[thingy:stud, hideGreyStar : true]" />
        <a class="enrollStudent" href="#" studentId="${stud.id}" studentName="${stud}" class="enrollStudent">    <img border="none" alt="Enroll" src="${resource(dir:'/images/icons', file:'date_add.png')}" />
        </a>
        <g:link controller="student" action="edit" id="${stud.id}">${stud}</g:link>
    </td>
    <td id="studentEnrollmentData${stud.id}">
        <g:render template="/course/studentEnrollments" model="[studentInstance:stud]" />
    </td>
    <td class="studentDetails">&nbsp;</td>
</tr>
</g:each>
