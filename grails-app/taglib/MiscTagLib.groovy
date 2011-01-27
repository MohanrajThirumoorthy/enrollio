import org.bworks.bworksdb.*

class MiscTagLib {

    def configSettingService
    def studentService

    def debug = { map ->
        if (grailsApplication.config.grails.views.debug.mode == true) {
            def msg = map['msg']
            out << "<h2>${msg}</h2><br/>"
        }
    }
    
    // Create a checkbox for all courses for this student
    // Checkboxes are named using an index 'idx' which corresponds to the student's
    // index, so that the appropriate courses/interests can be assigned to the appropriate
    // student.
    // If student already has an active Interest in a course, the checkbox is checked.
 
    def interestCheckBoxes = { attrs ->
        def student = attrs['student']
        def defaultProgId
        // Whether to check the default course
        def checkDefaultProg = attrs['checkDefaultProg']
        if (checkDefaultProg) {
            defaultProgId = configSettingService.getSetting(ConfigSetting.DEFAULT_COURSE)
            if (defaultProgId) defaultProgId = defaultProgId.value;
        }
        def courses = Course.findAll()
        out << '<ul class="basicList">'
        courses.each { course ->
            out << '<li>'
            // Note: Need to search for active == true, also
            def checkBoxName = "interestInCourse_${course.id}"
            def results = Interest.withCriteria {
                eq("student", student)
                eq("course", course)
                eq("active", true)
            }

            // If student already has an interest in this course, or if
            // the caller wants us to check the default course automatically
            def hasInterest = (results || 
                              (checkDefaultProg && (course.id.toString() == defaultProgId)))
            def sCheckbox = """ 
                <label for="interestInCourse_${course.id}">
                    <input class="checkbox" 
                    id="interestInCourse_${course.id}" 
                    name="interestInCourse" 
                    type="checkbox" 
                    ${hasInterest ? 'checked="true"' : ''}
                    value="${course.id}" />${course.name}
                </label>
                <div id="signupDateDiv_${course.id}"
                     style=${hasInterest ? '' : 'display:none'}>
                     <ul>
                         <li>Signed up:&nbsp;
                         <input id="signupDate_${course.id}"
                             name="signupDate_${course.id}"
                             type="text"
                             class="hasDatePicker"
                             value="${studentService.signupDateForInterest(student, course).format('MM/dd/yyyy')}" />
                         </li>
                     </ul>
                </div>
            """

            out << sCheckbox
            out << '</li>'
        }
        out << '</ul>'
        return out
    }

    def isCurrentTab = { attrs ->
        if (pageProperty(name:'meta.tabName') == attrs['tabName']) {
            out << 'current'
        }
        else {
            out << 'enr-top-menu-item'
        }
        return out
    }

     def isLoginTab = { attrs ->
         if (pageProperty(name:'meta.tabName') == attrs['tabName']) {
            out << 'logintab current'
         }
         else {
            out << 'logintab'
        }

     }

     // If the mascotIcon has been configured, then return an IMG tag
     // with the icon in it, as well as any attributes that are provided
     def mascotIcon = { attrs ->
         def iconFile = configSettingService.getSetting(ConfigSetting.MASCOT_ICON)
         
         if (iconFile) {
             def attribs = ""
             attrs.each { key, value ->
                 attribs += "${key}=\"${value}\" "
             }
             out << "<img ${attribs}src=\"${iconFile}\" />"
         }
     }
     
     // Create links to the student's active interests
     def activeInterestLinks = { attrs ->
         def student = attrs['student']
         def contactCallListPositions = attrs['contactCallListPositions']
         
         student.activeInterests().each { interest ->
             def dt = enrollio.formatDate(date:interest.signupDate)
             def link = g.link(controller:'course', action: 'interestedStudents',
                               params:[ contactId : student.contact.id ],
                               id: interest.course.id, 
                               interest.course.name)
             out << '<tr><td>' + link + ' reg. ' + interest.signupDate.format("MMM, yyyy")
             if (contactCallListPositions && contactCallListPositions[interest.course.id]) {
                 def callListPos = contactCallListPositions[interest.course.id]
                 out << " - ${callListPos.callListPosition}th"

             }
             out << '</td></tr>'
         }
     }
}
