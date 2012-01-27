package org.bworks.bworksdb


class ClassSessionService {

    boolean transactional = true

    // returns a map like this:
    // <studentId> : [ attendanceCount:6, totalLessons:6, 
    //                         missed : [lessonDate1, lessonDate2] ]
    def attendancesForSession(classSessionInstance) {
        def lessonDates = classSessionInstance.lessonDates.collect {
            it
        }

        def results = [:]
        
        // initialize a map for each student enrolled in this session.
        // map will contain # of classes attended, and a list of classes missed,
        // along with totalLessons in this session
        classSessionInstance.enrollments.each { enr ->
            results[enr.student.id] = [ attendanceCount : 0 , 
                                        totalLessons : lessonDates.size(),
                                        missed : lessonDates.clone() ]
        }

        classSessionInstance.lessonDates.each {
            it.attendees.each { att ->
                if (!results[att.student.id]) {
                    println "no student for ${att.student.id}"
                }
                if (att.status == 'present' && results[att.student.id]) {
                    results[att.student.id].attendanceCount += 1
                    // remove this attendance's lessonDate from the student's "missed" list.
                    results[att.student.id].missed.remove(att.lessonDate)
                }
            }
        }
        return results
    }

    // enrolls a student, or changes their status from dropped out
    // to "in progress"
    def enrollStudent(studentInstance, classSessionInstance) {
        def msgs = [:]
        def enr = Enrollment.findByClassSessionAndStudent(classSessionInstance, studentInstance)

        if (enr) {
            enr.status = EnrollmentStatus.IN_PROGRESS
            enr.save()
        }
        else {
            def e = new Enrollment(student:studentInstance, classSession: classSessionInstance)
            classSessionInstance.addToEnrollments(e)
            if (classSessionInstance.save(flush:true)) {
            }
        }
        
        // Create an interest.  This happens when brothers/sisters are enrolled when they 
        // don't have an interest in a particular course.
        // TODO test this, meow.
        def interest = Interest.findByStudentAndCourse(studentInstance, classSessionInstance.course)
        if (!interest) {
            def i = new Interest(student:studentInstance, active:true,
                                 course:classSessionInstance.course).save()
            studentInstance.addToInterests(i).save()
        }
        msgs['enrolledStudents'] = activeEnrollments(classSessionInstance).size()
        return msgs
    }

    // Removes an enrollment, unless there's already attendances in 
    // this class session for this student.  If there's already attendences,
    // then mark the enrollment as dropout.
    def disrollStudent(studentInstance, classSessionInstance) {
        def msgs = [:]
        def crit = Attendance.createCriteria()
        
        def enr = Enrollment.findByClassSessionAndStudent(classSessionInstance, studentInstance)

        // If no enrollment exists, bye-bye
        if (!enr) {
            return ""
        }

        def attendances = crit.list() {
            eq 'student.id', studentInstance.id
            eq 'status', 'present'

            lessonDate {
                eq 'classSession.id', classSessionInstance.id
            }

        }

        if(attendances) {
            enr.status = EnrollmentStatus.DROPPED_OUT
            enr.save()
        }
        else {
            classSessionInstance.removeFromEnrollments(enr)
            enr.delete(flush : true)
        }

        msgs['enrolledStudents'] = activeEnrollments(classSessionInstance).size()

        return msgs
    }

    def activeEnrollments(classSessionInstance) {
        classSessionInstance.enrollments.findAll {
            it.status != EnrollmentStatus.DROPPED_OUT
        }
    }

    def welcomeLetterReportData(classSessionInstance) {
        def reportData = [ forwardParams : [:] ]
        reportData['forwardParams']['PROGRAM_NAME'] = classSessionInstance.course.name
        reportData['forwardParams']['START_DATE'] = classSessionInstance.startDate.toString()

        println "Enrollments are: " + classSessionInstance.enrollments.size()
        def contacts = classSessionInstance.enrollments.collect {
            println "Boo"
            it.student.contact
        }.unique()

        reportData['contacts'] = contacts.collect {
            buildContactData(it)
        }

        return reportData

    }

    // returns an array of contact information, used in Welcome Letter
    // TODO: Refactor this method and similar method in CourseSessionService
    // into perhaps the ContactService or something.
    // (After writing tests, of course)
    def buildContactData(contactInstance) {
        
        def addr = [ contactInstance.address1 , contactInstance.address2 ?: '' ]
        def csz = [ contactInstance.city ?: '' , contactInstance.state ?: '', contactInstance.zipCode ?: '']
        
        def reportData = [
            CONTACT_NAME:contactInstance,
            CONTACT_ADDRESS:addr.join('<BR />'),
            // TODO Contact Notes, mmmk?
            CONTACT_NOTES:'',
            CONTACT_CITY_STATE_ZIP:csz.join(', '),
            CONTACT_EMAIL:contactInstance.emailAddress,
            CONTACT_PHONE:contactInstance.phoneNumbers.join('<br />'),
            CONTACT_ID:contactInstance.id
        ]        

        return reportData
    }

    // Find upcoming lesson date, or closest lesson date in the past
    def closestLessonDate(classSessionInstance) {
        def today = new Date()
        // create a groovy List w/lesson dates.  SortedSet sucks.
        def lessonDates = classSessionInstance.lessonDates.collect { it }

        def dates = lessonDates.sort { lessonDate1, lessonDate2 ->

            def lessonDate1Score = today - lessonDate1.lessonDate
            if (lessonDate1Score < 0) lessonDate1Score *= -100000
            def lessonDate2Score = today - lessonDate2.lessonDate
            if (lessonDate2Score < 0) lessonDate2Score *= -100000

            return lessonDate1Score <=> lessonDate2Score
            
        }

        if (!dates) { 
            return null
        }

        return dates[0]
    }
    // returns a map of [ 1 : interest,
    //                    2 : interest2 ] where 1 and 2 are student IDs
    // and interest and interest2 are interests in the specified class session
    // TODO:test, mewo
    def enrolledStudentsInterests(classSession) {
        def interests = [:]
        classSession.enrollments.each { enr ->
            interests[enr.student.id] = Interest.findByStudentAndCourse(enr.student, classSession.course)
        }
        return interests
    }

    def attendanceMapForSession(classSessionInstance) {

        def attendanceContacts = []

        def sessionStudents = classSessionInstance.enrollments.collect { 
            it.student
        }

        def contacts = sessionStudents.collect {
            it.contact
        }.unique().sort { it.lastName + ":" + it.firstName }

        contacts.each { contact ->
            def data = [ contact: contact, info: contact.abbrevPhoneNumbers() ]
            data['students'] = sessionStudents.findAll { sessionStudent ->
                contact.students.find { contactStudent ->
                    contactStudent.id == sessionStudent.id
                }
            }
            attendanceContacts << data
        }

        return attendanceContacts
    }




}
