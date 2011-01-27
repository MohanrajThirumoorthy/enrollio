<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
        <title>Course: ${courseInstance} </title>
    </head>
    <body>
    <g:if test="${courseInstanceList.size() > 1}">
        <div id="secondMenu" class="ui-tabs ui-widget ui-widget-content">
            <ul id="ulSecond" class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-bottom">
                <g:each var="course" in="${courseInstanceList}">
                <li class="ui-state-default ui-corner-top ${course.id == courseInstance.id ? 'ui-tabs-selected ui-state-active' : ''}">
                        <g:link id="${course.id}" action="show" controller="course">${course.name}</g:link>
                    </li>
                </g:each>
                <li>
                  <g:link style="padding-left:20px;color:#222222;font-weight:normal;" class="module_add" name="newCourseLink" controller="course" action="create">New Course</g:link>
                </li>
            </ul>
            <div style="overflow:hidden;" class="ui-tabs-panel ui-widget-content ui-corner-bottom">
                <g:render template="individualCourseMenu" />
                <p class="youhave">${courseInstance.description}</p>
                <p class="youhave">${activeInterestCount} interested Students</p>
                <div style="padding:1px;width:50%;float:left;" class="ui-widget ui-widget-content">
                    <div class="ui-widget-header2">
                        <span class="ui-dialog-title">Lessons</span>
                    </div>
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
                <div style="padding:1px;margin-left:1px;width:40%;float:left;" class="ui-widget ui-widget-content">
                    <div class="ui-widget-header2">
                        <span class="ui-dialog-title">Sessions</span>
                    </div>
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
    </g:if>
    </body>
</html>
