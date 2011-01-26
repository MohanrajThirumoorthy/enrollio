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
    <tr id="student${stud.id}">
        <td>
            <g:render template="/utility/starredThingy" model="[thingy:stud, hideGreyStar : true]" />
            <!-- <g:link controller="course" params="[studentId:stud.id]" action="enrollStudent" id="${courseInstance.id}"> -->
            <a href="#" class="enrollStudent">    <img border="none" alt="Enroll" src="${resource(dir:'/images/icons', file:'date_add.png')}" />
            </a>
            <!-- </g:link> -->
            <g:link controller="student" action="edit" id="${stud.id}">${stud}</g:link>
        </td>
        <td>
            <g:each var="enrollment" in="${stud.enrollments}">
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
    </g:each>
