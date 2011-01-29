<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'fullcalendar.css')}" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="classSession" />
        <title>Class Session: ${classSessionInstance.name}</title>
        <g:javascript src="fullcalendar.min.js" />
        <script type="text/javascript">
            $(document).ready(function() {
                $('#lessonDates').fullCalendar({
                    theme : true,
                    buttonText: {
                        prev: '<',
                        next: '>'                    },
                    header: {
                        left: 'prev',
                        center: 'title',
                        right: 'next'
                    },
                    // put your options and callbacks here
                    events: "${createLink(controller:'classSession', action:'lessonDateData', id:classSessionInstance.id)}",
                    eventRender : function(event, element) {
                        if ($.fullCalendar.formatDate(event.start, 'yyyy/MM/dd') == '${lessonDateInstance.lessonDate.format("yyyy/MM/dd")}') {
                            element.addClass("fc-highlighted");
                        }
                    },
                    dayClick: function(date) {
                    alert(date.format('dd/mm/yyyy'))
                    }
                });
                $('#lessonDates').fullCalendar('gotoDate', ${lessonDateInstance.lessonDate.year + 1900}, ${lessonDateInstance.lessonDate.month});
            });
        </script>
    </head>
    <body>
        <g:render template="/common/messages" />
        <div id="contentContainer" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
            <g:render template="/course/coursesHeader"
                         model="[ currentCourse : classSessionInstance.course]" />
            <div style="overflow:hidden;" class="ui-tabs-panel ui-widget-content ui-corner-bottom">
                <g:render template="/classSession/individualClassSessionMenu" model="[ classSessionInstance : classSessionInstance ]"/>
                <h4 class="mainInfo">${classSessionInstance}</h4>

                <div class="ui-widget ui-widget-content" style="padding: 1px; margin-left: 1px; width: 40%; float: left;">
                    <div class="ui-widget-header2"> Lesson Dates </div>
                    <div id="lessonDates">
                    </div>
                </div>

                <g:if test="${lessonDateInstance}">
                    <g:render template="/classSession/attendance" model="[ lessonDateInstance : lessonDateInstance ]" />
                </g:if>
            </div>
        </div>
    </body>
</html>
