import org.bworks.bworksdb.*

class EnrollioTagLib {
    static namespace = "enrollio"

    // Standard Enrollio date formatting
    def formatDate = { attrs ->
        def d = attrs['date']
        def showTime = attrs['showTime'] ?: false
        def enrollioFormat = 'MMMM d, yyyy' + (showTime ? ' h:mm a' : '')
        try {
            def output = d ? d.format(enrollioFormat) : ''
            out << output
        } catch (Exception e) {
            out << ''
        }
    }

    // split a CamelCase fieldName like 'birthDate'
    // and capitalize, and put a colon on the end
    def formatFieldName(fieldName) {
        def formattedFieldName
        if (fieldName) {
            def words = fieldName.split("(?=[A-Z])")
            def upperCaseWords = words.findAll({it.length()}).collect {
                it[0].toUpperCase() + it[1 .. -1].toLowerCase()
            }
            formattedFieldName = upperCaseWords.join(' ') + ':'
        }

        return formattedFieldName
    }

    def contactStudentList = { attrs ->
        def c = attrs['contact']
        out << c.students.collect {
            g.link(controller:'student', action:'show',
                         id:it.id, it.fullName())
        }.join(', ')
    }

    def textField = { attrs ->
        def m = attrs['model']
        def fieldName = attrs['fieldName']
        def formattedFieldName = formatFieldName(fieldName)

        def output = """
        <tr class="prop">
            <td valign="top" class="name">
            ${formattedFieldName}
            </td>
            <td valign="top" class="value">
                ${fieldValue(bean: m, field:fieldName)?.replace("\n", "<br />")}
            </td>
        </tr>
        """

        out << output

    }

    def dateField = { attrs ->
        def m = attrs['model']
        def fieldName = attrs['fieldName']
        def formattedFieldName = formatFieldName(fieldName)

        def output = """
        <tr class="prop">
            <td valign="top" class="name">
            ${formattedFieldName}
            </td>
            <td valign="top" class="value">
                ${enrollio.formatDate(date:m.properties[fieldName])}
            </td>
        </tr>
        """

        out << output

    }

    // expects a single student's attendance data
    // as provided by ClassSessionService.attendancesForSession
    def studentAttendanceSummary = { attrs ->

        if (attrs.summary.attendanceCount > 0 && attrs.summary.attendanceCount == attrs.summary.totalLessons) {
            out << '100 %&nbsp;'
            out << '<img src="'
            out << resource(dir:'images/icons', file:'award_star_gold_3.png')
            out << '" />'
        }

        def missedClassesLinks = attrs.summary.missed.collect { lessonDate ->
            g.link(controller:'classSession', 
                       action:'attendance', 
                       id:lessonDate.classSession.id,
                       params:[ lessonDateId : lessonDate.id ], lessonDate.lesson.name)
        }

        if (missedClassesLinks) {
            out << "&nbsp;Missed: "
            out << missedClassesLinks.join(', ')
        }

    }

    def courseDropDown = { attrs ->
        def studentInstance = attrs['studentInstance']
        def possibleInterests = attrs['possibleInterests']

        out << '<select name="interestInCourse" class="multiselect" multiple="multiple">'
        Course.list().each { course ->
            if(studentInstance?.interests.find { it.course.id == course.id }) {
               out << "<option selected=\"selected\" value=\"${course.id}\">${course.name}</option>"
            }
            else if (possibleInterests?.find { it.toLong() == course.id }) {
                // maybe student didn't save correctly, and we want to show prev. selected courses
               out << "<option selected=\"selected\" value=\"${course.id}\">${course.name}</option>"
            }
            else {
               out << "<option value=\"${course.id}\">${course.name}</option>"
            }
        }
        out << "</select>"
    }

    def enrollmentAbbreviations = { attrs ->
        def student = attrs['studentInstance']
        out << student.enrollments?.collect { it.classSession?.abbrev() }.join(',')
    }

    // determine contact's students earliest signup date for a course
    def signupDateForCourse = { attrs ->
        def contact = attrs['contactInstance']
        def course = attrs['courseInstance']
        def crit = Interest.createCriteria()
        def interests = crit {
            eq ('course.id', course.id)
            eq ('active', true)
            student {
                eq ('contact.id', contact.id)
            }
            order('signupDate', 'asc')
            maxResults(1)
        }

        if (interests) {
            out << ' (reg. ' + interests[0].signupDate.format("MMM, yyyy") + ')'
        }
    }

    // creates a list of show hours to use in drop-down lists
    def timeSelectors = { attrs ->
        def fieldNamePrefix = attrs['fieldNamePrefix'] ?: 'date'
        def showHours = []
        (1 .. 12).each {
            showHours.add(it + ":00")
            showHours.add(it + ":30")
        }

        def existingTime = attrs['date']?.format('h:mm')
        out << g.select(name: fieldNamePrefix + 'Time', from:showHours, value: existingTime ?: '9:00')

        def existingAmPm = attrs['date']?.format('a')
        out << g.select(name: fieldNamePrefix + 'AmPm', from:['PM', 'AM'], value: existingAmPm ?: 'PM')
    }
}

