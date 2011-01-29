
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
        <title>Edit Lesson:</title>
    </head>
    <body>
        <g:render template="/common/messages" />
        <div class="ui-tabs ui-widget ui-widget-content">
            <g:render template="/course/coursesHeader"
                model="[ currentCourse : lessonInstance.course ]" />
            <div style="overflow:hidden;" class="ui-tabs-panel ui-widget-content ui-corner-bottom">
            <ul class="menuList">
                <li>
                    <g:link class="book_edit" controller="lesson" action="edit" id="${lessonInstance.id}">Edit</g:link>
                </li>
            </ul>
        <div class="body">
            <h1>Edit Lesson:</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${lessonInstance}">
            <div class="errors">
                <g:renderErrors bean="${lessonInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form name="editLessonForm" action="update" method="post" >
                <input type="hidden" name="id" value="${lessonInstance?.id}" />
                <input type="hidden" name="version" value="${lessonInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name">Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:lessonInstance,field:'name','errors')}">
                                    <input type="text" id="name" name="name" value="${fieldValue(bean:lessonInstance,field:'name')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="course">Course:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:lessonInstance,field:'course','errors')}">
                                    <g:select optionKey="id" from="${org.bworks.bworksdb.Course.list()}" name="course.id" value="${lessonInstance?.course?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description">Description:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:lessonInstance,field:'description','errors')}">
                                    <g:textArea name="description" 
                                        value="${fieldValue(bean:lessonInstance,field:'description')}"
                                        rows="5" cols="50"/>
                                </td>
                            </tr> 
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="sequence">Sequence:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:lessonInstance,field:'sequence','errors')}">
                                    <input type="text" id="sequence" name="sequence" value="${fieldValue(bean:lessonInstance,field:'sequence')}" />
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                        <g:submitButton class="save" name="saveButton" value="Update" />
                            or&nbsp;
                        <g:link name="cancelLink" class="cancelLink" action="show" id="${lessonInstance.id}" >Cancel</g:link>
            </g:form>
        </div>
    </body>
</html>
