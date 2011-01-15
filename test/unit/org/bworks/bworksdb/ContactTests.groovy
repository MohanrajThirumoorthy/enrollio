package org.bworks.bworksdb
import grails.test.*

class ContactTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testContactFirstName() {
        mockDomain(Contact)
        def c = new Contact()
        assertFalse c.validate()
        assertEquals 'nullable', c.errors['firstName']
        assertEquals 'nullable', c.errors['lastName']

        def d = new Contact(lastName:"", firstName:"")
        assertFalse d.validate()
        assertEquals 'blank', d.errors['lastName']


    }
}
