package org.bworks.bworksdb

import grails.test.*
import org.bworks.bworksdb.util.TestKeys
import org.bworks.bworksdb.auth.ShiroUser
import org.bworks.bworksdb.CallListContact


class CourseServiceIntegrationTests extends GrailsUnitTestCase {
    def courseService
    def testDataService
    
    void testFindInterestedContacts() {
        def (computerContact, computerStudent, computerCourse) = 
           testDataService.setupContactAndStudentWithCourse('ComputerContact', 'ComputerStudent', 'Computer Course')

        def (bikeContact, bikeStudent, bikeCourse) = 
           testDataService.setupContactAndStudentWithCourse('BikeContact', 'BikeStudent', 'Bike Course')

        // set up student interested in both bike and computer course
        def (bothContact, bothStudent) = 
           testDataService.setupContactAndStudentWithCourse('BothContact', 
                                            'BothStudent', 
                                            'Bike Course', 'Computer Course')

        // set up student interested in some other course
        def (someContact, someStudent) = 
           testDataService.setupContactAndStudentWithCourse('SomeContact', 
                                            'SomeStudent', 
                                            'Some Course', 'Some Course')

        // add another course with nobody interested, just to flesh out the test scenario
        def thirdCourse = new Course(name:"third course", description:"foo desc.").save()
        
        def computerCallList = courseService.callList(computerCourse.id)
        
        assertEquals 'Two contacts should be on computer course call list', 2, computerCallList.size()
        assertNotNull computerCallList.find { it.lastName == 'ComputerContact' }
        assertNotNull computerCallList.find { it.lastName == 'BothContact' }

        def bikeCallList = courseService.callList(bikeCourse.id)
        assertEquals 'Two contacts should be on bike course call list', 2, bikeCallList.size()
        assertNotNull bikeCallList.find { it.lastName == 'BikeContact' }
        assertNotNull bikeCallList.find { it.lastName == 'BothContact' }
    }
    
    void testFilterCallListContact() {
        // we only want to see contacts reserved to user 'Bob'
        def (con1, stu1, computerCourse) = 
           testDataService.setupContactAndStudentWithCourse('con1', 'stu1', 'Computer Course')
        def (con2, stu2) = 
           testDataService.setupContactAndStudentWithCourse('con2', 'stu2', 'Computer Course')
        def (con3, stu3) = 
           testDataService.setupContactAndStudentWithCourse('con3', 'stu3', 'Computer Course')
        def (con4, stu4) = 
           testDataService.setupContactAndStudentWithCourse('con4', 'stu4', 'Computer Course')

        def bob = ShiroUser.findByUsername('bob')
        assertNotNull bob
        assertNotNull new CallListContact(user:bob, contact:con2, course:computerCourse).save()
        assertNotNull new CallListContact(user:bob, contact:con4, course:computerCourse).save()

        def options = [ reservedForUser : bob ]
        def contactList = courseService.callList(computerCourse.id, options)
        
        assertEquals 2, contactList.size()
        assertEquals 'con2',  contactList[0].lastName
        assertEquals 'con4',  contactList[1].lastName
    }

    void testStarredStudentsFirst() {
        def (firstContact, firstStudent, computerCourse) = 
           testDataService.setupContactAndStudentWithCourse('FirstContact', 'FirstStudent', 'Computer Course')

        def (firstStarredContact, firstStarredStudent) = 
           testDataService.setupContactAndStudentWithCourse('FirstStarredContact', 'SecondStudent', 'Computer Course')

        // set starred for this student
        firstStarredStudent.starred = true
        firstStarredStudent.save()

        def (thirdContact, thirdStudent) = 
           testDataService.setupContactAndStudentWithCourse('ThirdContact', 'ThirdStudent', 'Computer Course')
        
        def (secondStarredContact, secondStarredStudent) = 
           testDataService.setupContactAndStudentWithCourse('SecondStarredContact', 'FourthStudent', 'Computer Course')

        secondStarredStudent.starred = true
        secondStarredStudent.save()

        def contactList = courseService.callList(computerCourse.id)
        
        assertEquals 'FirstStarredContact',  contactList[0].lastName
        assertEquals 'SecondStarredContact', contactList[1].lastName
        assertEquals 'FirstContact',         contactList[2].lastName
        assertEquals 'ThirdContact',         contactList[3].lastName

    }

