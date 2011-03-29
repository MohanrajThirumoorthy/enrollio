<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <meta name="tabName" content="admin" />    
        <title>Users</title>
    </head>
    <body>
        <div id="wrapper">
            <div id="content">
                <div class="box">
            <h3>Users</h3>
            <g:link class="useradd" controller="shiroUser" action="create">Create</g:link>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	                             
                   	        <g:sortableColumn property="username" title="Username" />
                        
                   	        <g:sortableColumn property="firstName" title="First Name" />
                        
                   	        <g:sortableColumn property="lastName" title="Last Name" />
                        
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${shiroUserInstanceList}" status="i" var="shiroUserInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" 
                                          name="userLink_${shiroUserInstance.username}"
                                          params="[username:shiroUserInstance.username]">
                                          ${fieldValue(bean:shiroUserInstance, field:'username')}
                                          </g:link>
                                      </td>
                        
                                             
                            <td>${fieldValue(bean:shiroUserInstance, field:'firstName')}</td>
                        
                            <td>${fieldValue(bean:shiroUserInstance, field:'lastName')}</td>
                            <td>
                                <!-- TODO refactor this link, and the link
                                in the adminMenu into a taglib -->
                                <g:link action="edit" 
                                name="editUserLink_${shiroUserInstance.username}"
                                params="[username:shiroUserInstance.username]">Edit User</g:link>
                            </td>
                        
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${shiroUserInstanceTotal}" />
            </div>
        </div>
        </div>
    </body>
</html>
