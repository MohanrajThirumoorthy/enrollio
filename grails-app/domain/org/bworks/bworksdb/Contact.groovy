package org.bworks.bworksdb

class Contact {

    String firstName
    String lastName
    String address1
    String address2
    String state
    String zipCode
    String emailAddress
    static hasMany = [students:Student, phoneNumbers:PhoneNumber]
    
    static constraints = {
    }
    String toString(){
        return lastName + ',' + firstName
    }
}
