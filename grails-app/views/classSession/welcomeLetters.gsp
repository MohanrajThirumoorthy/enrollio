<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="tabName" content="classSession" />
        <title>Welcome Letter</title>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'theme.css')}" />
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'style.css')}" />
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'theme1.css')}" />
        <link rel="stylesheet" media="print" type="text/css" href="${resource(dir:'css', file:'print.css')}" />
    </head>
 <body>
     <g:each var="contactInstance" in="${contactInstanceList}">
         <div id="container" style="page-break-after:always">
            <div id="wrapper">
                        <h3 class="reallynow">
                            Welcome to Byteworks
                        </h3>
                        <p class="youhave">
         Sed ut perspiciatis unde omnis enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
         1914 translation by H. Rackham
                        </p>
                        
                    <div class="infowrap">
                        <div class="infobox">
                            <h3>Lesson Dates</h3>
                            <table id="lessonDates">
                                <tbody>
                                    <g:each var="lessonDate"
                                    in="${classSessionInstance.lessonDates}">
                                        <tr>
                                            <td>
                                                <g:link controller="lessonDate"
                                                action="show" id="${lessonDate.id}">
                                                ${lessonDate.lesson.name}</g:link>
                                            </td>
                                            <td>
                                                <enrollio:formatDate date="${lessonDate.lessonDate}" />
                                            </td>
                                        </tr>
                                    </g:each>
                                </tbody>
                            </table>
                        </div>
                        <div class="infobox margin-left">
                            <h3 class="reallynow">
                                <span>Enrollments</span>
                                <br />
                            </h3>
                            <table>
                                <tbody>
                                    <g:each var="enr"
                                    in="${classSessionInstance.enrollments}">
                                        <tr>
                                            <td>
                                                <a href="#">${enr.student}</a>
                                            </td>
                                            <td>${enr.status.name}</td>
                                        </tr>
                                    </g:each>
                                </tbody>
                            </table>
                        </div>
                    </div>
            </div>
        </div>
        </g:each>
    </body>
</html>
