
<%@ page import="org.bworks.bworksdb.Interest" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Create Interest</title>         
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Interest List</g:link></span>
        </div>
        <div class="body">
            <h1>Create Interest</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${interestInstance}">
            <div class="errors">
                <g:renderErrors bean="${interestInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="note">Note:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:interestInstance,field:'note','errors')}">
                                    <g:select optionKey="id" from="${org.bworks.bworksdb.Note.list()}" name="note.id" value="${interestInstance?.note?.id}" noSelection="['null':'']"></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="active">Active:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:interestInstance,field:'active','errors')}">
                                    <g:checkBox name="active" value="${interestInstance?.active}" ></g:checkBox>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="program">Program:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:interestInstance,field:'program','errors')}">
                                    <g:select optionKey="id" from="${org.bworks.bworksdb.Program.list()}" name="program.id" value="${interestInstance?.program?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="student">Student:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:interestInstance,field:'student','errors')}">
                                    <g:select optionKey="id" from="${org.bworks.bworksdb.Student.list()}" name="student.id" value="${interestInstance?.student?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input class="save" type="submit" value="Create" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