    // only active interests should be returned on call list
    void testActiveStudents() {
        def (inactiveContact, inactiveStudent, computerCourse) = 
           testDataService.setupContactAndStudentWithCourse('inactiveContact', 'inactiveStudent', 'Computer Course')

        inactiveStudent.interests.each {
            it.active = false
            it.save()
        }

        def (activeContact, activeStudent) = 
           testDataService.setupContactAndStudentWithCourse('ActiveContact', 'ActiveStudent', 'Computer Course')

        def activeStudent_InactiveBrother
        (activeContact, activeStudent_InactiveBrother) = 
           testDataService.setupContactAndStudentWithCourse('ActiveContact', 'ActiveStudentInactiveBrother', 'Computer Course')

        activeStudent_InactiveBrother.interests.each {
            it.active = false
            it.save()
        }

        def (anotherActiveContact, anotherActiveStudent) = 
           testDataService.setupContactAndStudentWithCourse('AnotherActiveContact', 'AnotherActiveStudent', 'Computer Course')

        def (anotherInactiveContact, anotherInactiveStudent) = 
           testDataService.setupContactAndStudentWithCourse('AnotherInactiveContact', 'AnotherInactiveStudent', 'Computer Course')

        anotherInactiveStudent.interests.each {
            it.active = false
            it.save()
        }

        def contactList = courseService.callList(computerCourse.id)
        assertEquals 2, contactList.size()
        assertNotNull contactList.find {
            it.lastName == 'ActiveContact'
        }
        assertNotNull contactList.find {
            it.lastName == 'AnotherActiveContact'
        }
    }

    // Only one instance of a contact should be returned,
    // even if that contact has > 1 interested student
    void testUniqueContacts() {
        def contact, student1, student2, student3, computerCourse
        (contact, student1, computerCourse) = 
           testDataService.setupContactAndStudentWithCourse('Contact', 'Student1', 'Computer Course')

        (contact, student2) =
           testDataService.setupContactAndStudentWithCourse('Contact', 'Student2', 'Computer Course')
        (contact, student3) =
           testDataService.setupContactAndStudentWithCourse('Contact', 'Student3', 'Computer Course')

        def contactList = courseService.callList(computerCourse.id)
        assertEquals 1, contactList.size()
        assertEquals 'Contact', contactList[0].lastName
    }


    void testInterestedContactsPagination() {
        def (computerContact, computerStudent, computerCourse) = 
           testDataService.setupContactAndStudentWithCourse('ComputerContact', 'ComputerStudent', 'Computer Course')

        def (bikeContact, bikeStudent, bikeCourse) = 
           testDataService.setupContactAndStudentWithCourse('BikeContact', 'BikeStudent', 'Bike Course')

        // set up student interested in both bike and computer course
        def (bothContact, bothStudent) = 
           testDataService.setupContactAndStudentWithCourse('BothContact', 
                                            'BothStudent', 
                                            'Bike Course', 'Computer Course')

        // set up student interested in some other course
        def (someContact, someStudent) = 
           testDataService.setupContactAndStudentWithCourse('SomeContact', 
                                            'SomeStudent', 
                                            'Some Course', 'Some Course')

        // add another course with nobody interested, just to flesh out the test scenario
        def thirdCourse = new Course(name:"third course", description:"foo desc.").save()
        
        def computerCallList = courseService.callList(computerCourse.id)
        
        assertEquals 'Two contacts should be on computer course call list', 2, computerCallList.size()
        assertNotNull computerCallList.find { it.lastName == 'ComputerContact' }
        assertNotNull computerCallList.find { it.lastName == 'BothContact' }

        def bikeCallList = courseService.callList(bikeCourse.id)
        assertEquals 'Two contacts should be on bike course call list', 2, bikeCallList.size()
        assertNotNull bikeCallList.find { it.lastName == 'BikeContact' }
        assertNotNull bikeCallList.find { it.lastName == 'BothContact' }
    }

    // call list should not have contacts whose cannotReach = true
    void testFilterCannotReach() {
        def (computerContact, computerStudent, computerCourse) = 
           testDataService.setupContactAndStudentWithCourse('ComputerContact', 'ComputerStudent', 'Computer Course')

        def (bikeContact, bikeStudent, bikeCourse) = 
           testDataService.setupContactAndStudentWithCourse('BikeContact', 'BikeStudent', 'Bike Course')

        // set up student interested in both bike and computer course
        def (bothContact, bothStudent) = 
           testDataService.setupContactAndStudentWithCourse('BothContact', 
                                            'BothStudent', 
                                            'Bike Course', 'Computer Course')

        // set up student interested in some other course
        def (unreachableContact, someStudent) = 
           testDataService.setupContactAndStudentWithCourse('UnreachableContact', 
                                            'UnreachableSomeStudent', 
                                            'Bike Course')
        unreachableContact.cannotReach = true
        unreachableContact.save()

        def bikeCallList = courseService.callList(bikeCourse.id)
        assertEquals 'Only reachable contacts should be on list', 2, bikeCallList.size()
        assertNotNull bikeCallList.find { it.lastName == 'BikeContact' }
        assertNotNull bikeCallList.find { it.lastName == 'BothContact' }
    }

}
