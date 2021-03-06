<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
        <title>Course: ${courseInstance} </title>
    </head>
    <body>
    <g:if test="${courseInstanceList.size() > 1}">
        <g:render template="/common/messages" />
        <div class="ui-tabs ui-widget ui-widget-content">
            <g:render template="/course/coursesHeader"
                model="[showNewCourseLink : true, currentCourse : courseInstance ]" />
            <div style="overflow:hidden;" class="ui-tabs-panel ui-widget-content ui-corner-bottom">
                <g:render template="individualCourseMenu" model="[interestedStudents:activeInterestCount]" />
                <h4 class="mainInfo">${courseInstance.description}</h4>
                <div style="padding:1px;width:50%;float:left;" class="ui-widget ui-widget-content">
                    <div class="ui-widget-header2">
                        Lessons
                        <g:link class="book_next" name="newLessonLink" action="create" controller="lesson" 
                                        params="[ 'course.id' : courseInstance.id ]">New Lesson</g:link>
                        
                    <g:link class="number_list" 
                            name="sortLessonsLink" 
                            action="sortLessons" 
                            controller="course" 
                            params="[ 'id' : courseInstance.id ]">Sort</g:link>
                        
                        
                    </div>
                    <ul>
                        <g:each var="lesson" in="${courseInstance.lessons}">
                            <li>
                                <g:link name="lessonLink${lesson.id}" controller="lesson" action="show" id="${lesson.id}"> ${lesson?.encodeAsHTML()}</g:link>
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
