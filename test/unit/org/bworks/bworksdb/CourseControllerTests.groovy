package org.bworks.bworksdb

import grails.test.*

class CourseControllerTests extends grails.test.ControllerUnitTestCase {
    
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testUpdate_NotFound() {
        mockDomain(Course, [new Course(name:'p1', id:33)] )
        mockParams.id = 99
        
        // test
        def model = controller.update()
        
        assertNotNull mockFlash.message 
        assertEquals controller.list, redirectArgs.action
    }

    void testUpdate_Green() {
        mockDomain(Course, [new Course(name:'p1', id:33)] )
        mockParams.id = 33
        mockParams.description = 'fake'
        
        // test
        def model = controller.update()
        
        assertEquals controller.show, redirectArgs.action
    }
    
    void testList_LessThanMax() {
        mockDomain(Course, [new Course(name:'p1'), new Course(name:'p2')] )
        mockParams.max = 3
        
        controller.metaClass.courseService = [ activeInterests : { return [ 'blurp' ] } ]
        def model = controller.list()
        
        assertEquals 2, model.courseInstanceList.size()
        assertEquals 2, model.courseInstanceTotal
    }

    void testList_MoreThanMax() {
        mockDomain(Course, [new Course(name:'p1'), new Course(name:'p2'), new Course(name:'p3')] )
        mockParams.max = 2
        
        controller.metaClass.courseService = [ activeInterests : { return [ 'blurp' ] } ]
        def model = controller.list()
        
        assertEquals 2, model.courseInstanceList.size()
        assertEquals 3, model.courseInstanceTotal
    }
    
    void testShow_Found() {
        mockDomain(Course, [new Course(id:88)] )
        mockParams.id = 88
        
        // Create mock courseService so test doesn't blow up.
        controller.metaClass.courseService = new Expando( activeInterests: { [ ] })

        def model = controller.show()
        
        assertEquals 88, model.courseInstance.id
    }
    
    void testShow_NotFound() {
        mockDomain(Course, [new Course(id:77)] )
        mockParams.id = 88
        
        // test
        def model = controller.show()
        
        assertNotNull mockFlash.message 
        assertEquals 'list', redirectArgs.action
    }
}
