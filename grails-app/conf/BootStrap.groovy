import org.bworks.bworksdb.*
import org.bworks.bworksdb.auth.*
import org.apache.shiro.crypto.hash.Sha1Hash
import org.codehaus.groovy.grails.commons.ApplicationHolder

class BootStrap {
    def testDataService
    def searchableService
    def shiroSecurityService
    def grailsApplication

    def init = { servletContext ->
        def totalUsers = ShiroUser.count()


        if (totalUsers == 0) {
            loadUserRoles()
            // loadDevData will load test users, so make sure that
            // admin user is already created before you call loadDevData
            loadAdminUser()
        }

        environments {
            production {
                testDataService.loadDefaultConfigSettings()
            }
            development {
                if (grailsApplication.config.enrollio.loadDummyData) {
                    testDataService.loadDevData(30)
                }
                searchableService.stopMirroring()
                searchableService.startMirroring()
            }
            test {
                ExpandoMetaClass.enableGlobally()

                functionaltestplugin.FunctionalTestCase.metaClass.loginAs = { userName, pass ->
                    get('/login')
                    form('loginForm') {
                        username = userName
                        password = pass
                        click "Sign in"
                    }                    
                }

                testDataService.loadIntegrationTestData()
            }
        }
    }

    def destroy = {
    }

    def loadAdminUser() {

        // Administrator user and role. 
        def adminRole = ShiroRole.findByName("Administrator")
        def admin_username = "admin"
        def admin_pass = "admin0"
        def adminUser = new ShiroUser(username: admin_username, 
            firstName : 'Bert',
            lastName : 'Adminbadboy',
            password : admin_pass,
            passwordConfirm : admin_pass,
            passwordHash: shiroSecurityService.encodePassword(admin_pass)
        )
        if (!adminUser.validate()) {
            println "User didn't validate!"
            println adminUser.errors.allErrors
            assert false  // Just give up here -- something's wrong
        }
        else {
            adminUser.save()
            new ShiroUserRoleRel(user: adminUser, role: adminRole).save()
        }
    }

    def loadUserRoles() {
        // Initialize User role
        def userRole = new ShiroRole(name: "User").save() 
        def adminRole = new ShiroRole(name: "Administrator").save() 
    }
}

