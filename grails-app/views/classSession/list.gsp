<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="main" />
    <meta name="tabName" content="classSession" />
    <title>Sessions</title>
</head>

<body>
    <div style="height:400px;width:400px;border:1px solid;">
        <div>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum </div>
<div style="float:left;width:30%;" class="ui-widget ui-widget-content ui-corner-all">
                    <div class="ui-widget-header ui-corner-all ui-helper-clearfix">
                        <span class="ui-dialog-title" id="ui-dialog-title-dialog">Lessons</span>
                    </div>
                    <div id="dialog" class="ui-dialog-content ui-widget-content" style="width: auto; min-height: 101.6px; height: auto;">
                        <ul>
                                <li>Barf </li>
                                <li>Barf </li>
                                <li>Barf </li>
                                <li>Barf </li>
                        </ul>
                    </div>
                </div>
        <div style="float:left;width:30%;" class="ui-widget ui-widget-content ui-corner-all">
                    <div class="ui-widget-header ui-corner-all ui-helper-clearfix">
                        <span class="ui-dialog-title" id="ui-dialog-title-dialog">Lessons</span>
                    </div>
                    <div id="dialog" class="ui-dialog-content ui-widget-content" style="width: auto; min-height: 101.6px; height: auto;">
                        <ul>
                                <li>Barf </li>
                                <li>Barf </li>
                                <li>Barf </li>
                                <li>Barf </li>
                        </ul>
                    </div>
                </div>
    </div>

    <g:each var="classSessionInstance" in="${classSessionInstanceList}">
    <p>${classSessionInstance.name} <enrollio:formatDate date="${classSessionInstance.startDate}" /></p>

    </g:each>
</body>
