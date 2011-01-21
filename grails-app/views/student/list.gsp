<%@ page import="org.bworks.bworksdb.Student" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="student" />    
        <title>Student List</title>
    </head>
    <body>
    <g:render template="/common/messages" />
    <g:render template="/contact/contactMenu" />
    <div class="ui-tabs ui-widget ui-widget-content ui-corner-all">
        <table style="border-width:0;width:100%;" class="ui-widget ui-widget-content">
            <thead>
                <tr class="ui-widget-header2">
                    <th>Contact/Parent</th>
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
                    <td>${contactInstance.fullAddress()}<br />
                        ${contactInstance.abbrevPhoneNumbers()}</td>
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
    </body>
</html>
