<%@ page import="org.bworks.bworksdb.ConfigSetting" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>Load Test Data</title>
    </head>
    <body>
        <div id="wrapper">
            <div id="content">
        <div class="rightnow">
        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>
        <div>
        
        <g:form action="generateTestSessions" method="post">
            <div class="dialog">
                <h1>Load Test Class Sessions</h1>
            </div>
            <input type="text" name="moreSessions" value="0" />
            <div class="buttons">
                <span class="button">
                    <input class="save" type="submit" value="Go!" />
                </span>
            </div>
        </g:form>
        </div>
        <div>
        <g:form action="generateTestContacts" method="post">
            <div class="dialog">
                <h1>Load Test Data</h1>
                <div class="dialog">
                    <label for="value">Number of Contacts to Generate:</label>
                    <input type="text" id="contactNum" name="numContacts" value="100" />
                </div>
            </div>
            <div class="buttons">
                <span class="button">
                    <input class="save" type="submit" value="Create" />
                </span>
            </div>
        </g:form>
        
        </div>
        <div>
        <g:form action="generateTestCourses" method="post">
            <div class="dialog">
                <h1>Create Default Courses (EAC, Adult, Mentorship)</h1>
            </div>
            <div class="buttons">
                <span class="button">
                    <input class="save" type="submit" value="Create Default Courses" />
                </span>
            </div>
        </g:form>
        </div>
    </div>
    </div
    </div
    </body>
</html>
