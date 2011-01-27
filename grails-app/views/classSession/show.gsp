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
        <div id="contentContainer" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
            <g:render template="/course/coursesHeader"
                         model="[courseInstanceList : courseInstanceList, currentCourse : classSessionInstance.course]" />
            <div style="overflow:hidden;" class="ui-tabs-panel ui-widget-content ui-corner-bottom">
                <g:render template="/classSession/individualClassSessionMenu" model="[ classSessionInstance : classSessionInstance ]"/>
                <h4 class="mainInfo">${classSessionInstance.name} - <enrollio:formatDate date="${classSessionInstance.startDate}" /></h3>
                <table id="lessonDates" style="width:50%;float:left;" class="ui-widget ui-widget-content">
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
                <table id="enrollments" style="width:50%;float:left;" class="ui-widget ui-widget-content">
                    <thead>
                        <tr>
                            <th colspan="2" class="ui-widget-header2">Enrollments

                                <g:link name="editEnrollmentsLink" class="groupadd"
                                controller="course"
                                action="interestedStudents" id="${classSessionInstance.course.id}"
                                params="[ classSessionId :classSessionInstance.id ]">Add</g:link>
                            </th>
                        </tr>
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
                <g:if test="${lessonDateInstance}">
                    <g:render template="/classSession/attendance" model="[ lessonDateInstance : lessonDateInstance ]" />
                </g:if>
            </div>
        </div>
    </body>
</html>
