

package org.bworks.bworksdb

class ConfigSettingController {
    
    def index = { redirect(action:list,params:params) }
    def testDataService

    def dataLoadingService

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST', 
                             generateTestData:'POST',
                             generateTestSessions:'POST']

    def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
        [ configSettingInstanceList: ConfigSetting.list( params ), configSettingInstanceTotal: ConfigSetting.count() ]
    }

    def testDataRequest = {
        [ ]
    }

    def loadDataRequest = {
        []
    }

    def loadDataFromFile = {
        def messages = dataLoadingService.loadFromFiles()

        flash.message = messages.messages
        redirect(controller:'admin', action:'index')
    }

    // TODO: Make this error message friendlier
    def generateTestSessions = {
        try {
            testDataService.loadAllDummyClassSessions(params.moreSessions?.toInteger())
            flash.message = "Test Sessions were successfully generated."
            redirect(uri:'/')
        } catch (Exception e) {
            flash.message = e
            redirect(uri:'/')
        }
    }

    // TODO: Make this error message friendlier
    def generateTestContacts = {
        try {
            def nc = params.numContacts.toInteger()
            testDataService.loadDummyContacts(nc)
            flash.message = "Test data was successfully generated."
            redirect(uri:'/')
        } catch (Exception e) {
            flash.message = e
            redirect(uri:'/')
        }

    }

    // TODO: Make this error message friendlier
    def generateTestCourses = {
        testDataService.loadDefaultCourses()
        flash.message = "Test courses were successfully generated."
        redirect(uri:'/')
    }

    def show = {
        def configSettingInstance = ConfigSetting.get( params.id )

        if(!configSettingInstance) {
            flash.message = "ConfigSetting not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ configSettingInstance : configSettingInstance ] }
    }

    def delete = {
        def configSettingInstance = ConfigSetting.get( params.id )
        if(configSettingInstance) {
            try {
                configSettingInstance.delete(flush:true)
                flash.message = "ConfigSetting ${params.id} deleted"
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "ConfigSetting ${params.id} could not be deleted"
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = "ConfigSetting not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def configSettingInstance = ConfigSetting.get( params.id )

        if(!configSettingInstance) {
            flash.message = "ConfigSetting not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ configSettingInstance : configSettingInstance ]
        }
    }

    def update = {
        def configSettingInstance = ConfigSetting.get( params.id )
        if(configSettingInstance) {
            if(params.version) {
                def version = params.version.toLong()
                if(configSettingInstance.version > version) {
                    
                    configSettingInstance.errors.rejectValue("version", "configSetting.optimistic.locking.failure", "Another user has updated this ConfigSetting while you were editing.")
                    render(view:'edit',model:[configSettingInstance:configSettingInstance])
                    return
                }
            }
            configSettingInstance.properties = params
            if(!configSettingInstance.hasErrors() && configSettingInstance.save()) {
                flash.message = "ConfigSetting ${params.id} updated"
                redirect(action:show,id:configSettingInstance.id)
            }
            else {
                render(view:'edit',model:[configSettingInstance:configSettingInstance])
            }
        }
        else {
            flash.message = "ConfigSetting not found with id ${params.id}"
            redirect(action:list)
        }
    }

}
