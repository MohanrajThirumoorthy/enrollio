<%@ page import="org.bworks.bworksdb.Lesson" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
        <title>Lessons</title>
    </head>
    <body>
        <div id="wrapper">
            <div id="content">
                <div class="rightnow">
                    <h3 class="reallynow">
                        <span>Lessons</span>
                        <br />
                    </h3>
                        <p class="youhave">List of courses/lessons taught.</p>
                </div>
                <g:each in="${courseInstanceList}" status="i" var="courseInstance">
                    <g:render template="lessonList" model="[courseInstance:courseInstance]" />
                </g:each>
            </div>
        </div>
    </body>
</html>
