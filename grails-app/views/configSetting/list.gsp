<%@ page import="org.bworks.bworksdb.ConfigSetting" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>Settings</title>
    </head>
    <body>
        <g:render template="/admin/adminMenu" />
        <div id="wrapper">
            <div id="content">
                <div class="rightnow">
                    <h1 class="reallynow">Settings
                        <br /></h1>
                        <table>
                            <thead>
                                <tr>
                                    <g:sortableColumn property="configKey" title="Key" />
                                    <g:sortableColumn property="description"
                                    title="Description" />
                                    <g:sortableColumn property="value" title="Value" />
                                </tr>
                            </thead>
                            <tbody>
                                <g:each in="${configSettingInstanceList}" status="i"
                                var="configSettingInstance">
                                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                        <td>
                                            <g:link action="show"
                                            name="settingLink_${configSettingInstance.id}"
                                            id="${configSettingInstance.id}">
                                            ${fieldValue(bean:configSettingInstance,
                                            field:'configKey')}</g:link>
                                        </td>
                                        <td>${fieldValue(bean:configSettingInstance,
                                        field:'description')}</td>
                                        <td>${fieldValue(bean:configSettingInstance,
                                        field:'value')}</td>
                                    </tr>
                                </g:each>
                            </tbody>
                        </table>
                    <div class="paginateButtons">
                        <g:paginate total="${configSettingInstanceTotal}" />
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
