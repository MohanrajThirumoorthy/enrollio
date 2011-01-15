package org.bworks.bworksdb
import org.grails.comments.*

class Contact implements Commentable {
    static searchable = {
        phoneNumbers component:true
        students component:true
    }

    String firstName
    String lastName
    String address1
    String address2
    String city
    String state
    String zipCode
    String emailAddress
    Date dateCreated
    Date lastUpdated
    Date signupDate = new Date()

    // Contacts who can't be reached are excluded from calling Lists, etc.
    Boolean cannotReach = false

    // Declared to assist w/adding phoneNumbers to class easily
    // http://lxisoft.com/web/guest/grails
    List phoneNumbers = new ArrayList()
    List students

    static hasMany = [students:Student, phoneNumbers:PhoneNumber]
    
    static constraints = {
        address1(nullable:true)
        address2(nullable:true)
        state(nullable:true)
        city(nullable:true)
        zipCode(nullable:true)
        emailAddress(nullable:true)
        lastUpdated(nullable:true, blank:true)
        lastName(blank:false)
    }

    String toString(){
        return firstName + ' ' + lastName
    }

    String fullAddress() {
        def addr = address1
        if (address2) {
            addr += ", " + address2
        }

        if (city) {
            addr += ", " + city
        }
        if (state) {
            addr += ", " + state
        }
        if (zipCode) {
            addr += "  " + zipCode
        }
    }

    String fullName() {
        def names = [ firstName, lastName ].findAll {
            it != null
        }

        return names?.join(' ') ?: ''
    }

    String allPhoneNumbers() {
        phoneNumbers?.join(", ")
    }

    String abbrevPhoneNumbers() {
        phoneNumbers?.collect {
            it.phoneNumber
        }.join(", ")
    }

}
