
<%@ page import="org.bworks.bworksdb.Lesson" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
        <title>Show Lesson</title>
    </head>
    <body>
        <g:render template="/common/messages" />
        <div id="secondMenu" class="ui-tabs ui-widget ui-widget-content">
            <g:render template="/course/coursesHeader"
                model="[ currentCourse : lessonInstance.course ]" />
            <div style="overflow:hidden;" class="ui-tabs-panel ui-widget-content ui-corner-bottom">
            <ul class="menuList">
                <li>
                    <g:link class="book_edit" controller="lesson" action="edit" id="${lessonInstance.id}">Edit</g:link>
                </li>
            </ul>
            <h4 class="mainInfo">Lesson: ${lessonInstance}</h4>
                <table>
                    <tbody>
                        <enrollio:textField model="${lessonInstance}" fieldName="description" />
                        <enrollio:textField model="${lessonInstance}" fieldName="sequence" />
                    </tbody>
                </table
                <div class="box">
                <h3>Lesson Dates:</h3>
                <table>
                    <thead>
                        <tr>
                            <td>Session</td>
                            <td>Date</td>
                        </tr>
                    </thead>
                    <tbody>
                        <g:each var="l" in="${lessonInstance.lessonDates}">
                        <tr class="prop">
                            
                            <td valign="top" style="text-align:left;" class="value">
                            <g:link controller="lessonDate" action="show" id="${l.id}">${l?.encodeAsHTML()}</g:link>
                            </td>
                            
                            <td valign="top" class="value">
                                <enrollio:formatDate date="${l.lessonDate}" />
                            
                            </td>
                        </tr>
                        </g:each>
                
                    </tbody>
                </table>
            </div>
        </div>
        </div>
            <div id="sidebar">
                <g:render template="lessonMenu" />
            </div>
    </body>
</html>
