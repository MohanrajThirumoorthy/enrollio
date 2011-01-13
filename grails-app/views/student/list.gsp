<%@ page import="org.bworks.bworksdb.Student" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="student" />    
        <title>Student List</title>
    </head>
    <body>
        <div id="sidebar" class="grid_3 alpha">
            <g:render template="studentMenu" />
        </div>
        <div id="students" class="grid_13">
            <h3 class="reallynow">Students 
                <br /></h3>
            <table>
                <thead>
                    <tr>
                        <g:sortableColumn property="contact" title="Contact" />
                        <g:sortableColumn property="firstName" title="Student(s)" />
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
