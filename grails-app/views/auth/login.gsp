<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="login" />
        <title>Login</title>
        <script>
                $(function() {
                        $( "input:submit").button();
                });
        </script>

    </head>
    <body>
        <g:render template="/common/messages" />
        <fieldset class="ui-widget-content" style="float: left;">
            <legend class="ui-widget-header2 ui-corner-all">Log In</legend>
            <g:form name="loginForm" class="loginForm" action="signIn">
                <input type="hidden" name="targetUri" value="${targetUri}" />
                    <div class="field">
                        <label for="username">Username:</label>
                        <input type="text" name="username"
                        value="${username}" />
                    </div>
                    <div class="field">
                        <label for="password">Password:</label>
                        <input type="password" name="password"
                        value="" />
                    </div>
                    <div class="field">
                        <label for="rememberMe">Remember me?:</label>
                        <g:checkBox name="rememberMe" value="${rememberMe}" />
                    </div>
                    <div class="buttonBox">
                        <input type="submit" value="Sign in" />
                    </div>
            </g:form>
        </fieldset>
    </body>
</html>
