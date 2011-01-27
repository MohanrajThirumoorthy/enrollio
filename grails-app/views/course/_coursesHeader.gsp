<%@ page import="org.bworks.bworksdb.Course" %>
<ul id="ulSecond" class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-bottom">
    <g:each var="course" in="${Course.list()}">
        <li class="ui-state-default ui-corner-top ${course.id == currentCourse.id ? 'ui-tabs-selected ui-state-active' : ''}">
        <g:link id="${course.id}" action="show" controller="course">${course.name}</g:link>
        </li>
    </g:each>
    <g:if test="${showNewCourseLink}">
        <li> <g:link style="padding-left:20px;color:#222222;font-weight:normal;" class="module_add" name="newCourseLink" controller="course" action="create">New Course</g:link> </li>
    </g:if>
</ul>
