<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <style>
            @page { 
                size: landscape; 
            }

            tr.contact-odd {
                background-color: #E0E0E0;
            }

            table, tr, td, th {
                border-collapse: collapse;
                border: 1px solid black;
                padding: 3px;
            }

            .notes {
                font-size: small;
                white-space: pre-wrap;
            }

            td.student {
                width: 300px; !important;
           }
        </style>
    </head>
    <body>
        <h3>Attendance: ${classSessionInstance.course.name} - ${classSessionInstance.name}</h3>
        <table>
            <thead>
                <tr>
                    <th>Contact</th>
                    <th style="width:300px; !important">Student</th>
                    <g:each var="lessonDate" in="${classSessionInstance.lessonDates}">
                        <th>${lessonDate.shortInfo()}</th>
                    </g:each>
                </tr>
            </thead>
            <tbody>
                <g:each status="i" var="contact" in="${attendanceContacts}">
                    <g:each status="s" var="student" in="${contact.students}">
                        <tr class="${ i%2 == 0 ? 'contact-even' : 'contact-odd'}">
                            <g:if test="${s == 0}">
                                <td rowspan="${contact.students.size()}">
                                    <div class="parent">${contact.contact.toString()} <br />${contact.info}</div>
                                </td>
                            </g:if>
                            <td class="student">${student.toString()}</td>
                            <g:each var="lessonDate" in="${classSessionInstance.lessonDates}">
                                <td></td>
                            </g:each>
                         </tr>
                    </g:each>
                 </g:each>
            </tbody>
        </table>
    </body>
</html>
