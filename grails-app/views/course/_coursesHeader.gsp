<ul id="ulSecond" class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-bottom">
    <g:each var="course" in="${courseInstanceList}">
    <li class="ui-state-default ui-corner-top ${course.id == currentCourse.id ? 'ui-tabs-selected ui-state-active' : ''}">
    <g:link id="${course.id}" action="show" controller="course">${course.name}</g:link>
    </li>
    </g:each>
</ul>
