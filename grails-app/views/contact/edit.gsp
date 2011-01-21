
<%@ page import="org.bworks.bworksdb.Contact" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <meta name="tabName" content="contact" />    
        <title>Edit Contact</title>         
        <script>
            $(function() {
            $("#saveContact").button();
            });
        </script>
    </head>
    <body>
        <g:render template="/contact/contactMenu" />
        <div id="secondMenu" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
            <div class="float-container ui-tabs-panel ui-widget-content ui-corner-bottom">
                <g:hasErrors bean="${contactInstance}">
                    <div class="ui-widget">
                        <div style="" class="ui-state-error ui-corner-all"> 
                            <p>
                            <span style="float: left; margin-right: 0.3em;" 
                                class="ui-icon ui-icon-alert">
                            </span> 
                            <strong>Alert:</strong> 
                            <g:renderErrors bean="${contactInstance}" as="list" />
                            </p>
                        </div>
                    </div>
                </g:hasErrors>
                <g:form action="update" name="editContactForm" method="post" >
                    <g:render template="editContact" model="[contactInstance:contactInstance" />
                        <g:actionSubmit style="float:left;" id="saveContact" value="Update" />
                </g:form>
            </div>
        </div>
    </body>
</html>
