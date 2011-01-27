
<%@ page import="org.bworks.bworksdb.Lesson" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
	<script type="text/javascript" src="${resource(dir:'js', file:'lessonSort.js')}"></script>
	<script type="text/javascript" src="${resource(dir:'js', file:'lessonCreate.js')}"></script>
        <title>Create Lesson:</title>         
    </head>
    <body>
        <g:render template="/common/messages" />
        <div id="secondMenu" class="ui-tabs ui-widget ui-widget-content">
            <g:render template="/course/coursesHeader"
                model="[ courseInstanceList : courseInstanceList, currentCourse : lessonInstance.course ]" />
            <div style="overflow:hidden;" class="ui-tabs-panel ui-widget-content ui-corner-bottom">
                <g:form action="save" method="post" name="newLessonForm">
                <div class="box">
                <h3>Create Lesson</h3>
                <g:hasErrors bean="${lessonInstance}">
                    <div class="errors">
                        <g:renderErrors bean="${lessonInstance}" as="list" />
                    </div>
                </g:hasErrors>
                    <label for="name">Name : </label> 
                    <input name="id" id="id" type="hidden" value="${lessonInstance.id}" />
                    <input type="text" id="name" name="name" value="${fieldValue(bean:lessonInstance,field:'name')}"/><br />
                    <input type="hidden" id="sequence" class="value ${hasErrors(bean:lessonInstance,field:'sequence','errors')}" name="sequence" value="${fieldValue(bean:lessonInstance,field:'sequence')}" /><br />
                    <input type="hidden" name="course.id" id="course.id" value="${lessonInstance.course.id}" />
                    <label for="description">Description:</label>
                        <g:textArea name="description" 
                            value="${fieldValue(bean:lessonInstance,field:'description')}"
                            rows="5" cols="40"/>
                        <br />
                </div>
                <div class="box">
                    <g:render template="/course/sortLessons"
                              model="[courseInstance : lessonInstance.course,
                              lessonInstance  : lessonInstance]" />
                </div>

                    <label for="saveButton"></label>
                    <g:submitButton class="save" name="saveButton" value="Save" />
                        or&nbsp;
                        <g:if test="${cancelLink}">
                        <a href="${cancelLink}">Cancel</a>
                        </g:if>
                        <g:else>
                        <g:link name="cancelLink" class="cancelLink" controller="course"
                        id="${lessonInstance.course?.id}" action="show" >Cancel</g:link>
                        </g:else>
            </g:form>
    </body>
</html>
