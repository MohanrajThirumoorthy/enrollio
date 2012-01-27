package org.bworks.bworksdb

class AttendanceService {

    boolean transactional = true

    def initializeAttendees(LessonDate ld) {
        // TODO: Get existing attendances of LessonDate
        // TODO: For each enrolled student that's NOT in attendances,
        //       create one.
        //       Initialize status to 'absent'
        def enrolledStudents = ld.classSession.enrollments.collect { enrollment ->
                enrollment.student
        }

        enrolledStudents.each { student ->
            if(! ld.attendees.find { it.student.id == student.id }) {
                ld.addToAttendees(student : student, status:'absent')
                ld.save()
            }
        }

        // return map of attendences w/studentID as key
        return ld.attendees.inject([ : ]) { map, attendance ->
           map[ attendance.student.id ] = attendance; map
        }
    }
}
