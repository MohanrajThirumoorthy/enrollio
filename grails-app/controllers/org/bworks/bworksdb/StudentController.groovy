package org.bworks.bworksdb
import org.apache.shiro.SecurityUtils

class StudentController {
    
    def index = { redirect(action:list,params:params) }

    def studentService
    def contactService
    def searchableService

    static navigation = [
        group:'mainLinks',
        action:'list',
        title:'Students',
		isVisible: { SecurityUtils.subject?.isAuthenticated() },
        order:20
    ]

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def toggleStar = {
        def studentInstance = Student.get(params.id)
        studentInstance?.starred = !(params.starred == 'true')
        studentInstance.save()
        render (template:'/utility/starredThingy', model:[thingy:studentInstance])
    }

    def list = {
        def contactInstanceList
        def contactInstanceTotal
        params.max = 10
        if(params.q){
            // TODO: Total kludge, but works for now :-/
            def search = Contact.search("*" + params.q + "*",
            [ offset:params.offset, max:params.max ] )

            contactInstanceList = search.results
            contactInstanceTotal = search.total
        }
        else {
            contactInstanceList = Contact.list( params )
            contactInstanceTotal = Contact.count()
        }

        [ prevQuery:params.q, contactInstanceList: contactInstanceList,
          contactInstanceTotal: contactInstanceTotal ]
    }

    def delete = {
        def studentInstance = Student.get( params.id )
        if(studentInstance) {
            try {
                studentInstance.delete(flush:true)
                flash.message = "Student ${params.id} deleted"
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "Student ${params.id} could not be deleted"
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = "Student not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def studentInstance = Student.get( params.id )

        if(!studentInstance) {
            flash.message = "Student not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ studentInstance : studentInstance,
                     contactInstance : studentInstance.contact]
        }
    }

    def update = {
        def studentInstance = Student.get( params.id )
        if(studentInstance) {
            if(params.version) {
                def version = params.version.toLong()
                if(studentInstance.version > version) {
                    
                    studentInstance.errors.rejectValue("version", "student.optimistic.locking.failure", "Another user has updated this Student while you were editing.")
                    render(view:'edit',model:[studentInstance:studentInstance])
                    return
                }
            }
            // First, zap birthDate and reformat it.
            def dateFormat = 'MM/dd/yyyy'
            def birthDate = params.remove('birthDate')

            try {
                studentInstance.birthDate = Date.parse(dateFormat, birthDate)
            } catch (Exception e) {
            }
            studentInstance.properties = params
            if(!studentInstance.hasErrors() && studentInstance.save()) {
                // Find courses that student is interested in, and accompanying signupDates.
                // params look like this:  signupDate_1, where 1 is the ID of the course
                def signupDates = [:]
                if(params['interestInCourse']) {
                    def interestedIds = [params['interestInCourse']].flatten()
                    interestedIds.each{ courseId ->
                    signupDates[courseId] = 
                        Date.parse('MM/dd/yyyy', params['signupDate_' + courseId])
                    }
                }
                studentService.saveInterests(studentInstance, 
                                            params['interestInCourse'],
                                            signupDates)
                studentInstance.save()
                flash.message = "Student ${studentInstance} updated"
                redirect(controller:'contact', action:'show', params:[studentId:studentInstance.id])
            }
            else {
                render(view:'edit',model:[studentInstance:studentInstance])
            }
        }
        else {
            flash.message = "Student not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def save = {
        def studentInstance = new Student(params)
        if(!studentInstance.hasErrors() && studentInstance.save()) {
            flash.message = "Student ${studentInstance.id} created"
            redirect(action:show,id:studentInstance.id)
        }
        else {
            render(view:'create',model:[studentInstance:studentInstance])
        }
    }
}
