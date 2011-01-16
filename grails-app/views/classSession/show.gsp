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
            <div id="wrapper">
                <div id="content">
                    <g:if test="${flash.message}">
                            <div class="message">
                                ${flash.message}
                            </div>
                    </g:if>
                    <g:if test="${flash.error}">
                            <div class="errors">
                                ${flash.error}
                            </div>
                    </g:if>
                    <div class="rightnow">
                        <h3 class="reallynow">
                            <a href="#" class="headerLink calendar">

                                ${classSessionInstance.name}</a>
                            
                        <a href="#"><enrollio:formatDate date="${classSessionInstance.startDate}" 
                                  showTime="true" /></a>
                            
                            
                            <br />
                        </h3>
                        <p class="youhave">
                        <g:link action="show" controller="course" id="${classSessionInstance.course.id}">
                        
                            ${classSessionInstance.course.name} Course
                        </g:link>
                        </p>
                        
                    </div>
                    <div class="infowrap">
                        <div class="infobox">
                            <h3>Lesson Dates</h3>
                            <table id="lessonDates">
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
                        </div>
                        <div class="infobox margin-left">
                            <h3 class="reallynow">
                                <span>Enrollments</span>
                <g:link name="editEnrollmentsLink" class="groupadd"
                controller="course"
                action="interestedStudents" id="${classSessionInstance.course.id}"
                params="[ classSessionId :classSessionInstance.id ]">Add</g:link>
                                <br />
                            </h3>
                            <table>
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
                <div id="sidebar">
                    <g:render template="individualClassSessionMenu" model="[classSessionInstance:classSessionInstance]" />
                </div>
            </div>
    </body>
</html>
