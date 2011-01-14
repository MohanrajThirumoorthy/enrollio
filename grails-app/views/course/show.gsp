<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
        <title>Course: ${courseInstance} </title>
    </head>
    <body>
        <div id="wrapper">
            <div id="content">
                <div class="rightnow">
                    <h3 class="reallynow">
                        <span>${courseInstance}</span>
                    
                        <br />
                    </h3>
                    <p class="youhave">${courseInstance.description}</p>
                    <p class="youhave">${activeInterestCount} interested Students</p>
                </div>
                <div class="infowrap">
                    <div class="infobox">
                        <h3 class="reallynow">
                            <g:link class="headerLink book_open" 
                            action="lessons" id="${courseInstance.id}" >
                            Lessons</g:link>
                            <!-- For some reason, these links get added out of order (add->edit) -->
                                        <br />
                            </h3>
                    </div>
                    <div class="infobox margin-left">
                        <h3 class="reallynow">
                            <a href="#" class="headerLink calendar">Sessions</a>
                            <br />
                        </h3>
                        <table>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div id="sidebar">
                <g:render template="individualCourseMenu" />
            </div>
        </div>
    </body>
</html>
