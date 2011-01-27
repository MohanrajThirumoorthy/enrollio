package org.bworks.bworksdb
import org.grails.comments.*

class ClassSession implements Commentable {
    Date startDate
    String name
    Course course
    static belongsTo = [ Course ] 
    static hasMany = [ lessonDates:LessonDate, enrollments:Enrollment ]

    SortedSet lessonDates
    SortedSet enrollments
    static constraints = {
    }

    String toString() {
        course.name + ", " + name
    }

    String abbrev() {
        this.course.name?.substring(0,3) + " " + startDate?.format('MM/yyyy') 
    }
}
