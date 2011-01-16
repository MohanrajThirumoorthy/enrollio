<%@ page import="org.bworks.bworksdb.EnrollmentStatus;org.bworks.bworksdb.ClassSession" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="classSession" />
        <title>Graduation: ${classSessionInstance.name}</title>
        <script type="text/javascript">
             $(document).ready(function(){
                $('.statusSwitcher').change(function(){
                    $.post('${createLink(controller:"enrollment",
                                             action:"enrollmentStatus")}',
                                             { 'status' : $(this).val(), 
                                                   'id' : $(this).attr("enrollmentId") });
                    });
                $('.stillInterested').change(function(){
                    $.post('${createLink(controller:"interest",
                                             action:"updateInterest")}',
                                             { 'active' : $(this).attr('checked'), 
                                                   'id' : $(this).attr("interestId") });
                    });
                // When user pressed "Graduate all", we switch everyone's status to
                // graduated or 'in progress'.  We also select/desect the "still interested" boxen.
                $("#graduateAll").toggle(
                    function(){
                        $(this).text("In Prog. All");
                        $('.statusSwitcher').each(function() {
                            $(this).val("GRADUATED")
                            $(this).change()
                            });

                        $('.stillInterested').each(function() {
                            $(this).attr('checked',false);
                            $(this).change();
                        })
                        $('#allStillInterested').attr('checked', false);

                    }
                        
                        ,

                    function(){
                        $(this).text("Grad. All");
                        $('.statusSwitcher').each(function() {
                            $(this).val("IN_PROGRESS")
                            $(this).change()
                            });
                        $('.stillInterested').each(function() {
                            $(this).attr('checked',true);
                            $(this).change();
                            });
                        $('#allStillInterested').attr('checked', true);
                        }
                        );
                $("#allStillInterested").click(
                    function(){
                        var checked = $(this).attr('checked');
                        $('.stillInterested').each(function() {
                            $(this).attr('checked',checked);
                            $(this).change();
                        })
                    });

                });
        </script>
    </head>
    <body>
        <div id="container">
            <div id="wrapper">
                <div id="content">
                    <div class="rightnow">
                        <h3 class="reallynow">
                            <span>Graduation: ${classSessionInstance.name}</span>
                            <br />
                        </h3>
                            <table>
                                <thead>
                                    <th>Student
                                    
                                    </th>
                                    <th rowspan="2">Status
                                    
                                        <div>
                                        <a href="#" id="graduateAll">Grad. All</a></div>
                                    </th>
                                    <th>Still Interested?
                                        <input type="checkbox" 
                                                 id="allStillInterested" />
                                    
                                    </th>
                                    <th width="60%">Attendance</th>
                                </thead>
                                <tbody>
                                    <g:each var="enrollmentInstance" in="${classSessionInstance.enrollments}">
                                        <tr>
                                            <td>
                                                <g:link action="show"
                                                controller="student"
                                                id="${enrollmentInstance.student.id}">
                                                ${enrollmentInstance.student}</g:link>
                                            </td>
                                            <td>
                                                <g:render template="enrollmentStatus" 
                                                model="[enrollmentInstance : enrollmentInstance]" />
                                            </td>
                                            <td>
                                                <g:checkBox class="stillInterested" 
                                                             name="stillInterested${enrollmentInstance.student.id}"
                                                    interestId="${interestsInCourse[enrollmentInstance.student.id]?.id}"
                                                    value="${interestsInCourse[enrollmentInstance.student.id]?.active}" />
                                            </td>
                                            <td>
                                            <enrollio:studentAttendanceSummary 
                                                summary="${attendancesForSession[enrollmentInstance.student.id]}" />
                                            </td>
                                        </tr>
                                    </g:each>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <div id="sidebar">
                    <g:render template="individualClassSessionMenu" 

                    model="[showGradCertsLink:true, classSessionInstance:classSessionInstance]" />
                </div>
            </div>
        </div>
    </body>
</html>
