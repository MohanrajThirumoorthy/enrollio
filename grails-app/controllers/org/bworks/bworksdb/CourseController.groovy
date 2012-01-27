package org.bworks.bworksdb
import grails.orm.PagedResultList
import org.bworks.bworksdb.auth.ShiroUser
import org.apache.shiro.SecurityUtils

class CourseController {
    
    def index = { redirect(action:list,params:params) }
    def userService
    def courseService
    def classSessionService

    static navigation = [
        group:'mainLinks',
        action:'list',
        title:'Courses',
		isVisible: { SecurityUtils.subject?.isAuthenticated() },
        order:10
    ]

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
        def courseInstanceList = Course.list( params )
        def courseInstance = courseInstanceList[0]
        render(view:'show', 
             model : [ courseInstanceList : courseInstanceList, courseInstance : courseInstance,
                     activeInterestCount : courseService.activeInterests(courseInstance).size(),
                       courseInstanceTotal: Course.count() ])
    }

    def enrollStudent = {
        def courseInstance = Course.get(params.id)
        def courseInstanceList = Course.list()
        def studentInstance = Student.get(params.studentId)
        def classSessionInstanceList = courseInstance.classSessions
        render (view : 'enrollStudent', model : [ courseInstance : courseInstance, 
        studentInstance : studentInstance, 
        classSessionInstanceList : classSessionInstanceList,
        courseInstanceList : courseInstanceList])
    }

    def saveEnrollments = {

        def renderMsg = ""
        

        def disrollments = params.findAll {
            it.key =~ /_classSessions\[(\d+)\]/
        }.collect { (it =~ /\[(\d+)\]/)[0][1] }

        def enrollments = params.findAll {
            it.key =~ /^classSessions\[(\d+)\]/
        }.collect { (it =~ /\[(\d+)\]/)[0][1] }

        disrollments = disrollments - enrollments

        def studentInstance = Student.get(params.studentId)
        def msgs = ""
        disrollments.each {
            classSessionService.disrollStudent(studentInstance, ClassSession.get(it))
        }

        def courseInstance
        enrollments.each {
            def classSessionInstance = ClassSession.get(it)
            if (!courseInstance) { courseInstance = classSessionInstance.course }
            classSessionService.enrollStudent(studentInstance, classSessionInstance )
        }

        render (template:'studentEnrollments', 
            model:[ courseInstance : courseInstance, studentInstance:studentInstance ])

    }

    // TODO this is almost the same as /coursecontroller/quickenroll
    def enrollmentForm = {
        def courseInstance = Course.get(params.id)
        def courseInstanceList = Course.list()
        def classSessionInstanceList = courseInstance.classSessions
          
            [ courseInstance : courseInstance, 
              classSessionInstanceList : classSessionInstanceList,
              studentId : params.studentId ]

    }

    def saveLessonSort = {
        def courseInstance = Course.get( params.id )

        if(!courseInstance) {
            flash.message = "Course not found with id ${params.id}"
            redirect(action:list)
        }
        else {

            courseService.sortLessons(courseInstance, params)

            flash.message = "Lessons successfully sorted."

            redirect(action:'show',id:courseInstance.id)
        }
    }

    def sortLessons = {
        def courseInstance = Course.get( params.id )
        [ courseInstance : courseInstance ]
    }

    def show = {
        def courseInstance
        def courseInstanceList = Course.list()
        if (params.id != '') {
            courseInstance = Course.get( params.id )
        }
        else {
            courseInstance = courseInstanceList[0]
        }

        if(!courseInstance && params.id) {
            flash.message = "Course not found with id ${params.id}"
            redirect(action:'list')
        }
        else { 
            return [ courseInstance : courseInstance, 
                     activeInterestCount : courseService.activeInterests(courseInstance).size(),
                     courseInstanceList : courseInstanceList ]
        }
    }

    def delete = {
        def courseInstance = Course.get( params.id )
        if(courseInstance) {
            try {
                courseInstance.delete(flush:true)
                flash.message = "Course ${params.id} deleted"
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "Course ${params.id} could not be deleted"
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = "Course not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def courseInstance = Course.get( params.id )

        if(!courseInstance) {
            flash.message = "Course not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ courseInstance : courseInstance ]
        }
    }

    def update = {
        def courseInstance = Course.get( params.id )
        if(courseInstance) {
            if(params.version) {
                def version = params.version.toLong()
                if(courseInstance.version > version) {
                    
                    courseInstance.errors.rejectValue("version", "course.optimistic.locking.failure", "Another user has updated this Course while you were editing.")
                    render(view:'edit',model:[courseInstance:courseInstance])
                    return
                }
            }
            courseInstance.properties = params
            if(!courseInstance.hasErrors() && courseInstance.save()) {
                flash.message = "Course ${params.id} updated"
                redirect(action:show,id:courseInstance.id)
            }
            else {
                render(view:'edit',model:[courseInstance:courseInstance])
            }
        }
        else {
            flash.message = "Course not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def create = {
        def courseInstance = new Course()
        courseInstance.properties = params
        return ['courseInstance':courseInstance]
    }

    def save = {
        def courseInstance = new Course(params)
        if(!courseInstance.hasErrors() && courseInstance.save()) {
            flash.message = "Course ${courseInstance.id} created"
            redirect(action:show,id:courseInstance.id)
        }
        else {
            render(view:'create',model:[courseInstance:courseInstance])
        }
    }
    
    def manageCallList = {
        render("mg. call list")
    }

    // prints PDF version of call list
    // uses similar options for filtering call list by user, or by search term
    // doensn't support options for printing page 2 -- users can just do that from the freaking' PDF
    def printableCallList = {
        
        // chain(controller:'jasper',
              // action:'index',
              // model:[data:reportData],params:params)
        def courseInstance = Course.get(params.id) 
        def options = [:]
        if (params.q) options['q'] = params.q

        if(params.reservedForUser) {
            options['reservedForUser'] = ShiroUser.get(params.reservedForUser)
        }
        def contactInstanceList = courseService.callList(courseInstance.id, options)
        def callListContacts = courseService.callListContacts(courseInstance)

        def model = [ 
                   contactInstanceList : contactInstanceList,
                      callListContacts : callListContacts, 
                        courseInstance : courseInstance ]

        def filename = "call_list_" + courseInstance.name.substring(0, 4) + '_' + (new Date()).format('yyyy_MM_dd') + '.pdf'
        if (params.pdf) {
            renderPdf(template:"printableCallList", model:model, filename:filename)
        }
        else {
            render(template:"printableCallList", model:model, filename:filename)
        }
        
    }

    // Fetches new lesson dates from course specified in params.id
    // starting at params.startDate or today
    def nextAvailableLessonDates = {
        def p = Course.get(params.id)
        def startDate = new Date()
        if (params.startDate) {
            startDate = Date.parse('MM/dd/yyyy', params.startDate)
        }
        def lessonDates = courseService.nextAvailableLessonDates(p, startDate)
        render(template:'/classSession/editLessonDates',
                  model:[lessonDates:lessonDates])
    }
    
    // ---------------------------------
    
    def buildReportData = { interest ->
        def student = interest.student
        def contact = student.contact 
        
        def addr = [ contact.address1 , contact.address2 ?: '' ]
        def csz = [ contact.city ?: '' , contact.state ?: '', contact.zipCode ?: '']
        
        [
            CONTACT_NAME:contact,
            CONTACT_ADDRESS:addr.join('<BR />'),
            // TODO Contact Notes, mmmk?
            CONTACT_NOTES:'',
            CONTACT_CITY_STATE_ZIP:csz.join(', '),
            CONTACT_EMAIL:contact.emailAddress,
            CONTACT_PHONE:contact.phoneNumbers.join('<br />'),
            CONTACT_ID:contact.id,
            STUDENT_NAME:student.fullName(),
            STUDENT_BIRTHDATE:student.birthDate ?: '?',
            STUDENT_GENDER:student.gender ?: '?',
            STUDENT_GRADE:student.grade ?: '?'
        ]        
    }
    

    // TODO refactor
    def interestedStudents = {

        // default to showing 10 records, and at most 100 records
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)

        def courseInstance = Course.get(params.id)
        if (courseInstance) courseService.updateCallListContacts(courseInstance)
        def classSessionInstance = ClassSession.get(params.classSessionId)
        def callListContacts = courseService.callListContacts(courseInstance)

        def options = [ 
            max:params.max?.toLong(), 
            offset:params.offset?.toLong()
        ] 

        if (params.contactId) {
            options['contactId'] = params.contactId
        }

        if (params.q) options['q'] = params.q

        if(params.reservedForUser) {
            options['reservedForUser'] = ShiroUser.get(params.reservedForUser)
        }
            
        PagedResultList contactInstanceList = 
            courseService.callList(params.id.toLong(), options) 

        def interests = courseService.activeInterests(courseInstance)

        def data = 
        [ courseInstanceList : Course.list(),
        contactInstanceList : contactInstanceList,
          contactInstanceTotal : contactInstanceList.totalCount,
          reservedForUserId : params.reservedForUser,
            courseInstance : courseInstance,
            callListContacts : callListContacts,
            currentUser : userService.loggedInUser(),
            activeInterests : interests,
            users : ShiroUser.list(), 
            classSessionInstance : classSessionInstance ]

        // dam, this is ugly.  see if there's a property called 'newOffset'
        try {
            if (contactInstanceList.newOffset) {
                params.offset = contactInstanceList.newOffset.toString()
            }
        } catch (Exception e) {}

        if (params.contactId) {
            data['selectedContactId'] = params.contactId
        }

        return data

    }

    def callListReportData = {
        def courseInstance = Course.get(params.id)
        params['PROGRAM_NAME'] = courseInstance.name

        // Default Graduation Date to date of last class
        // TODO: Refactor to a Service, or else give classSession a graduationDate
        def interests = courseService.activeInterests(courseInstance)

        return interests.collect(buildReportData)
    }

}
