

package org.bworks.bworksdb

class ContactController {
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
        [ contactInstanceList: Contact.list( params ), contactInstanceTotal: Contact.count() ]
    }

    def show = {
        def contactInstance = Contact.get( params.id )

        if(!contactInstance) {
            flash.message = "Contact not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ contactInstance : contactInstance ] }
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

     //Create closure in QuestController.gsp
    def create = {
        def contactInstance = new Contact()
        contactInstance.addToPhoneNumbers(new PhoneNumber(label:'Home'))
        contactInstance.addToPhoneNumbers(new PhoneNumber(label:'Work'))
        contactInstance.properties = params
        return ['contactInstance':contactInstance]
    }

    def saveAndAddStudents = {
        def contactInstance = new Contact(params)
        if(!contactInstance.hasErrors() && contactInstance.save()) {
            flash.message = "Contact ${contactInstance.id} created"
            redirect(action:create,controller:"student",params:["contact.id":contactInstance.id])
        }
        else {
            render(view:'create',model:[contactInstance:contactInstance])
        }
    }
    // Only difference between this and saveAndAddStudents is that
    // saveAndAddStudents redirects to student/create action
    def save = {
        def contactInstance = new Contact(params)
        if(!contactInstance.hasErrors() && contactInstance.save()) {
            flash.message = "Contact ${contactInstance.id} created"
            redirect(action:show,id:contactInstance.id)
        }
        else {
            render(view:'create',model:[contactInstance:contactInstance])
        }
    }
}
