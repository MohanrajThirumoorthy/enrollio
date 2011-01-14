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
    <g:if test="${courseInstanceList.size() > 1}">
        <div id="secondMenu" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
            <ul id="ulSecond" class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-bottom">
                <g:each var="course" in="${courseInstanceList}">
                <li class="ui-state-default ui-corner-top ${course.id == courseInstance.id ? 'ui-tabs-selected ui-state-active' : ''}">
                        <g:link id="${course.id}" action="show" controller="course">${course.name}</g:link>
                    </li>
                </g:each>
            </ul>
            <div class="ui-tabs-panel ui-widget-content ui-corner-bottom">
                <g:render template="individualCourseMenu" />
                <p class="youhave">${courseInstance.name}</p>
                <p class="youhave">${courseInstance.description}</p>
                <p class="youhave">${activeInterestCount} interested Students</p>
                <div>
                <div class="ui-widget ui-widget-content ui-corner-all">
                    <div class="ui-widget-header ui-corner-all ui-helper-clearfix">
                        <span class="ui-dialog-title" id="ui-dialog-title-dialog">Lessons</span>
                    </div>
                    <div id="dialog" class="ui-dialog-content ui-widget-content" style="width: auto; min-height: 101.6px; height: auto;">
                        <ul>
                                <g:each var="lesson" in="${courseInstance.lessons}">
                                <li>
                                            <g:link controller="lesson" action="show"
                                            id="${lesson.id}">
                                            ${lesson?.encodeAsHTML()}</g:link>
                                </li>
                                </g:each>
                        </ul>
                    </div>
                </div>
                <div class="ui-widget ui-widget-content ui-corner-all">
                    <div class="ui-widget-header ui-corner-all ui-helper-clearfix">
                        <span class="ui-dialog-title" id="ui-dialog-title-dialog">Sessions</span>
                    </div>
                    <div id="dialog" class="ui-dialog-content ui-widget-content" style="width: auto; min-height: 101.6px; height: auto;">
                        <ul>
                                <g:each var="session" in="${courseInstance.classSessions}">
                                <li>
                                            <g:link controller="classSession"
                                            action="show" id="${session.id}">
                                            ${session?.name}</g:link>
                                </li>
                                </g:each>
                        </ul>
                    </div>
                </div>
                </div>
            </div>
        </div>
    </g:if>
    </body>
</html>
