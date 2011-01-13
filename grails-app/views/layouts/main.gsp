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
        <!--
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css/redmond', file:'jquery-ui-1.7.2.custom.css')}" />
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'theme.css')}" />
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'style.css')}" />
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'theme1.css')}" />
        -->
        <g:layoutHead />
        <nav:resources override="true" />
        <g:javascript library="application" />
    </head>
    <body>
    <div id="header" class="container_16">
        <g:mascotIcon style="vertical-align:middle" />
        <shiro:isLoggedIn>
        <h2 style="display:inline">Welcome to Enrollio, 
        <shiro:principal />!</h2>
        </shiro:isLoggedIn>
        <shiro:isNotLoggedIn>
        <h2 style="display:inline">Welcome to Enrollio!</h2>
        </shiro:isNotLoggedIn>

        <div id="topmenu">
        <nav:render group="mainMenu" /> 
    </div>
    <div id="content" class="container_16">
        <g:layoutBody />
    </div>
    </body>
</html>
