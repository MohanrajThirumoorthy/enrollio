<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="help" />
        <title>Help - About</title>
    </head>
    <body>
        <g:render template="/help/helpMenu" />
        <h3>${title ?: "What is Enrollio?"}</h3>
        <p>Enrollio is an open-source application that tracks enrollment
        and attendance for small-to-medium size classes.  Ideal for groups of
        up to 20 students or participants.</p> 


        <h3>Features</h3>
        <ul>
            <li>Maintain a call list of people interested in your classes</li>
            <li>Call list is sorted by signup date, but can be customized</li>
            <li>Multiple users can work on call list simultaneously</li>
            <li>Print welcome letters for new students</li>
            <li>Track attendance and print graduation certificates</li>
        </ul>
        <h3>Who would use Enrollio?</h3>
        <p>Consider using Enrollio in the following scenarios:</p>
        <ul>
            <li>Your company teaches multiple 6-week training courses</li>
            <li>Administrating summer classes</li>
            <li>Tracking enrollment/completion of safety training</li>
            <li>Tracking attendance at meetings or other social groups</li>
        </ul>
        <h3>How can I try Enrollio?</h3>
        <p>Send an e-mail to <a href="mailto:nathan.neff@gmail.com" >nathan.neff@gmail.com</a> for a login name/password</p>
        <h3>Thanks</h3>
        <p>I would like to thank&nbsp;<g:link action="thanks">a bunch of people</g:link> for helping me.</p>
        <h3>Version</h3>
        <p>
        <g:render template="version" /></p>
    </body>
</html>
