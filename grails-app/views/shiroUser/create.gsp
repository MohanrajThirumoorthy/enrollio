

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Create User</title>         
    </head>
    <body>
        <div id="wrapper">
            <div id="content">
                <div class="rightnow">
            <h1>Create User</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${shiroUserInstance}">
            <div class="errors">
                <g:renderErrors bean="${shiroUserInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form name="newUserForm" action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="username">Username:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:shiroUserInstance,field:'username','errors')}">
                                    <input type="text" id="username" name="username" value="${fieldValue(bean:shiroUserInstance,field:'username')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="firstName">First Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:shiroUserInstance,field:'firstName','errors')}">
                                    <input type="text" id="firstName" name="firstName" value="${fieldValue(bean:shiroUserInstance,field:'firstName')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="lastName">Last Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:shiroUserInstance,field:'lastName','errors')}">
                                    <input type="text" id="lastName" name="lastName" value="${fieldValue(bean:shiroUserInstance,field:'lastName')}"/>
                                </td>
                            </tr> 
                        
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="password">Password:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:shiroUserInstance,field:'password','errors')}">
                                    <g:passwordField name="password" value="${fieldValue(bean:shiroUserInstance,field:'password')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="passwordConfirm">Password Confirm:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:shiroUserInstance,field:'passwordConfirm','errors')}">
                                    <g:passwordField name="passwordConfirm" value="${fieldValue(bean:shiroUserInstance,field:'passwordConfirm')}" />
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <label for="saveButton"></label>
                <g:submitButton class="save" name="saveButton" value="Save" />
                    or&nbsp;
                <g:link name="cancelLink" class="cancelLink" action="list" >Cancel</g:link>
            </g:form>
        </div>
        </div>
        </div>
        <div id="sidebar">
            <g:render template="/admin/adminMenu" />
        </div>
    </body>
</html>
