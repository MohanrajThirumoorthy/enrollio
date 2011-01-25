<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
        <script type="text/javascript">
            $(document).ready(function() {
            $('.enrollStudent').click(function() {
                    $.post('${createLink(controller:"classSession",
                            action:"enrollStudent")}',
                        { 'enroll' : $(this).attr('checked'), 
                        'studentId' : $(this).attr("studentId"),
                        'classSessionId' : $(this).attr("classSessionId") },
                        function(data) {
                            // update student count w/results from enrollStudent action
                            $('#message').text(data);
                            $('#messageBox').show('slow');
                        });
                    });
            });
        </script>
    </head>
    <body>
        <g:render template="/common/messages" />
                            <div id="messageBox" style="display:none;" class="info ui-widget">
                                <div style="margin-top: 20px; padding: 0pt 0.7em;" class="ui-state-default ui-corner-all"> 
                                    <p>
                                        <span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-info"></span>
                                        <span id="message"></span>
                                    </p>
                                </div>
                            </div>
        <div id="someMenu" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
        </div>
        <div id="contentContainer" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
            <ul id="ulSecond" class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-bottom">
                <g:each var="course" in="${courseInstanceList}">
                <li class="ui-state-default ui-corner-top ${course.id == courseInstance.id ? 'ui-tabs-selected ui-state-active' : ''}">
                <g:link id="${course.id}" action="show" controller="course">${course.name}</g:link>
                </li>
                </g:each>
            </ul>

            <div style="overflow:hidden;" class="ui-tabs-panel ui-widget-content ui-corner-bottom">
                <table id="interestedStudents" style="width:100%;float:left;" class="ui-widget ui-widget-content">
                    <thead>
                        <tr class="ui-widget-header2 ">
                            <th colspan="3">Enroll Student : ${studentInstance}</th>
                        </tr>
                    </thead>
                    <g:form action="saveEnrollments">
                    <g:hiddenField name="studentId" value="${studentInstance.id}" />
                    <g:hiddenField name="id" value="${courseInstance.id}" />

                    </tr>
                    <g:each var="classSession" in="${classSessionInstanceList}">
                    <tr>
                        <td>${classSession.name}
                         <g:checkBox id="enrollInSession${classSession.id}"
                                   name="enrollStudent${studentInstance.id}" 
                                   class="enrollStudent"
                         classSessionId="${classSession.id}" 
                              studentId="${studentInstance.id}"
                                  value="${classSession.enrollments.find { it.student.id == studentInstance.id }}" />
                        <enrollio:formatDate date="${classSession.startDate}" />
                        </td>
                    </tr>
                    </g:each>
                    </g:form>
                </table>
            </div>
        </div>
    </body>
</html>
