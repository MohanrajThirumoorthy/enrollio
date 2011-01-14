<%@ page import="org.bworks.bworksdb.Student" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="student" />    
        <title>Student List</title>
    </head>
    <body>
    <div id="someMenu" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
        <g:link action="create" controller="student" 
                id="newStudentLink" class="user_add">&#160;New Student</g:link>
    </div>
    <div id="students">
            <table>
                <thead>
                    <tr>
                        <th>Column </th>
                        <th>Students </th>
                        <th>Info</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${contactInstanceList}" status="i" var="contactInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td>
                            <g:link controller="contact" action="show" 
                            name="contactLink_${contactInstance.id}" 
                            id="${contactInstance.id}">${contactInstance.fullName()}</g:link>
                        </td>
                        <td>
                            <enrollio:contactStudentList contact="${contactInstance}" />
                        </td>
                        <td>${contactInstance.fullAddress() + ' ' +
                            contactInstance.abbrevPhoneNumbers()}</td>
                    </tr>
                    </g:each>
                </tbody>
            </table>
            <div class="paginateButtons">
                <g:if test="prevQuery">
                <g:paginate params="[q:prevQuery]" total="${contactInstanceTotal}" />
                </g:if>
                <g:else>
                <g:paginate total="${contactInstanceTotal}" />
                </g:else>
            </div>
        </div>
        </div>
    </body>
</html>
