package org.bworks.bworksdb
import grails.test.*
import grails.orm.PagedResultList
import org.bworks.bworksdb.auth.ShiroUser

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
    def callList(id, offset = 0, maxResults = null) {
        def crit = Contact.createCriteria() 
        
        def contacts = crit.listDistinct {
            students {
                order 'starred', 'desc'

                interests {
                    eq 'course.id', id
                    order 'signupDate', 'asc'
                    eq 'active', true
                }
            }
        }
        // Hack that will avoid NULL inactive student if a contact
        // has interested and un-interested students
        contacts*.refresh()       

        def totalCount = contacts.size()
        // Another hack that implements pagination
        if (offset && offset < contacts.size()) {
            contacts = contacts[offset .. contacts.size() - 1]
        }

        if (maxResults) {
            def upperBound = Math.min(contacts.size(), maxResults)

            contacts = contacts[0 .. upperBound - 1]
        }

        return new PagedResultList(contacts, totalCount)

   }

    def activeInterests(Course p) {
        return Interest.findAllByCourseAndActive(p, true)
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

    // Return a hash map of 
    //     contactId : [ CallListContact ]
    // for a particular class session
    def callListContacts(classSession) {
        def clc = [:]
        CallListContact.findAllByClassSession(classSession).each {
            clc[it.contact.id] = it
        }

        return clc

    }

}
