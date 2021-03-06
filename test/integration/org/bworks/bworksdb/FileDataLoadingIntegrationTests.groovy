package org.bworks.bworksdb

import grails.test.*

class FileDataLoadingIntegrationTests extends GrailsUnitTestCase {
    def dataLoadingService

    def initSessionCount
    def initEnrollmentCount
    def initInterestCount
    def initStudentCount
    def initContactCount

    protected void setUp() {
        super.setUp()
    
        initSessionCount = ClassSession.count()
        initEnrollmentCount = Enrollment.count()
        initInterestCount = Interest.count()
        initStudentCount = Student.count()
        initContactCount = Contact.count()
    }

    void testFileLoad() {

        dataLoadingService.loadFromFiles()

        assertEquals "Students loaded from file successfully", 
                    initStudentCount + 7, Student.count()

        assertEquals "Contacts loaded from file successfully", 
                    initContactCount + 4, Contact.count()

        assertEquals "Class Sessions loaded from file successfully", 
                    initSessionCount + 24, ClassSession.count()

        assertEquals "Enrollments loaded from file successfully", 
                    initEnrollmentCount + 4, Enrollment.count()

        assertEquals "Interests loaded from file successfully", 
                    initInterestCount + 3, Interest.count()
    }

    void testLoadMessages() {
        def msg = dataLoadingService.loadFromFiles()
        assertNotNull 'Reported # of students imported', msg['messages'].find {
            it =~ /7 students imported/
        }

        assertNotNull 'Reported # of contacts imported', msg['messages'].find {
            it =~ /4 contacts imported/
        }

        assertNotNull 'Reported # of sessions imported', msg['messages'].find {
            it =~ /24 class sessions imported/
        }

        assertNotNull 'Reported # enrollments imported', msg['messages'].find {
            it =~ /4 enrollments imported/
        }

        assertNotNull 'Reported # interests imported', msg['messages'].find {
            it =~ /3 interests imported/
        }

    }
}
