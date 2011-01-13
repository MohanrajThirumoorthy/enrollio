<div class="container_16">
    <g:if test="${flash.message}">
        <div class="grid_16">
            <div class="message">${flash.message}</div>
        </div>
    </g:if>
    <g:hasErrors bean="${contactInstance}">
        <div class="grid_16 errors">
            <g:renderErrors bean="${contactInstance}" as="list" />
        </div>
    </g:hasErrors>
    <div class="grid_8">
        <input type="hidden" name="id" value="${contactInstance?.id}" />
        <input type="hidden" name="version" value="${contactInstance?.version}" />
        <table>
            <tbody>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="firstName">First Name:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:contactInstance,field:'firstName','errors')}">
                        <input type="text" id="firstName" name="firstName" value="${fieldValue(bean:contactInstance,field:'firstName')}"/>
                    </td>
                </tr> 

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="lastName">Last Name:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:contactInstance,field:'lastName','errors')}">
                        <input type="text" id="lastName" name="lastName" value="${fieldValue(bean:contactInstance,field:'lastName')}"/>
                    </td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="address1">Address1:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:contactInstance,field:'address1','errors')}">
                        <input type="text" id="address1" name="address1" value="${fieldValue(bean:contactInstance,field:'address1')}"/>
                    </td>
                </tr> 

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="address2">Address2:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:contactInstance,field:'address2','errors')}">
                        <input type="text" id="address2" name="address2" value="${fieldValue(bean:contactInstance,field:'address2')}"/>
                    </td>
                </tr> 

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="city">City:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:contactInstance,field:'city','errors')}">
                        <input type="text" id="city" name="city" value="${fieldValue(bean:contactInstance,field:'city')}"/>
                    </td>
                </tr> 

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="state">State:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:contactInstance,field:'state','errors')}">
                        <input type="text" id="state" name="state" value="${fieldValue(bean:contactInstance,field:'state')}"/>
                    </td>
                </tr> 

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="zipCode">Zip Code:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:contactInstance,field:'zipCode','errors')}">
                        <input type="text" id="zipCode" name="zipCode" value="${fieldValue(bean:contactInstance,field:'zipCode')}"/>
                    </td>
                </tr> 
            </tbody>
        </table>
    </div>
    <div class="grid_8"> 
                <enrollio:phoneNumberInput 
                    phoneNumberList="${contactInstance.phoneNumbers}" />
        <table>
            <tbody>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="emailAddress">Email Address:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:contactInstance,field:'emailAddress','errors')}">
                        <input type="text" id="emailAddress" name="emailAddress" value="${fieldValue(bean:contactInstance,field:'emailAddress')}"/>
                    </td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="noteText">Note:</label>
                    </td>
                    <td valign="top">
                        <g:textArea name="noteText" 
                        value="${noteText}"
                        rows="2" cols="30"/>
                    </td>
                </tr>
                <g:if test="${showDrop}">
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="cannotReach">Drop - Cannot Reach</label>
                        <g:checkBox name="cannotReach" value="${contactInstance?.cannotReach}" ></g:checkBox>
                    </td>
                </tr>
                </g:if>
            </tbody>
        </table>
    </div>
</div>
