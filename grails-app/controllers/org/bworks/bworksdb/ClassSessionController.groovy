package org.bworks.bworksdb
import org.bworks.bworksdb.auth.ShiroUser
import org.apache.shiro.SecurityUtils
import grails.converters.JSON

class ClassSessionController {

    def courseService
    def miscService
    def classSessionService
    def attendanceService

    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', 
                             saveEnrollments:'POST', update:'POST',
                             printGradCerts: 'POST',
                             printWelcomeLetter: 'POST' ]

    def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
        [ classSessionInstanceList: ClassSession.list( params ), classSessionInstanceTotal: ClassSession.count() ]
    }

    def quickCallList = {
        def classSessionInstance = ClassSession.get(params.id)
        def contactInstanceList = classSessionInstance.enrollments.collect {
            it.student.contact
        }.unique()
        
        [ classSessionInstance: classSessionInstance, 
          contactInstanceList : contactInstanceList ]
    }

    def welcomeLetters = {
        def classSessionInstance = ClassSession.get(params.id)
        def contactInstanceList = classSessionInstance.enrollments.collect {
            it.student.contact
        }.unique()
        
        [ classSessionInstance: classSessionInstance, 
          contactInstanceList : contactInstanceList ]
    }

    // Provide data for awesome fullcalendar plugin
    def lessonDateData = {
        // TODO filter by params
        def classSessionInstance = ClassSession.get(params.id)
        def highlightLesson
        def lds = []
        classSessionInstance.lessonDates.each { lessonDate ->
            
            lds << [ 
              title : lessonDate.lesson.name.toString().split()[0],
             // give unix-timestamp (seconds since epoch), which Javascript likes
              start : lessonDate.lessonDate.getTime().intdiv(1000),
              url   : createLink(action:'attendance', controller:'classSession', 
                      id:lessonDate.classSession.id, 
                      params: [ 'lessonDateId':lessonDate.id ]),
              className : 'buph'

            ]
        }

        render lds as JSON
    }


    def reserveContact = {
        def con = Contact.get(params['contactId'])
        def course = Course.get(params['courseId'])
        def su = ShiroUser.get(params['userId'])

        def clc = CallListContact.findByContactAndCourse(con, course)

        if (clc) {
            clc.user = su
            clc.save()
        }
        else {
            clc = new CallListContact(contact:con, course : course, user:su)
            if (!clc.validate()) {
                log.error( clc.errors.allErrors)
            }
            else {
                clc.save()
            }
        }
        render clc.user?.username ?: 'not assigned'
    }

    // ajax method to enroll studs on the fly
    def enrollStudent = {
        def studentInstance = Student.get(params.studentId)
        def classSessionInstance = ClassSession.get(params.classSessionId)
        def msg
        if (params.enroll == 'true') {
            msg = classSessionService.enrollStudent(studentInstance, classSessionInstance)
            render("Student ${studentInstance} enrolled in ${classSessionInstance}")
        }
        else {
            msg = classSessionService.disrollStudent(studentInstance, classSessionInstance)
            render("Student ${studentInstance} removed from ${classSessionInstance}")
        }

    }



    // TODO Nuke this action
    def saveEnrollments = {
        def enrollees = params.interestedStudents
        def classSession = ClassSession.get(params.classSessionId)
        enrollees.each {
            def stud = Student.get(it)
            def e = new Enrollment(student: stud, classSession:classSession ).save()
        }
        redirect(action:show,id:params.classSessionId)
    }

    def show = {
        def classSessionInstance = ClassSession.get( params.id )
        println "Clas ss " + classSessionInstance

        def lessonDateInstance = classSessionService.closestLessonDate(classSessionInstance)

        if(!classSessionInstance) {
            flash.message = "ClassSession not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ classSessionInstance : classSessionInstance, lessonDateInstance : lessonDateInstance ] }
    }

    def delete = {
        def classSessionInstance = ClassSession.get( params.id )
        if(classSessionInstance) {
            try {
                classSessionInstance.delete(flush:true)
                flash.message = "ClassSession ${params.id} deleted"
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "ClassSession ${params.id} could not be deleted"
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = "ClassSession not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def classSessionInstance = ClassSession.get( params.id )

        if(!classSessionInstance) {
            flash.message = "ClassSession not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ classSessionInstance : classSessionInstance ]
        }
    }

    def update = {
        def classSessionInstance = ClassSession.get( params.id )
        if(classSessionInstance) {
            if(params.version) {
                def version = params.version.toLong()
                if(classSessionInstance.version > version) {

                    classSessionInstance.errors.rejectValue("version", "classSession.optimistic.locking.failure", "Another user has updated this ClassSession while you were editing.")
                    render(view:'edit',model:[classSessionInstance:classSessionInstance])
                    return
                }
            }
            def startDate = miscService.parseDate(params.remove('startDate'),
                                                params.remove('startTime'),
                                                params.remove('startAmPm'))
            classSessionInstance.properties = params
            classSessionInstance.startDate = startDate
            if(!classSessionInstance.hasErrors() && classSessionInstance.save()) {
                flash.message = "ClassSession ${params.id} updated"
                redirect(action:show,id:classSessionInstance.id)
            }
            else {
                render(view:'edit',model:[classSessionInstance:classSessionInstance])
            }
        }
        else {
            flash.message = "ClassSession not found with id ${params.id}"
            redirect(controller:"course", action:list)
        }
    }

    def create = {
        def classSessionInstance = new ClassSession()
        classSessionInstance.properties = params
        if (!classSessionInstance.course) {
            classSessionInstance.course = Course.list([sort:'id', max:1, order:'asc'])[0]
        }
        
        def nac = courseService.nextAvailableLessonDates(classSessionInstance.course, new Date())
        nac.each {
            classSessionInstance.addToLessonDates(it)
        }
            
        return ['classSessionInstance':classSessionInstance]
    }

    def save = {
        def lessonDates = [:]
        // lesson Dates come in like this:
        // lesson_{lessonId} = '11/12/2009'
        params.findAll { it.key.startsWith('lesson_') }.each {
            def lessonId = it.key.split('_')[1]
            def date = it.value
            lessonDates[lessonId] = date
        }

        params.findAll { it.key.startsWith('lesson_') }.each {
            params.remove(it.key)
        }
       
        def dateFormat = 'MM/dd/yyyy'
        def startDate = params.remove('startDate')
        def classSessionInstance = new ClassSession(params)
        try {
            classSessionInstance.startDate = Date.parse(dateFormat, startDate)
        } catch (Exception e) {
        }
 
        if(!classSessionInstance.hasErrors() && classSessionInstance.save()) {
            lessonDates.each {
                classSessionInstance.addToLessonDates(new LessonDate(lesson : Lesson.get(it.key),
                                                      lessonDate : Date.parse(dateFormat, it.value)));
            }
            classSessionInstance.save()
            flash.message = "ClassSession ${classSessionInstance.id} created"
            redirect(action:show,id:classSessionInstance.id)
        }
        else {
            render(view:'create',model:[classSessionInstance:classSessionInstance])
        }
    }


    // Renders a PDF report of students/lesson dates for the
    // Class Session ID == params.id
    def attendanceSheet = {
        def classSessionInstance = ClassSession.get( params.id )
        if (classSessionInstance.enrollments?.size() > 0) {
            def reportWriter = classSessionService.getBlankAttendanceSheet(params.id)
            def fileName = "attendance_" + 
                           classSessionInstance.name.substring(0,4) +
                           classSessionInstance.startDate.format('yyyy_MM_dd') + '.pdf'

            response.addHeader('content-disposition', "attachment; filename=${fileName}")
            reportWriter.writeTo(response)
        }
        else {
            flash.message = "Nobody's enrolled in this session."
            redirect(action:show, id:classSessionInstance.id)
        }
    }

    def graduation = {
        def classSessionInstance = ClassSession.get( params.id )
        if(!classSessionInstance) {
            flash.message = "Class Session not found with id ${params.id}"
            redirect(action:list)
        }
        else { 
            
           def attendancesForSession =  classSessionService.attendancesForSession(classSessionInstance)
           def interestsInCourse     =  classSessionService.enrolledStudentsInterests(classSessionInstance)
            return [    interestsInCourse     : interestsInCourse,
                        attendancesForSession : attendancesForSession,
                         classSessionInstance : classSessionInstance ] }

    }

    def envelopes = {
        def classSessionInstance = ClassSession.get( params.id )
        if(!classSessionInstance) {
            flash.message = "Class Session not found with id ${params.id}"
            redirect(action:list)
        }
        else if (classSessionInstance.enrollments?.size() == 0) { 
            flash.message = "No students are enrolled in this class session.  Can't print envelopes for nobody"
            redirect(action:show, id:classSessionInstance.id)
        }
        else {
            def header = [ 'name', 'address1', 'address2', 'city', 'state', 'zip' ]
            def envelopes = classSessionInstance.enrollments.collect {
                [ it.student.contact.fullName(),
                  it.student.contact.address1 ?: '',
                  it.student.contact.address2 ?: '',
                  it.student.contact.city ?: '',
                  it.student.contact.state ?: '',
                  it.student.contact.zipCode ?: '']
            }

            envelopes = [ header ] + envelopes 

            // join all data w/tabs
            def envelopeData = envelopes.collect {
                it.join(",")
            }

            response.setHeader("Content-disposition", "attachment; filename=envelopes.csv")
            render(contentType: "text/csv", text: envelopeData.join("\n"));
        }

    }
    def certificates = {
        def classSessionInstance = ClassSession.get( params.id )
        if(!classSessionInstance) {
            flash.message = "Class Session not found with id ${params.id}"
            redirect(action:list)
        }
        else { 
            
           def attendancesForSession =  classSessionService.attendancesForSession(classSessionInstance)
            return [ attendancesForSession : attendancesForSession,
                         classSessionInstance : classSessionInstance ] }

    }

    def printGradCerts = {
        def classSessionInstance = ClassSession.get( params.id )
        def lessonDates = classSessionInstance?.lessonDates

        def graduationDate = classSessionInstance.startDate
        if (lessonDates && lessonDates.size() > 0) {
            graduationDate = lessonDates.last().lessonDate
        }

        params['graduationDateParam'] = enrollio.formatDate(date:graduationDate)

        // Default Graduation Date to date of last class
        // TODO: Refactor to a Service, or else give classSession a graduationDate

        // Set the background picture for the report using absolute URL
        // Haven't tried using a relative URL
        params['backgroundImageUrlParam'] =
            resource(dir:'images', file:'blank_certificate_background.jpg',
                     absolute:true)

        // have to convert to long, otherwise getAll barfs
        def studentIdList = request.getParameterValues('studentIds').collect {
            it.toLong()
        }

        if (studentIdList.size() > 0) {

            def students = Student.getAll(studentIdList)?.collect {
                [STUDENT_NAME:it.fullName()]
            }

            if (students) {

                chain(controller:'jasper',
                      action:'index',
                      model:[data:students],params:params)
            }
            else {
                render ''
            }
        }
        else {
            flash.message = "You must select at least one student."
            if (classSessionInstance) {
                redirect(action:'certificates', controller:'classSession', params:[id:classSessionInstance.id])
            }
            else {
                redirect(action:"oops", controller:"error")
            }

        }

    }

    // TODO: this action is pretty messy and should be refactored.
    // Especially the duplicate calls to attendanceService
    def attendance = {
        def classSessionInstance = ClassSession.get( params.id )
        if(!classSessionInstance) {
            flash.message = "ClassSession not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            // If user wants a specific lessonDate, then give it to 'em
            if (params.lessonDateId) {
                def lessonDateInstance = LessonDate.get(params.lessonDateId)
                if (!lessonDateInstance) {
                    flash.message = "Lesson date not found with id: ${params.lessonDateId}"
                    redirect(action:show, id:classSessionInstance.id)
                }
                else {
                    // Init. attendances if need be.
                    attendanceService.initializeAttendees(lessonDateInstance)
                    render(view:'show', model:[ courseInstanceList : Course.list(), classSessionInstance : classSessionInstance, lessonDateInstance : lessonDateInstance ])
                }
            }
            else {
                // Find closest class to highlight/show in attendance sheet.
                def closestLessonDate = classSessionService.closestLessonDate(classSessionInstance) 
                if (closestLessonDate) {
                    // Init. attendances if need be.
                    attendanceService.initializeAttendees(closestLessonDate)
                    
                    render(view:'show', model:[ courseInstanceList : Course.list(), classSessionInstance : classSessionInstance, lessonDateInstance : closestLessonDate ])
                }
                else {
                    flash.message = "You don't have any lesson dates scheduled for this session"
                    redirect(action:show, id:classSessionInstance.id)
                }
            }
        }
    }

    def printWelcomeLetter = {
        def classSessionInstance = ClassSession.get(params.id)
        if (classSessionInstance) {
            def reportData = classSessionService.welcomeLetterReportData(classSessionInstance)
            // Take the hash map found in 'forwardParams', and move it to the
            // params hash, and pass params to our report
            // forwardParams has single parameters like TITLE of report
            // params.add reportData.remove('forwardParams')
            
            params['PROGRAM_NAME'] = 'foo'
            reportData = reportData['contacts']
            println "report data is: " + reportData

            chain(controller:'jasper',
                  action:'index',
                  model:[data:reportData],params:params)
        }
    }

}

