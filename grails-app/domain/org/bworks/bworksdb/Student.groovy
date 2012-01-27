package org.bworks.bworksdb
import org.grails.comments.*

class Student implements Commentable {
    static searchable = {
        contact component:true
    }
    String firstName
    String lastName
    String middleName
    Date birthDate
    String gender
    Integer grade
    String emailAddress
    Contact contact
    static belongsTo = [Contact]
    static hasMany = [ interests:Interest, enrollments:Enrollment ]
    Date dateCreated
    Date lastUpdated
    Boolean starred = false

    static constraints = {
        birthDate(nullable:true, blank:true)
        emailAddress(nullable:true, blank:true)
        firstName(nullable:true, blank:true)
        gender(nullable:true, blank:true)
        grade(nullable:true, blank:true)
        lastName(nullable:false, blank:false)
        middleName(nullable:true, blank:true)
        lastUpdated(nullable:true, blank:true)
        starred(nullable:true)
    }
    
    // Prints 'Gerald David Buchner' or
    //        'Lee Harvey Danger'
    String fullName() {
        def names = [ firstName, middleName, lastName ].findAll {
            it != null
        }

        return names?.join(' ') ?: ''
    }

    String sortableName() {
        def names = [ lastName, firstName, middleName  ].findAll {
            it != null
        }

        return names?.join(' ') ?: ''
    }

    String toString(){
        fullName()
    }

    // Return a printable string of the active interests the student
    // has
    String activeInterestsSummary() {
        // return "Basket weaving, stupidity, sensationalness"
        def progs = []
        interests.each { 
            if (it.active) {
                progs << it.course.name 
            }
        }
        return progs ? progs.join(", ") : ''
    }
    
    Interest[] activeInterests() {
        def interestList = []
        interests.each { 
            if (it.active) {
                interestList << it 
            }
        }
        return interestList
    }

}
