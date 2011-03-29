<%@ page import="org.bworks.bworksdb.Course" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
        <title>Create Course:</title>
    </head>
    <body>
        <g:render template="/common/messages" />
        <g:render template="/common/errors" model="[bean:courseInstance]" />
        <div id="contentContainer" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
            <fieldset>
                    <h3 id="adduser">Create Course</h3>
                    <g:form action="save" name="newCourseForm" method="post">
                        <label for="name">Name : </label> 
                        <input name="id" id="id" type="hidden" 
                            value="${courseInstance.id}" />
                        <input type="hidden" name="version" 
                            value="${courseInstance?.version}" />
                        <input name="name" id="name" type="text" tabindex="1" 
                            value="${fieldValue(bean:courseInstance,field:'name')}"/>
                        <br />
                        <label for="description">Description : </label>
                        <g:textArea name="description" 
                            value="${fieldValue(bean:courseInstance,field:'description')}"
                            rows="5" cols="40"/>
                        <br />
                        <!-- TODO the label below is a hack to get the 
                            save button to align w/the description and name -->
                        <label for="saveButton"></label>
                        <g:submitButton class="save" name="saveButton" value="Save" />
                            or&nbsp;
                        <g:link name="cancelLink" class="cancelLink" action="list" >Cancel</g:link>
                    </g:form>
            </fieldset>
            </div>
        </div>
    </body>
</html>
