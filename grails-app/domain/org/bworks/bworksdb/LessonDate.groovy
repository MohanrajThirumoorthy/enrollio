package org.bworks.bworksdb

class LessonDate implements Comparable {

    static belongsTo = [ ClassSession, Lesson ]
    static hasMany = [ attendees : Attendance ]

    SortedSet attendees
    ClassSession classSession
    Lesson lesson
    Date lessonDate
    
    static constraints = {
    }

    int compareTo(obj) {
        this.lessonDate <=> obj.lessonDate
    }

    String toString() {
        this.lesson.toString() + ' ' + lessonDate.format('MMM. d, yyyy')
    }

    String shortInfo() {
        this.lesson.toString().split()[0] + ' ' + lessonDate.format('MMM d')
    }
}
