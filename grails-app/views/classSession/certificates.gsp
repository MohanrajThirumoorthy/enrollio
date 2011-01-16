
<%@ page import="org.bworks.bworksdb.EnrollmentStatus;org.bworks.bworksdb.ClassSession" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="classSession" />
        <title>Certificates: ${classSessionInstance.name}</title>
        <script type="text/javascript">
             $(document).ready(function(){
                $('#gradCertsForm').submit(function(){
                    if($('.certificateCheckbox:checked').size() == 0) {
                        alert("Please select at least one student, Homer.")
                        return false;
                    }
                    $.post('${createLink(action:"printGradCerts", controller:"classSession")}',
                        $('#gradCertsForm').serialize());
                });
                $('#selectAll').click(function() {
                    $('.certificateCheckbox').attr('checked',true)
                });
                $('#selectNone').click(function() {
                    $('.certificateCheckbox').attr('checked',false)
                });
                });
        </script>
    </head>
    <body>
        <div id="container">
            <div id="wrapper">
                <div id="content">
                    <g:if test="${flash.message}">
                        <div class="message">${flash.message}</div>
                    </g:if>
                    <div class="rightnow">
                        <h3 class="reallynow">
                            <span>Certificates: ${classSessionInstance.name}</span>
                            <br />
                        </h3>
                        <g:form name="gradCertsForm" action="printGradCerts" controller="classSession">
                            <input type="hidden" name="_format" value="PDF" />
                            <!-- Name shown on top of PDF report -->
                            <input type="hidden" name="_name" value="Graduation Certificates" />
                            <input type="hidden" name="_file" value="graduationCertificate" />
                            <input type="hidden" name="id" value="${classSessionInstance.id}" />

                            <table>
                                <thead>
                                    <th>Student</th>
                                    <th width="60%">Attendance</th>
                                    <th>Select: 
                                        <a href="#" id="selectAll">All,&nbsp;</a>
                                        <a href="#" id="selectNone">None</a>
                                    </th>
                                </thead>
                                <tbody>
                                    <g:each var="enrollmentInstance" in="${classSessionInstance.enrollments}">
                                        <tr>
                                            <td>
                                                <a href="#">${enrollmentInstance.student}</a>
                                            </td>
                                            <td>
                                            <enrollio:studentAttendanceSummary 
                                                summary="${attendancesForSession[enrollmentInstance.student.id]}" />
                                            </td>
                                            <td>
                                                <g:checkBox class="certificateCheckbox" name="studentIds" checked="no"
                                                value="${enrollmentInstance.student.id}" />
                                            </td>
                                        </tr>
                                    </g:each>
                                </tbody>
                            </table>
                            <div> 
                                <input id="printGradCertsButton" type="submit" value="Generate Certificates (PDF)" />
                            </div>
                        </g:form>
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
