<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="classSession" />
        <title>Class Session: ${classSessionInstance.name}</title>
    </head>
    <body>
        <g:render template="/common/messages" />
        <div id="someMenu" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
            <a href="#"></a>
        </div>
        <div id="contentContainer" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
            <ul id="ulSecond" class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-bottom">
                <g:each var="course" in="${courseInstanceList}">
                <li class="ui-state-default ui-corner-top ${course.id == classSessionInstance.course.id ? 'ui-tabs-selected ui-state-active' : ''}">
                        <g:link id="${course.id}" action="show" controller="course">${course.name}</g:link>
                </li>
                </g:each>
            </ul>
            <div class="ui-tabs-panel ui-widget-content ui-corner-bottom">
                <h3>${classSessionInstance.name}, <enrollio:formatDate date="${classSessionInstance.startDate}" /></h3>
            <table id="lessonDates" style="width:40%;float:left;" class="ui-widget ui-widget-content">
                <thead>
                    <tr><th colspan="2" class="ui-widget-header2">Dates</th></tr>
                </thead>
                <tbody>
                    <g:each var="lessonDate"
                    in="${classSessionInstance.lessonDates}">
                        <tr>
                            <td>
                                <g:link controller="classSession"
                                action="attendance" 
                                id="${lessonDate.classSession.id}"
                                params="['lessonDateId':lessonDate.id]"
                                >
                                ${lessonDate.lesson.name}</g:link>
                            </td>
                            <td>
                                <enrollio:formatDate date="${lessonDate.lessonDate}" />
                            </td>
                        </tr>
                    </g:each>
                </tbody>
            </table>
            <table id="enrollments" style="width:40%;float:left;" class="ui-widget ui-widget-content">
                <thead>
                    <tr>
                        <th colspan="2" class="ui-widget-header2">Enrollments

                            <g:link name="editEnrollmentsLink" class="groupadd"
                            controller="course"
                            action="interestedStudents" id="${classSessionInstance.course.id}"
                            params="[ classSessionId :classSessionInstance.id ]">Add</g:link>
                        </th>
                    </tr>



                    </td></tr>
                </thead>
                <tbody>
                    <g:each var="enr"
                    in="${classSessionInstance.enrollments}">
                    <tr>
                        <td>
                            <g:link controller="student"
                            action="show"
                            id="${enr.student.id}">${enr.student}</g:link>
                        </td>
                        <td>${enr.status.name}</td>
                    </tr>
                    </g:each>
                </tbody>
            </table>
                        </div>
                    </div>
                </div>
        </div>
            </div>
    </body>
</html>
