package org.bworks.bworksdb

class Attendance implements Comparable {
    
    static belongsTo = [Student, LessonDate]

    static mapping = {
        sort "student.lastName"
    }

    Student student
    LessonDate lessonDate
    String status
    
    static constraints = {
    }

    int compareTo(obj) {
        def contactCompare = this.student.contact.sortableName() <=> 
            obj.student.contact.sortableName()
        if (contactCompare != 0) {
            return contactCompare
        }
        return this.student.sortableName() <=> obj.student.sortableName()
    }
}




