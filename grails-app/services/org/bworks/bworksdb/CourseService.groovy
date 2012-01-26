package org.bworks.bworksdb
import grails.test.*
import grails.orm.PagedResultList
import org.bworks.bworksdb.auth.ShiroUser
import org.bworks.bworksdb.CallListContact

class CourseService {

    boolean transactional = true

    def sequenceIncr = 100

    // Go through Courses's Lessons, and create dummy
    // LessonDates, starting with startDate
    def nextAvailableLessonDates(Course p, Date startDate) {
        def d = startDate
        def proposedClasses = []
        p.lessons.each {
            proposedClasses << new LessonDate(lesson:it, lessonDate:d)
            d = d + 7
        }

        return proposedClasses
    }


    // find non-starred students, sorted by interest date
    // add their contacts to the list, unless contact is already in list
    // because contact has a starred student.
    def callList(courseId, options = [:]) {
        def contacts = contactsInterestedInCourse(courseId, options)
        // Hack that will avoid NULL inactive student if a contact
        // has interested and un-interested students
        contacts*.refresh()       

        // yet another hack -- couldn't easily find way to join
        // CallListContact table, which the Contact model doesn't know about.
        if (options.reservedForUser) {
            def callListContacts = 
                CallListContact.findAllByUserAndCourse(options.reservedForUser, 
                                                        Course.get(courseId))
            def consToRemove = [ ]
            contacts.eachWithIndex { contact, index ->
                if (!callListContacts.find { clc -> clc.contact.id == contact.id }) {
                    consToRemove.add(contact)
                }
            }

            println "removeing" + consToRemove
            consToRemove.each { conToRemove ->
                println "Removing " + conToRemove
                contacts.remove(conToRemove)
            }
        }

        def totalCount = contacts.size()

        def searchingForContactId
        def newOffset
        if (options.contactId) {
            searchingForContactId = contacts.find { it.id == options.contactId.toLong() }
            if (searchingForContactId) {
                // we have to pass back this new offset, to tell
                // the view what person we're on.
                newOffset = contacts.indexOf(searchingForContactId)
                // keep only contacts after the contact we're searching for
                contacts = contacts[contacts.indexOf(searchingForContactId) .. contacts.size() - 1]
            }
        }
        else if (options.offset && options.offset < contacts.size()) {
            // Another hack that implements pagination
            // see if caller wants offset
            contacts = contacts[options.offset .. contacts.size() - 1]
        }

        if (options.max && contacts.size() > 0) {
            def upperBound = Math.min(contacts.size(), options.max)

            contacts = contacts[0 .. upperBound - 1]
        }

        def resultList = new PagedResultList(contacts, totalCount)
        if (newOffset) {
            resultList.metaClass.newOffset = newOffset
        }
        return resultList

   }

    def activeInterests(Course p) {
        // return Interest.findAllByCourseAndActive(p, true)

        def c = Interest.createCriteria()
        return c.list {
            eq('active', true)
            eq('course', p)
            student {
                contact {
                    eq('cannotReach', false)
                }
            }
        }
    }

    // Utility method to make sure we have lesson sequences
    // in a standard order (separated by sequenceIncr, so that we can easily
    // add new Lessons between other lessons w/o trampling existing sequences)
    def sequenceLessons(Course p) {
        p.refresh()
        def lessons = p.lessons.collect { it }
        def newSequence = sequenceIncr
        lessons.each {
            if (it.sequence != newSequence) {
                it.sequence = newSequence
                it.save(flush:true)
            }
            newSequence += sequenceIncr
        }
    }

    def sortLessons(Course p, params) {
        def seq = sequenceIncr
        def lessonIdList = sortedLessonIdList(params)
        lessonIdList.each {
            def lesson = Lesson.get(it)
            if ( lesson.sequence != seq ) {
                lesson.sequence = seq
                lesson.save(flush:true)
            }
            seq = seq + sequenceIncr
            
        }
        // clean up any lessons that might have been saved
        // since the lessonIdList was composed
        sequenceLessons(p)
    }

    // returns a list of lesson IDs, sorted by their
    // suggested sequence
    // Takes a map consisting of data like this:
    // [ 
    //     'lessonId_42' : 1,
    //     'lessonId_64' : 2,
    //     'lessonId_1'  : 4,
    //     'lessonId_76' : 3,
    //     'lessonId_2'  : '16' 
    // ]
    //  And returns this : [ 42, 64, 76, 1, 2 ]
    def sortedLessonIdList(params) {
        def lessonMap = params.findAll { 
            it.key =~ /lessonId_/
        }

        def sortedLessonIds = lessonMap.keySet().sort {
            lessonMap[it].toInteger()
        } 

        // Rip the xx from 'lessonId_xx'
        sortedLessonIds = sortedLessonIds.collect {
            it.split('_')[1].toInteger()
        }

        return sortedLessonIds
        
    }

    def nextAvailSequence(Course p) {
        def lesson
        try {
            lesson = p.lessons?.last()
        } catch (Exception e) {
            // for some reason, courses with no
            // lessons get here in the functional tests,
            // but not integration tests.  See testNextAvailSequence -
            // it doesn't fail, but testNewLessonForCourse does. :-/
        }
        return lesson ? lesson.sequence + sequenceIncr : sequenceIncr
    }

    // Retrieve a list of contacts that are "reserved" 
    def callListContacts(course) {
        def clc = [:]
        CallListContact.findAllByCourse(course).each {
            clc[it.contact.id] = it
        }

        return clc

    }

    // return a list of the positions that this contact has
    // for any course.  Example, contact is 1st on call list for EAC,
    // 2nd on call list for Mentorship, etc.
    // list is indexed/keyed by course id.
    def contactCallListPositions(contactInstance) {
        def contactCallListPositions = CallListContact.findAllByContact(contactInstance)
        def coursePositions = [:]
        contactCallListPositions.each {
            coursePositions[it.course.id] = it
        }
        return coursePositions
    }

    // generate / regenerate CallListContacts
    // for a particular course.  This creates a list of 
    // contacts who have students interested in a course, and their place in line.
    def updateCallListContacts(course) {
        def contacts = contactsInterestedInCourse(course.id)
        contacts.eachWithIndex { contact, pos ->
            // don't show zero-based positions.
            pos++
            def clc = CallListContact.findByCourseAndContact(course, contact)
            if (!clc) {
                clc = new CallListContact(course:course, contact:contact, callListPosition : pos.toLong()).save()
            }
            else {
                clc.callListPosition = pos.toLong()
                clc.save()
            }
        }
    }

    def contactsInterestedInCourse(courseId, options = [:]) {
        def crit = Contact.createCriteria() 
        
        def contacts = crit.listDistinct {
            // contacts must be contacted (i.e. cannot reach is either NULL or false)
            if (options.q) {
                or {
                    ilike('lastName', "%${options.q}%")
                    ilike('firstName', "%${options.q}%")
                }
            }
            ne 'cannotReach', true
            students {
                order 'starred', 'desc'

                interests {
                    eq 'course.id', courseId
                    order 'signupDate', 'asc'
                    eq 'active', true
                }
            }

        }
    }

}
