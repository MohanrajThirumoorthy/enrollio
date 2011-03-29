import org.bworks.bworksdb.util.TestKeys

// Note: BootStrap adds methods to FunctionalTestCase

class ClassSessionFunctionalTests extends functionaltestplugin.FunctionalTestCase {

    // gotoClassSessionPage is a utility method
    // that, um, goes to a class session page
    void gotoClassSessionPage(courseName, sessionName) {
        loginAs('bob', 'bobbobbob0')
        click('Courses')
        click(courseName)
        assertStatus 200

        // select explicit session
        click(sessionName)
    }
    
    void gotoCertificatesPage(courseName, sessionName) {
        gotoClassSessionPage(courseName, sessionName)
        assertStatus(200)
        redirectEnabled = false
        def certificatesLink = byName('certificatesLink')
        assertNotNull certificatesLink
        certificatesLink.click()
        assertStatus 200
    }

    void testClassSessionShow() {
        gotoClassSessionPage(TestKeys.PROGRAM_ADULT_AEC, TestKeys.SESSION_ADULT_NAME)

        // Check awesome date format
        assertContentContains TestKeys.SESSION_ADULT_DATE_FORMATTED
        // Ensure that STUDENT is enrolled in this course.
        assertContentContains TestKeys.STUDENT
    }

    void testAttendancePage() {
        gotoClassSessionPage(TestKeys.PROGRAM_KIDS_AEC, TestKeys.SESSION_KIDS_NAME)
        def link = byName('attendanceLink')
        link.click()
        assertStatus 200
        assertTitleContains 'Attendance'
        assertContentContains 'Attendance'
        assertContentContains 'Present'
        assertContentContains 'Absent'
        assertContentContains 'Late'
        
    }

    // Test that Grad. Certs come out OK
    void testGradCerts() {
        gotoCertificatesPage(TestKeys.PROGRAM_KIDS_AEC, TestKeys.SESSION_KIDS_NAME)
        assertStatus 200
        assertContentContains "Certificates"

        // Make sure enrolled student is shown
        assertContentContains(TestKeys.STUDENT2)
        
        redirectEnabled = false

        form("gradCertsForm") {
            // click one of the checkboxes (really, it only checks one of the checkboxes)
            // but that's enough.
            studentIds = true
            def saveButton = byId('printGradCertsButton')
            // Click on grad list, and expect a PDF
            // NOTE: For some reason (probably javascript), the tests
            // will *not* follow the redirect, so you have to manually call followRedirect()
            saveButton.click()
        }

        assertStatus 302
        followRedirect()
        assertStatus 200
        assertContentType "application/pdf"
    }

    // Test that Grad. Certs come out OK
    void testGradCertsDontCrashIfNoStudentsSelected() {
        gotoCertificatesPage(TestKeys.PROGRAM_KIDS_AEC, TestKeys.SESSION_KIDS_NAME)
        assertStatus 200
        assertContentContains "Certificates"
        // TODO: Get functional-test plugin to handle alerts from Javascript
        // http://htmlunit.sourceforge.net/javascript-howto.html
        // shouldFail {
            // assertContentContains "at least one student"
        // }
        // shouldFail {
            // assertContentContains "Homer"
        // }

        // Make sure enrolled student is shown
        assertContentContains(TestKeys.STUDENT2)
        
        def checkBoxen = []
        def unModifiableCheckboxes = byName('studentIds')
        if (unModifiableCheckboxes instanceof com.gargoylesoftware.htmlunit.html.HtmlElement) {
            checkBoxen = [ unModifiableCheckboxes ]
        }
        else {
            // create a modifiable list of checkboxes.
            checkBoxen = unModifiableCheckboxes.collect { it }
        }

        checkBoxen.each {
            assertEquals 'com.gargoylesoftware.htmlunit.html.HtmlCheckBoxInput', it.class.name
            it.setChecked(false)
        }

        form("gradCertsForm") {
            def saveButton = byId('printGradCertsButton')
            // Click on grad list, and expect a PDF
            // NOTE: For some reason (probably javascript), the tests
            // will *not* follow the redirect, so you have to manually call followRedirect()
            saveButton.click()
        }

        // Javascript should stop the form from being submitted,
        // so we'll be on the same page.
        assertStatus 200
        assertContentContains "Certificates"
        // assertContentContains "at least one student"
        // assertContentContains "Homer"
    }

    // Test Attendance Sheet comes out OK
    void testPrintableAttendanceSheet() {
        gotoClassSessionPage(TestKeys.PROGRAM_KIDS_AEC, TestKeys.SESSION_KIDS_NAME)
        assertStatus 200
        // Click on sheet, and expect a PDF
        // NOTE: For some reason (probably javascript), the tests
        // will *not* follow the redirect, so you have to manually call followRedirect()
        def attendanceSheetLink = byName('attendanceSheetLink')
        assertNotNull attendanceSheetLink
        attendanceSheetLink.click()
        assertStatus 200
        def expectedfileName = "attendance_" + TestKeys.SESSION_KIDS_NAME.substring(0,4) +
                               TestKeys.SESSION_KIDS_DATE.format('yyyy_MM_dd') + '.pdf'
        assertHeaderContains('Content-Disposition', "filename=${expectedfileName}")
    }

    void testNewClassSession() {
        loginAs('bob', 'bobbobbob0')
        click("Courses")
        // Go to Children's prog, and ensure that we
        // see the start date of the first session in our awesome format
        click(TestKeys.PROGRAM_KIDS_AEC)
        click('New Session')
        assertStatus 200
        assertTitleContains('New Class Session')
        form('newClassSessionForm') {
            name = 'Foo Foo Zip Zap Class Session'
            startDate = '1/1/2010'
            click "Save"
        }
        assertStatus 200
        assertTitleContains('Foo Foo Zip Zap')
        assertContentContains('Foo Foo Zip Zap Class Session')
    }
}
