<%@ page import="org.bworks.bworksdb.Course" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
        <title>Edit Course: ${courseInstance}</title>
    </head>
    <body>
         <div id="wrapper">
            <div id="content">
                <g:render template="/common/errors" model="[bean:courseInstance]" />
                <div class="box">
                    <h3 id="adduser"> Course: ${courseInstance}</h3>
                    <g:form action="update" name="editCourseForm" method="post">
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
                        <g:submitButton class="save" name="saveButton" value="Update" />
                            or&nbsp;
                        <g:link name="cancelLink" class="cancelLink" action="show" id="${courseInstance.id}" >Cancel</g:link>
                    </g:form>
                </div>
            </div>
        </div>
    </body>
</html>
