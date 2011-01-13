<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
        <title>Course: ${courseInstance} </title>
    </head>
    <body>
    <div id="someMenu" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
        <g:link url="${[controller:'course', action:'create']}" id="newCourseLink" class="module_add">&#160;New</g:link>
    </div>
    <div id="secondMenu" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
        <ul id="ulSecond" class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-bottom">
            <g:each var="course" in="${courseInstanceList}">
                <li class="ui-state-default ui-corner-top ">
                    <g:link id="${course.id}" action="show" controller="course">${course.name}</g:link>
                </li>
            </g:each>
            </span>
        </ul>
        <div class="ui-tabs-panel ui-widget-content ui-corner-bottom">
            Content goes here
        </div>
    </div>
    </body>
</html>
