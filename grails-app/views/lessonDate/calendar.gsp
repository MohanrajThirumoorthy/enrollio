
<%@ page import="org.bworks.bworksdb.LessonDate" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="classSession" />
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'fullcalendar.css')}" />
        <meta name="layout" content="main" />
        <title>Calendar</title>
        <g:javascript src="jquery-1.4.2.min.js" />
        <g:javascript src="fullcalendar.min.js" />

        <script type="text/javascript">
            $(document).ready(function() {
                // page is now ready, initialize the calendar...
                $('#calendar').fullCalendar({
                    // put your options and callbacks here
                    events: "${createLink(controller:'lessonDate', action:'lessonDateData')}",
                    aspectRatio:2.4,
                    dayClick: function(date) {
                    }
                });
                <g:if test="${showInstance}">
                    $('#calendar').fullCalendar('gotoDate', ${lessonDateInstance.lessonDate.year + 1900}, ${lessonDateInstance.lessonDate.month});
                </g:if>
            });
        </script>
        <title>${lessonDateInstance}</title>
    </head>
    <body>
        <div id="container">
            <div id="wrapper">
                <div id="content" class="calendar">
                        <div id="calendar">

                        </div>

                </div>
            </div>
        </div>
    </body>
</html>
