<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="admin" />
        <title>Admin</title>
    </head>
    <body>
        <div class="ui-tabs ui-widget ui-widget-content">
            <div id="someMenu" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
                <ul>
                    <h3>Admin</h3>
                    <li><g:link class="group" controller="shiroUser" action="list">Users</g:link></li>
                    <li><g:link class="app_form" controller="configSetting" action="list">Settings</g:link></li>
                    <li><g:link class="group" controller="configSetting" action="testDataRequest">Test Data</g:link></li>
                    <!-- <g:link class="group" controller="configSetting" action="loadDataRequest">Import Data</g:link> -->
                </ul>
                <ul>
                    <h3>Search settings</h3>
                    <li><g:link class="zoom_in" controller="admin" action="startMirroring">Start Mirroring</g:link> </li>
                    <li<g:link class="zoom_out" controller="admin" action="startMirroring">Stop Mirroring</g:link> </li
                </ul>
            </ul>
        </div>
        </div>
    </body>
</html>
      

