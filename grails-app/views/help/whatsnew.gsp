<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="help" />
        <title>Help - What's New</title>
    </head>
    <body>
        <g:render template="helpMenu" />
        <h3>What's New</h3>
        <h3 class="reallynow">0.2 - "Dangle"</h3>
        <ul class="helplist">
            <li>Print welcome letters for classes</li>
            <li>Change signup date for students</li>
            <li>Ability to "star" students to place them at top of enrollment list.</li>
            <li>Mark contacts as "Cannot Reach"</li>
            <li>Add notes to contacts</li>
            <li>Assign a particular user to people on call list</li>
            <li>Users can have default area code, city and area code when 
                adding new contacts.</li>
        </ul>
        <h3 class="reallynow">2010/03/23</h3>
        <ul class="helplist">
            <li>Renamed "Programs" to "Courses"</li>
            <li>
            <g:link action="list" controller="student">
            Search&#160;</g:link>by phone numbers, address, student, and
            contact from one page!</li>
            <li>
            <b>Awesome</b>&nbsp;improvements when 
            <g:link action="create" controller="contact">creating
            students</g:link>
            <ul>
                <li>Users can search for existing contacts to add a
                student</li>
                <li>Students are much easier to create from a 
                <g:link action="show" controller="contact" id="1">contact
                page</g:link></li>
                <li>Easily add Student Interests</li>
            </ul></li>
            <li>This "What's New" page 
            <img src="${resource(dir:'images/icons', file:'emoticon_grin.png')}" /></li>
            <li>Simplified site Navigation (Removed Sessions and
            Contacts)</li>
            <li>Editing 
            <g:link controller="contact" action="edit" id="1">
            contacts</g:link>&nbsp;and 
            <g:link controller="student" action="edit" id="1">
            students</g:link>&nbsp;is much prettier</li>
        </ul>
        </div>
        <div id="footer">
            <g:render template="version" />
        </div>
    </body>
</html>
