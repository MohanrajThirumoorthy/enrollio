package org.bworks.bworksdb
import grails.test.*

class NumberSuffixTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testBasic() {
        def numberSuffix = new NumberSuffix()
        assertNotNull numberSuffix

        assertEquals '9th', numberSuffix.render(9)
        assertEquals '1st', numberSuffix.render(1)
        assertEquals '2008th', numberSuffix.render(2008)
        assertEquals '33rd', numberSuffix.render(33)
        assertEquals '122nd', numberSuffix.render(122)
        assertEquals '100th', numberSuffix.render(100)

    }
}
