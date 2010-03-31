<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
        <title></title>
    </head>
    <body>
        <div id="wrapper">
            <div id="content">
                <div class="rightnow">
                    <h3 class="reallynow">
                        <g:if test="${classSessionInstance}">
                            <span>${classSessionInstance}</span>
                        </g:if>
                        <g:else>
                            <span>${courseInstance}</span>
                        </g:else>
                        <br />
                    </h3>
                    <p class="youhave"><b>12</b> students enrolled</p>
                    <table>
                        <thead><th colspan="2">Contact</th>
                        <th>Students</th>
                        </thead>
                        <g:each var="con" status="placeInList" in="${contactInstanceList}">
                        <g:render template="interestedContact" 
                            model="[placeInList : placeInList, contactInstance : con ]" />
                        </g:each>
                    </table>
                </div>
            </div>
        </div>
    </body>
</html>
