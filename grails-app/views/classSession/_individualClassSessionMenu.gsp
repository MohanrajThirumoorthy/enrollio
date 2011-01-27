<ul class="menuList">
        <li>
            <g:link name='graduationLink' class="graduation_cap" action="graduation"
            id="${ classSessionInstance.id }" controller="classSession">&nbsp;&nbsp;Grad</g:link>
        </li>
        <li>
            <g:link name='certificatesLink' class="certificate" 
            action="certificates" id="${ classSessionInstance.id }"
            controller="classSession">&nbsp;&nbsp;Certs</g:link>
        </li>
        <li>
        <g:link name='editClassSessionLink' class="calendar_edit" 
            action="edit" controller="classSession" id="${ classSessionInstance.id }">&nbsp;&nbsp;Edit</g:link>
        </li>
        <li>
        <g:link name='attendanceSheetLink' class="application_list" 
        action="attendanceSheet" controller="classSession"
            id="${classSessionInstance.id}">&#160;Att Sheet</g:link>
        </li>
        <li>

            <g:link name='welcomeLettersLink' 
            class="welcome_letter" 
            controller="classSession"
            action="welcomeLetters"
            id="${classSessionInstance.id}">&#160;Welcome</g:link>
        </li>
        <li>
            <g:link name='welcomeLettersLink' 
            class="email" 
            controller="classSession"
            action="envelopes"
            id="${classSessionInstance.id}">&#160;Envelopes</g:link>
        
        </li>
</ul>
