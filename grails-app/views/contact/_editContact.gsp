<fieldset style="float:left;" class="ui-widget ui-widget-content">
    <legend class="ui-corner-all">Parent/Contact Info</legend>
    <input type="hidden" name="id" value="${contactInstance.id}" />
    <div class="field">
        <label for="firstName">First Name:</label>
        <input type="text" id="firstName" name="firstName" value="${fieldValue(bean:contactInstance,field:'firstName')}"/>
    </div>
    <div class="field">
        <label for="lastName">Last Name:</label>
        <input type="text" id="lastName" name="lastName" value="${fieldValue(bean:contactInstance,field:'lastName')}"/>
    </div>
    <div class="field">
        <label for="address1">Address1:</label>
        <input type="text" id="address1" name="address1" value="${fieldValue(bean:contactInstance,field:'address1')}"/>
    </div>
    <div class="field">
        <label for="address2">Address2:</label>
        <input type="text" id="address2" name="address2" value="${fieldValue(bean:contactInstance,field:'address2')}"/>
    </div>
    <div class="field">
        <label for="city">City:</label>
        <input type="text" id="city" name="city" value="${fieldValue(bean:contactInstance,field:'city')}"/>
    </div>
    <div class="field">
        <label for="state">State:</label>
        <input type="text" id="state" name="state" value="${fieldValue(bean:contactInstance,field:'state')}"/>
    </div>
    <div class="field">
        <label for="zipCode">Zip Code:</label>
        <input type="text" id="zipCode" name="zipCode" value="${fieldValue(bean:contactInstance,field:'zipCode')}"/>
    </div>

    <div class="field">
        <label for="emailAddress">Email Address:</label>
        <input type="text" id="emailAddress" name="emailAddress" value="${fieldValue(bean:contactInstance,field:'emailAddress')}"/>
    </div>

    <g:if test="${showDrop}">
        <div class="field">
            <label for="cannotReach">Drop - Cannot Reach</label>
            <g:checkBox name="cannotReach" value="${contactInstance?.cannotReach}" ></g:checkBox>
        </div>
    </g:if>

    <g:if test="${showNote}">
        <div class="field">
            <label for="noteText">Note:</label>
            <g:textArea name="noteText" value="${noteText}" rows="2" cols="30"/>
        </div>
    </g:if>
</fieldset>

<fieldset style="float:left;" class="ui-widget ui-widget-content">
    <legend class="ui-corner-all">Phone Numbers</legend>
    <g:each var="phone" status="i" in="${contactInstance.phoneNumbers}">
        <div class="field">
            <g:select from="${['Home', 'Work', 'Mobile', 'Other' ]}"
                      name="phoneNumbers[${i}].label" />
            <input type="text" name="phoneNumbers[${i}].phoneNumber"
                   value="${phone.phoneNumber}"
                   class="phoneNumber" />
        </div>
    </g:each>
</fieldset>

