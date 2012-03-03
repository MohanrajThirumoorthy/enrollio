package org.bworks.bworksdb

import grails.test.*

class UrlMappingsTests extends GrailsUrlMappingsTestCase {
    
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testDefaultMapping() {
        assertUrlMapping("/", controller:'help', action:'about')
    }

    void testHelpMappings() {
        assertUrlMapping("/thanks", controller:'help', action:'thanks')
    }

    void testUserSettingMappings() {
        assertUrlMapping("/userSettings", 
                         controller:'userSetting', action:'list') 
        assertUrlMapping("/editUserSetting", 
                         controller:'userSetting', action:'edit') 
    }
    void testUserMappings() {
        assertUrlMapping("/showUser/bob", 
                         controller:'shiroUser', action:'show') {
            username = "bob"
        }

        assertUrlMapping("/editUser/doug", controller:'shiroUser', action:'edit') {
            username = "doug"
        }

        assertUrlMapping("/updateUser", controller:'shiroUser', action:'update')
        assertUrlMapping("/saveUser", controller:'shiroUser', action:'save')
    }

    void testContactMappings() {
        assertUrlMapping("/createContact", controller:'contact', action:'create')
        assertUrlMapping("/editContact/1", controller:'contact', action:'edit') {
            id = "1"
        }

        assertUrlMapping("/addContactNote/2", controller:'contact', action:'addNote') {
            id = "2"
        }
    }

    void testCourseMappings() {

        assertUrlMapping("/manageCallList/13", controller:'course', action:'manageCallList') {
            id = "13"
        }
        assertUrlMapping("/printableCallList/18", controller:'course', action:'printableCallList') {
            id = "18"
        }
        assertUrlMapping("/editCourse/1", controller:'course', action:'edit') {
            id = "1"
        }

        assertUrlMapping("/nextAvailableLessonDates", controller:'course', action:'nextAvailableLessonDates')

        // Ensure that /editCourse needs to be passed an ID
        shouldFail(IllegalArgumentException) {
            assertUrlMapping('/editCourse', controller: 'course',
                                                  action: 'edit')
        }

        assertUrlMapping("/sortLessons/1", controller:'course', action:'sortLessons') {
            id = "1"
        }
        assertUrlMapping("/saveLessonSort", controller:'course', action:'saveLessonSort')

    }

    void testStudentMappings() {
        assertUrlMapping("/editStudent/123", controller:'student', action:'edit') {
            id = 123
        }
        assertUrlMapping("/updateStudent", controller:'student', action:'update')
    }

    void testInterestMappings() {
        assertUrlMapping("/updateInterest", controller:'interest', action:'updateInterest') 
    }

    void testClassSessionMappings() {
        assertUrlMapping("/envelopes/112", controller:'classSession', action:'envelopes') {
            id = 112
        }
        assertUrlMapping("/createClassSession", controller:'classSession', action:'create')

        assertUrlMapping("/saveClassSession",controller:'classSession', action:'save')

        assertUrlMapping("/interestedStudents/73", controller:'course', action:'interestedStudents') {
            id = 73
        }

        shouldFail(IllegalArgumentException) {
            assertUrlMapping('/classSession/enroll', controller: 'classSession',
                                                         action: 'enroll')
        }

        shouldFail(IllegalArgumentException) {
            assertUrlMapping('/editEnrollments/', controller: 'classSession', action:'editEnrollments')
        }

        // absence of trailing '/' in URL shouldn't make a difference
        shouldFail(IllegalArgumentException) {
            assertUrlMapping('/editEnrollments', controller: 'classSession', action:'editEnrollments')
        }

        assertUrlMapping('/printGradCerts', controller:'classSession', action:'printGradCerts')
        assertUrlMapping('/printWelcomeLetter', controller:'classSession', action:'printWelcomeLetter')

        assertUrlMapping('/attendanceSheet/444', controller:'classSession', action:'attendanceSheet') {
            id = "444"
        }

        assertUrlMapping('/classSession/321', controller:'classSession', action:'show') {
            id = 321
        }


        assertUrlMapping('/editClassSession/765', controller:'classSession', action:'edit') {
            id = 765
        }

        assertUrlMapping('/updateClassSession', controller:'classSession', action:'update')
    }

    void testLessonMappings() {
        assertUrlMapping("/lessonDate/1", controller:'lessonDate', action:'show') {
            id = "1"
        }

        assertUrlMapping("/editLesson/1", controller:'lesson', action:'edit') {
            id = "1"
        }

        assertUrlMapping("/updateLesson", controller:'lesson', action:'update')
        assertUrlMapping("/lessons", controller:'lesson', action:'list')

    }
    
    void testSettingMappings() {
        assertUrlMapping("/editSetting/50", controller:'configSetting', action:'edit') {
            id = "50"
        }

        assertUrlMapping("/showSetting/5", controller:'configSetting', action:'show') {
            id = "5"
        }

        assertUrlMapping("/updateSetting", controller:'configSetting', action:'update')
    }
}
