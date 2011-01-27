<script type="text/javascript">
    $(document).ready(function() {
        $('.statusSwitcher').click(function() {
            $.post('${createLink(controller:"attendance",
                    action:"updateStatus")}',
                { 'status' : $(this).attr('attendanceStatus'),
                'id'     : $(this).attr('attendanceId') });
        });
        $('#selectAll').click(function() { 
            $(".statusSwitcher[value='present']").each(function() {
                $(this).click();
            });
        });
        $('#selectNone').click(function() { 
            $(".statusSwitcher[value='absent']").each(function() {
                $(this).click();
            });
        });
        $('#attendanceDateSelector').change(function() {
            location.href = 'http://google.com';
        });

    });
</script>
<div id="contentContainer" style="float:left;" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
    <div class="ui-widget-header2 ui-widget-content">
        Attendance
    </div>
    <ul id="ulSecond" class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-bottom">
        <g:each var="lessonDate" in="${lessonDateInstance.classSession.lessonDates}">
        <li class="ui-state-default ui-corner-top ${lessonDateInstance.id == lessonDate.id ? 'ui-tabs-selected ui-state-active' : ''}">
        <g:link id="${lessonDateInstance.classSession.id}" action="attendance" 
        params="['lessonDateId':lessonDate.id]"
        controller="classSession">${lessonDate}</g:link>
        </li>
        </g:each>
    </ul>
    <div class="linksdiv" style="float:right;">
        <a href="#" id="selectNone" class="delete">None</a>
        <a href="#" id="selectAll" class="tick">All</a>
    </div>
    <table>
        <tbody>
            <g:each var="attendance" in="${lessonDateInstance.attendees}">
            <tr>
                <td width="40%">
                    <g:link controller="contact" action="show" 
                    params="[studentId:attendance.student.id]">${attendance.student}</g:link>

                </td>
                <td width="60%">
                    <g:radio class="statusSwitcher" 
                    attendanceId="${attendance.id}" 
                    attendanceStatus="present" 
                    name="status${attendance.id}" 
                    value="present" 
                    checked="${attendance.status == 'present'}"/>&nbsp;Present
                    <g:radio class="statusSwitcher" 
                    attendanceId="${attendance.id}" attendanceStatus="absent" 
                    name="status${attendance.id}" 
                    value="absent" 
                    checked="${attendance.status == 'absent'}" />&nbsp;Absent
                    <g:radio class="statusSwitcher" 
                    attendanceId="${attendance.id}" 
                    attendanceStatus="late" 
                    name="status${attendance.id}" 
                    value="late" 
                    checked="${attendance.status == 'late'}"/>&nbsp;Late
                </td>
            </tr>
            </g:each>
            <g:if test="${!lessonDateInstance.attendees}" /
            <tr>
                <td>
                    No students are enrolled.
                </td>
            </tr>
            </g:if>
        </tbody>
    </table>
</div>
