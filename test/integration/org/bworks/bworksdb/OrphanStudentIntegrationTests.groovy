package org.bworks.bworksdb

import grails.test.*
import org.bworks.bworksdb.util.TestData

class OrphanStudentIntegrationTests extends GrailsUnitTestCase {
    def dataLoadingService
    
    void testOrphanStudents() {
        // load class session, contact and student data
        // yes, it's tedious but it's an integration test, meow.
        def classSessions = TestData.fixtureSingleClassSession()
        println classSessions
        dataLoadingService.loadClassSessions(classSessions)


        // Don't load any contacts, just load students
        dataLoadingService.loadStudents(TestData.fixtureMultipleStudents())

        def orphan1 = Student.findByFirstNameAndLastName('Totoro','Tortenweasel')
        assertNotNull "Orphan Totoro loaded successfully", orphan1
        assertEquals 'totoro@alum.bworks.org', orphan1.emailAddress


        def con = orphan1.contact
        assertEquals 'Contact generated correctly', 'Tortenweasel', con.lastName
        assert 'Contact firstname generated correctly', ( con.firstName =~ /Auto-generated/ ).matches()

        // Make sure we have a note that this parent was auto-genned
        assertNotNull "Contact should have Note about being auto-genned", con.comments.find {
                          it.body =~ 'Auto-generated by import'
        }

        // assert that contact's e-mail is == to student's email
        // we might be able to find contacts this way.
        assertEquals "Student e-mail propogated to auto-genned contact", 
                     con.emailAddress, orphan1.emailAddress
        
        // Ensure that Smokey was also added to this contact
        assertNotNull con.students.find {
            it.firstName == 'Smokey' && it.lastName == 'Bandit'
        }

        // Make sure students were enrolled just like any other students
        def sess = dataLoadingService.findClassSessionByOldId("13")
        assertNotNull sess
        assertNotNull 'Orphan student 1 saved enrollment correctly', sess.enrollments.find {
            it.student.firstName == 'Totoro' && it.student.lastName == 'Tortenweasel' && it.status == EnrollmentStatus.GRADUATED
        }

        assertNotNull 'Orphan student 2 saved enrollment correctly', sess.enrollments.find {
            it.student.firstName == 'Smokey' && it.student.lastName == 'Bandit' && it.status == EnrollmentStatus.DROPPED_OUT
        }
    }

    // orphaned students should be given a special signupDate
    // since they don't have a contact, we don't know what date they signed up.
    void testOrphanStudentsInterests() {
        // load class session, contact and student data
        def classSessions = TestData.fixtureSingleClassSession()
        dataLoadingService.loadClassSessions(classSessions)

        // Don't load any contacts, just load students
        dataLoadingService.loadStudents(TestData.fixtureSingleStudent())

        def crit = Interest.createCriteria()

        def interest = crit.get {
           student {
              eq 'firstName', 'Ima'
              eq 'lastName', 'Interested'
           }
        }

        assertNotNull 'Interest was saved for orphan student', interest
        assertEquals 'Signup date is 1/1/2006 for orphaned student', 
                     '1/1/2006', 
                     interest.signupDate.format('M/d/yyyy')
    }
}
        
