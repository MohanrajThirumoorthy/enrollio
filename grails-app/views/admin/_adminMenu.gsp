<div class="linksdiv">
            <g:link class="wrench" controller="admin">Admin</g:link>
            <g:link class="group" controller="shiroUser" action="list">Users</g:link>
            <g:link class="useradd" controller="shiroUser" action="create">Create</g:link>
            <g:if test="${shiroUserInstance?.id}">
                <g:link class="useredit" name="editUserLink" controller="shiroUser" action="edit" params="[username : shiroUserInstance.username ]">Edit User</g:link>
            </g:if>
            <g:link class="app_form" controller="configSetting" action="list">Settings</g:link>
            <g:if test="${configSettingInstance?.id}">
                <g:link class="app_form_edit" 
                name="editSettingLink"
                controller="configSetting" 
                action="edit" id="${configSettingInstance.id}">Edit Setting</g:link>
            </g:if>
            <g:link class="group" controller="configSetting" action="testDataRequest">Test Data</g:link>
            <g:link class="group" controller="configSetting" action="loadDataRequest">Import Data</g:link>
    <h3>Search settings</h3>
                <g:link class="zoom_in" controller="admin" action="startMirroring">Start Mirroring</g:link> 
                <g:link class="zoom_out" controller="admin" action="startMirroring">Stop Mirroring</g:link> 
            <g:link class="group" controller="configSetting" action="testDataRequest">Test Data</g:link>
            <g:link class="group" controller="configSetting" action="loadDataRequest">Import Data</g:link>
</div>
