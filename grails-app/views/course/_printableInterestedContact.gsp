<table>
<tr>
    <td colspan="2">
        ${callListContacts[contactInstance.id]?.callListPosition})
        ${contactInstance}
       <enrollio:signupDateForCourse contactInstance="${contactInstance}" courseInstance="${courseInstance}" />
        <g:if test="${callListContacts[contactInstance.id]?.user}">
            <b>(${callListContacts[contactInstance.id]?.user})</b>
        </g:if>
       <span style="float:right"> ${contactInstance.phoneNumbers?.join(", ")}</span>
   </td>
</tr>
<tr>
    <td>
        <ul class="prop">
            <li>
                <g:if test="${contactInstance.address1}">${contactInstance.address1}, &#160;&#160;</g:if>
                <g:if test="${contactInstance.address2}">${contactInstance.address2}</g:if>
                <g:if test="${contactInstance.city}">${contactInstance.city},&#160;&#160;</g:if>
                <g:if test="${contactInstance.state}">${contactInstance.state}&#160;</g:if>
                <g:if test="${contactInstance.zipCode}">${contactInstance.zipCode}&#160;&#160;</g:if>
            </li>
            
        <g:if test="${contactInstance.comments}">
        <li><b>Note:</b>
        <comments:each bean="${contactInstance}">
            <b>*</b> ${comment.body.encodeAsHTML()}
        </comments:each></li>
        </g:if>
        </ul>
    </td>
    <td>
        <table>
            <g:each var="stud" in="${contactInstance.students}">
            <tr>
            <td>
                <span class="star">
                    <g:render template="/utility/starredThingy" model="[ hideGreyStar : true, thingy : stud]" />
                </span>
                    ${stud}
                </td>
                <td><enrollio:enrollmentAbbreviations studentInstance="${stud}" /></td>
            </tr>
            </g:each>
        </table>
    </td>
</tr>
</table>
