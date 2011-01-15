package org.bworks.bworksdb
import org.grails.comments.Comment

class ContactController {
    
    def studentService
    def contactService
    def courseService
    def userService
    def configSettingService
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', saveStudent:'POST', save:'POST', update:'POST']

    def list = {
        def contactList
        def contactCount 
        
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
        if(params.q){
            contactList = Contact.search( params.q + "*", offset:params.offset ).results
            contactCount = Contact.countHits( params.q + "*" )
        } else { 
            contactList = Contact.list( params )
            contactCount = Contact.count()
        }
        [ contactInstanceList: contactList, contactInstanceTotal: contactCount, previousQuery: params.q ]
    }

    def show = {
        def contactInstance = Contact.get( params.id )

        if(!contactInstance) {
            flash.message = "Contact not found with id ${params.id}"
            redirect(action:list)
        }
        else { 
            def newStudentInstance = contactService.createStudentStub(contactInstance)
            def contactCallListPositions = courseService.contactCallListPositions(contactInstance)
            return [ contactInstance : contactInstance, 
                  newStudentInstance : newStudentInstance,
                  contactCallListPositions : contactCallListPositions ] 
        }
    }

    def delete = {
        def contactInstance = Contact.get( params.id )
        if(contactInstance) {
            try {
                contactInstance.delete(flush:true)
                flash.message = "Contact ${params.id} deleted"
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "Contact ${params.id} could not be deleted"
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = "Contact not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def contactInstance = Contact.get( params.id )

        if(!contactInstance) {
            flash.message = "Contact not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            // Create two new phone numbers if no phonez
            if (!contactInstance.phoneNumbers || 
                    contactInstance.phoneNumbers.size() == 0) {
                contactInstance.addToPhoneNumbers(new PhoneNumber(label:'Home', phoneNumber:""))
                contactInstance.addToPhoneNumbers(new PhoneNumber(label:'Work', phoneNumber:""))
            }
            return [ contactInstance : contactInstance ]
        }
    }

    def update = {
        def contactInstance = Contact.get( params.id )
        if(contactInstance) {
            if(params.version) {
                def version = params.version.toLong()
                if(contactInstance.version > version) {
                    
                    contactInstance.errors.rejectValue("version", "contact.optimistic.locking.failure", "Another user has updated this Contact while you were editing.")
                    render(view:'edit',model:[contactInstance:contactInstance])
                    return
                }
            }
            contactInstance.properties = params
            if(!contactInstance.hasErrors() && contactInstance.save()) {
                flash.message = "Contact ${params.id} updated"
                redirect(action:show,id:contactInstance.id)
            }
            else {
                render(view:'edit',model:[contactInstance:contactInstance])
            }
        }
        else {
            flash.message = "Contact not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def create = {
        def contactInstance = new Contact()
        def studentInstance = contactService.createStudentStub(contactInstance)
        // Create two new phone numbers
        contactInstance.addToPhoneNumbers(new PhoneNumber(label:'Home'))
        contactInstance.addToPhoneNumbers(new PhoneNumber(label:'Work'))
        contactInstance.city = configSettingService.getSetting(ConfigSetting.DEFAULT_CITY)
        contactInstance.state = configSettingService.getSetting(ConfigSetting.DEFAULT_STATE)
        contactInstance.properties = params
        def defaultAreaCode = configSettingService.getSetting(ConfigSetting.DEFAULT_AREA_CODE)?.toString()
        return ['contactInstance':contactInstance,
                'studentInstance':studentInstance,
                 defaultAreaCode : defaultAreaCode]
    }

    // TODO DRY up the 'save' action and 'addStudent' action.
    def save = {
        def contactInstance = new Contact(params)
        def studentInstance

        if (params.newStudentOption) {
            studentInstance = new Student(params.student)
            studentInstance.validate()
        }

        // prepare for invalid contact or invalid student
        def signupDates
        def possibleInterests = [params['interestInCourse']].flatten()
        def studentSignupDate = params.studentSignupDate

        if (studentSignupDate) {
            signupDates = [:]
            [params['interestInCourse']].flatten().each { courseId ->
                signupDates[courseId] = Date.parse('MM/dd/yyyy', studentSignupDate)
            }
        }

        if (contactInstance.hasErrors() || !contactInstance.validate() ||
            (studentInstance && studentInstance.hasErrors())) {
            // remove annoying message about 'contact' must have a value
                studentInstance.discard()
                contactInstance.discard()
                render(view:'create', model:[contactInstance   : contactInstance,
                                             studentInstance   : studentInstance,
                                             studentSignupDate : studentSignupDate,
                                             possibleInterests : possibleInterests])
        }
        else {
            // student is valid or user doesn't want to save it.
            // proceed with contact saving
            if (contactInstance.save()) {
                if (studentInstance) {
                    studentInstance.contact = contactInstance
                    contactInstance.addToStudents(studentInstance).save()
                    studentInstance.save()
                    studentService.saveInterests(studentInstance, params['interestInCourse'], signupDates)
                }
                if (params.noteText) {
                    contactInstance.addComment(userService.loggedInUser(), params.noteText)
                    contactInstance.save()
                }
                flash.message = "Created contact \"${contactInstance}\".  You can enter students below."
                redirect(action:show,id:contactInstance.id)
            }
        }
    }

    def saveStudent = {
        def studentInstance = new Student(params)

        // Find contact that student belongs to.
        def contactInstance = Contact.get(params.contact.id)

        if(!studentInstance.hasErrors() && studentInstance.validate()) {
            contactInstance.addToStudents(studentInstance)

            // get the one signup date on this form, and apply
            // it to each course that the student is interested in.
            def signupDates = null
            if (params['signupDate']) {
                signupDates = [:]
                [params['interestInCourse']].flatten().each { courseId ->
                    signupDates[courseId] = Date.parse('MM/dd/yyyy', params['signupDate'])
                }
            }

            studentService.saveInterests(studentInstance, params['interestInCourse'], signupDates)
            flash.studentMessage = "Successfully added '${studentInstance.fullName()}'"
            // render(template:'studentList', model:[contactInstance:contactInstance])
            redirect(action:'show', id:contactInstance.id)
        }
        else {
            render(view:'show',
                  model:[studentInstance:studentInstance,
                         contactInstance:contactInstance])
        }
    }
    //Replace inline div with "New student" button
    def cancelInlinestudent = {
        render(template: 'newInlinestudentButton', model: ['studentidx': params.studentidx])
    }

    /**
     * Delete an individual student associated with the given id from the DB
     */
    def deleteInLineStudent = {
        def contactInstance
        // student id passed from GSP
        if (params.id) {
            def studentInstance = student.get(params.id)
                contactInstance = studentInstance.contact
                // Remove student from list on contact DO
                contactInstance.removeFromStudents(studentInstance)
                studentInstance.delete() // Delete student from DB
                contactInstance.save(flush: true)
                render(template: "studentList",
                        model: [contactInstance:contactInstance])
        }
        // contact id passed from GSP
        else if (params.contact.id) {
            // Return a refreshed contact instance
            contactInstance = contact.get(params.contact.id)
                render(template: "studentList",
                        model: [contactInstance: contactInstance])
        }
    }

    def addNote = {
        def contactInstance = Contact.get( params.id )

        if(!contactInstance) {
            flash.message = "Contact not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            if (params.noteText) {
                contactInstance.addComment(userService.loggedInUser(), params.noteText)
                contactInstance.save()
                flash.message = "Note saved."
            }
            else {
                flash.message = "Blank notes are not allowed.  Meow."
            }
        
        }
        redirect(action:'show', id:contactInstance.id)
    }

    def updateNote = {
        def noteInstance = Comment.get( params.id )
        if (!noteInstance) {
            render "Note not found with id: " + params.id
        }
        else {
            noteInstance.body = params.noteText
            noteInstance.posterId = userService.loggedInUser()?.id
            noteInstance.save()
            render(template:"/common/showNote", model:[noteInstance:noteInstance]);
        }
    }
}
