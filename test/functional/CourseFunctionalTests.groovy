import org.bworks.bworksdb.util.TestKeys
class CourseFunctionalTests extends functionaltestplugin.FunctionalTestCase {
    // TODO loginAs should be refactored into a
    // common method -- it's also used in SecurityFiltersFunctionalTests
    void loginAs(userName, pass) {
        get('/login')
        form('loginForm') {
            username = userName
            password = pass
            click "login"
        }
    }

    // method: gotoCourseShow
    //         utility method to do all the clicky stuff
    //         to get to a course/show page
    void gotoCourseShow() {
        loginAs('bob', 'bobbobbob0')
        click("Courses")
        // Go to Children's prog, and ensure that we
        // see the start date of the first session in our awesome format
        click(TestKeys.PROGRAM_KIDS_AEC)

    }

    void gotoAdultEACCourse() {
        loginAs('bob', 'bobbobbob0')
        click("Courses")
        // Go to Children's prog, and ensure that we
        // see the start date of the first session in our awesome format
        click(TestKeys.PROGRAM_ADULT_AEC)
        

    }
    // ensure there's two links on course/show that create a new
    // lesson for that course.
    // Ensure that the default course of the new Lesson
    // is same course whose 'New Lesson' link we clicked.
    void testNewLessonForCourse() {
        gotoAdultEACCourse()
        assertStatus 200
        def addLessonLinks = byName('newLessonLink')
        if (addLessonLinks instanceof com.gargoylesoftware.htmlunit.html.HtmlElement) {
            addLessonLinks = [ addLessonLinks ]
        }

        addLessonLinks.each {
            it.click()
            assertStatus 200
            // Make sure the Adult EAC prog is the def. prog
            def p = byXPath('//select[@id="course.id"]/option[@selected="selected"]')
            assertEquals TestKeys.PROGRAM_ADULT_AEC, p.getText()
        }
    }

    void testGotoCourseLessonShow() {
        gotoCourseShow()
        click('Lessons')
        click(TestKeys.LESSON_KIDS_AEC_INTRO)
        assertStatus 200
        assertTitleContains('Show Lesson')
    }

    void testGotoCourseLessonsList() {
        gotoCourseShow()
        assertContentContains(TestKeys.LESSON_KIDS_AEC_INTRO)
        click('Lessons')
        assertStatus 200
        assertContentContains(TestKeys.LESSON_KIDS_AEC_INTRO)
        assertContentContains(TestKeys.LESSON_KIDS_AEC_INTRO_DESCRIPTION)
    }

    void testCourseList() {
        loginAs('bob', 'bobbobbob0')
        click("Courses")
        assertStatus 200
        assertTitleContains("Courses")
        assertContentContains("Children's EAC")
    }

    void testCourseShow() {
        loginAs('bob', 'bobbobbob0')
        click("Courses")
        assertStatus 200
        click(TestKeys.PROGRAM_KIDS_AEC)
        assertContentContains TestKeys.SESSION_KIDS_DATE_FORMATTED

    }
    // Ensure that we can create a new Course
    void testCourseMenu() {
        loginAs('bob', 'bobbobbob0')
        click("Courses")
        assertStatus 200
        assertNotNull byName('courseMenu')

    }

    void testNewCourse() {
        loginAs('bob', 'bobbobbob0')
        click("Courses")
        assertStatus 200
        click("newCourseLink")
        assertStatus 200
        assertTitleContains("Create Course")
        form('newCourseForm') {
            name = "Ricky's Course"
            description = 'Only for Ricky (and maybe Bubbles)'
            click 'Save'
        }
        assert 200
        assertTitleContains "Course: Ricky's Course"
        assertContentContains "Only for Ricky (and maybe Bubbles)"
            
    }

    void testNewCourseFailed() {
        loginAs('bob', 'bobbobbob0')
        click("Courses")
        assertStatus 200
        click("newCourseLink")
        assertStatus 200
        assertTitleContains("Create Course")
        form('newCourseForm') {
            name = "Invalid Course"
            description = ''
            click 'Save'
        }
        assert 200
        assertTitleContains "Create Course"
        assertContentContains "description must have a value"

        // Now, fill in description, but not name
        form('newCourseForm') {
            name = ""
            description = "Another Invalid Course, this time there's no name"
            click 'Save'
        }
        assert 200
        assertTitleContains "Create Course"
        assertContentContains "name must have a value"
            
    }

    void testWaitingList() {
        loginAs('bob', 'bobbobbob0')
        click("Courses")
        assertStatus 200
        // find first a>href that starts with courseLink
        // -- it's a link to a Course.
        def progLink = byXPath("//a[starts-with(@name,'courseLink')]")
        assertNotNull progLink
        // if we get > 1 link back, we have to pick 1st one.
        progLink = progLink instanceof ArrayList ? progLink[0] : progLink
        // click the link to go to course/show
        progLink.click()
        assertStatus 200
        click('Waiting List')
        assertContentContains('Waiting List for')
    }

    void ztestPDFCallList() {
        // Click on call list, and expect a PDF
        // NOTE: For some reason (probably javascript), the tests
        // will *not* follow the redirect, so you have to manually call followRedirect()
        redirectEnabled = false
        callListLink.click()
        assertStatus 302
        followRedirect()
        assertStatus 200
        assertContentType "application/pdf"

    }

    void testCourseEdit() {
        gotoCourseShow()
        def editLink = byXPath("//a[starts-with(@name,'editCourseLink')]")
        assertNotNull editLink
        editLink.click()
        assertStatus 200
        assertTitleContains('Edit Course:')

        // Test an invalid URL
        get("/editCourse")
        assertStatus 404
        
    }

    void testCourseEditCancel() {
        gotoCourseShow()
        def editLink = byXPath("//a[starts-with(@name,'editCourseLink')]")
        assertNotNull editLink
        editLink.click()
        assertStatus 200

        def cancelLink = byName('cancelLink')
        assertNotNull cancelLink
        cancelLink.click()
        assertStatus 200
        assertTitleContains('Course:')

    }
    void testCourseBadEdit() {
        gotoCourseShow()
        def editLink = byXPath("//a[starts-with(@name,'editCourseLink')]")
        assertNotNull editLink
        editLink.click()
        assertStatus 200

        form('editCourseForm') {
            name = ""
            description = ""
        }

        def saveButton = byId('saveButton')
        assertNotNull saveButton
        saveButton.click()

        assertStatus 200
        assertTitleContains('Edit Course:')

    }
}
