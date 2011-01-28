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
<div style="padding:1px;margin-left:1px;width:40%;float:left;" class="ui-widget ui-widget-content">
<h3 class="ui-widget-header2 ui-widget-content ui-tabs-selected">
    ${lessonDateInstance.lesson.name}
    <div class="linksdiv" style="float:right;">
        <a href="#" id="selectNone" class="delete">None</a>
        <a href="#" id="selectAll" class="tick">All</a>
    </div>
</h3>
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
            <g:if test="${!lessonDateInstance.attendees}" >
            <tr>
                <td>
                    No students are enrolled.
                </td>
            </tr>
            </g:if>
        </tbody>
    </table>
</div>
