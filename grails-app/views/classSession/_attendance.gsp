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
<div style="padding:1px;margin-left:1px;width:50%;float:left;" class="ui-widget ui-widget-content">
<div class="ui-widget-header2 ui-widget-content ui-state-default">
    <span class="highlighted-header">${lessonDateInstance.lesson.name} - Attendance</span>
    <div class="linksdiv" style="float:right;">
        <a href="#" id="selectNone" class="delete">None</a>
        <a href="#" id="selectAll" class="tick">All</a>
    </div>
</div>
    <table id="attendance-table">
        <thead>
            <tr>

            	<th>Contact</th>
            	<th>Student</th>
            	<th>Present</th>
            	<th>Absent</th>
            	<th>Late</th>
            </tr>
        </thead>
        <tbody>
            <g:each var="contact" in="${enrollmentData}" status="c">
            <g:each var="student" in="${contact.students}" status="s">
            <g:set var="attendance" value="${attendances[student.id]}" />
            <tr class="${ c%2 == 0 ? 'contact-even' : 'contact-odd'}">
                <g:if test="${s == 0}">
                <td rowspan="${contact.students.size()}">
                    <g:link controller="contact" action="show" id="${contact.contact.id}">${contact.contact.toString()}</g:link>
                </td>
                </g:if>
                <td>
                    <g:link controller="contact" action="show" 
                    params="[studentId:student.id]">${student}</g:link>
                </td>
                <td>
                    <g:radio class="statusSwitcher" 
                    attendanceId="${attendance.id}" 
                    attendanceStatus="present" 
                    name="status${attendance.id}" 
                    value="present" 
                    checked="${attendance.status == 'present'}"/>
                </td>
                <td>
                    <g:radio class="statusSwitcher" 
                    attendanceId="${attendance.id}" attendanceStatus="absent" 
                    name="status${attendance.id}" 
                    value="absent" 
                    checked="${attendance.status == 'absent'}" />
                </td>
                <td>
                    <g:radio class="statusSwitcher" 
                    attendanceId="${attendance.id}" 
                    attendanceStatus="late" 
                    name="status${attendance.id}" 
                    value="late" 
                    checked="${attendance.status == 'late'}"/>
                </td>
            </tr>
            </g:each>
            </g:each>
            <g:if test="${!lessonDateInstance.attendees}" >
            <tr>
                <td>
                    No students are enrolled.
                </td>
            </tr>
            </g:if>
            <tr><td>

        <g:link class="waiting_list" action="interestedStudents" controller="course" id="${classSessionInstance.course.id}">
            Add Students
        </g:link>
                </td>
            

            </tr>
        </tbody>
    </table>
</div>
