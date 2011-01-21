
<%@ page import="org.bworks.bworksdb.Contact" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <meta name="tabName" content="contact" />    
        <title>Edit Contact</title>         
        <g:javascript src="jquery.maskedinput-1.2.2.min.js" />
        <g:javascript src="enrollioContact" />
        <script type="text/javascript">
            $(document).ready(function() {
                $(".phoneNumber").mask("(999) 999-9999")
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
                    <div class="buttonBox">
                        <g:actionSubmit id="saveContact" value="Update" />
                    </div>
                </g:form>
            </div>
        </div>
    </body>
</html>
