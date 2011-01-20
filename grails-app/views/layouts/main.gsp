<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
  "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
    <head>
        <title>
            <g:layoutTitle default="Enrollio" />
        </title>
        <link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon" />
        <!--[if IE]>
        <link rel="stylesheet" type="text/css" href="css/ie-sucks.css" />
        <![endif]-->
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'960.css')}" />
        <script type="text/javascript" src="${resource(dir:'js', file:'jquery-1.4.4.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir:'js', file:'jquery-ui-1.8.7.custom.min.js')}"></script>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'snoogins.css')}" />
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css/redmond', file:'jquery-ui-1.8.7.custom.css')}" />
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'icons.css')}" />
        <g:layoutHead />
        <nav:resources override="true" />
        <g:javascript library="application" />
    </head>
    <body>
    <div class="ui-tabs ui-widget-content ui-corner-all">
        <div id="header" class="ui-widget-header ui-corner-top">
            <g:mascotIcon style="vertical-align:middle" />
            <shiro:isLoggedIn>
            <h2>Welcome to Enrollio, 
                <shiro:principal />!</h2>
                <g:render template="/common/searchForm" />
            </shiro:isLoggedIn>
            <shiro:isNotLoggedIn>
            <h2>Welcome to Enrollio!</h2>
            </shiro:isNotLoggedIn>

        </div>
        <ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-bottom">
            <nav:eachItem group="mainLinks" var="navLink">
                <li class="ui-state-default ui-corner-top ${navLink.active ? 'ui-tabs-selected ui-state-active' : ''}">
                    <g:link action="${navLink.action}" controller="${navLink.controller}">${navLink.title}</g:link>
                </li>
            </nav:eachItem>
            <span style="float:right;">
            <nav:eachItem group="adminLinks" var="navLink">
                <li class="ui-state-default ui-corner-top ${navLink.active ? 'ui-tabs-selected ui-state-active' : ''}">
                    <g:link action="${navLink.action}" controller="${navLink.controller}">${navLink.title}</g:link>
                </li>
            </nav:eachItem>
            <nav:eachItem group="help" var="navLink">
                <li class="ui-state-default ui-corner-top ${navLink.active ? 'ui-tabs-selected ui-state-active' : ''}">
                    <g:link action="${navLink.action}" controller="${navLink.controller}">${navLink.title}</g:link>
                </li>
            </nav:eachItem>
            <nav:eachItem group="login" var="navLink">
                <li class="ui-state-default ui-corner-top ${navLink.active ? 'ui-tabs-selected ui-state-active' : ''}">
                    <g:link action="${navLink.action}" controller="${navLink.controller}">${navLink.title}</g:link>
                </li>
            </nav:eachItem>
            </span>
        </ul>
        </div>
	<div id="content">
            <g:layoutBody />
        </div>
    </body>
</html>
