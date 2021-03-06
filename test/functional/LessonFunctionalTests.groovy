import org.bworks.bworksdb.util.TestKeys
import org.bworks.bworksdb.Course

// Note: BootStrap adds methods to FunctionalTestCase

class LessonFunctionalTests extends functionaltestplugin.FunctionalTestCase {

    def testDataService

    void gotoLessonShow() {
        loginAs('bob', 'bobbobbob0')
        click('Courses')
        click(TestKeys.PROGRAM_KIDS_AEC)
        click(TestKeys.LESSON_KIDS_AEC_INTRO)
    }

    void testLessonShow() {
        loginAs('bob', 'bobbobbob0')
        click('Courses')
        assertStatus 200
        click(TestKeys.PROGRAM_KIDS_AEC)
        assertStatus 200
        click(TestKeys.LESSON_KIDS_AEC_INTRO)
        assertStatus 200

        assertContentContains TestKeys.LESSON_KIDS_AEC_INTRO_DESCRIPTION.replace("\n", "<br />")
        
    }

    void testLessonNew() {
        loginAs('bob', 'bobbobbob0')
        click('Courses')
        assertStatus 200
        click(TestKeys.PROGRAM_KIDS_AEC)
        assertStatus 200
        click('New Lesson')
        assertStatus 200

        form('newLessonForm') {
            name = 'New Foo Lesson'
            // Give this lesson the same seq. as another lesson
            sequence = 123
            click('Save')
        }

        assertStatus 200
        assertContentContains 'created'
        assertContentContains 'New Foo Lesson'
        // Now, make sure our brand-new lesson belongs to the PROGRAM_KIDS_EAC
        click('Courses')
        assertStatus 200
        click(TestKeys.PROGRAM_KIDS_AEC)
        assertStatus 200
        assertContentContains 'New Foo Lesson'
    }

    // TODO just test the lesson re-sort page
    void testLessonResort() {
    }

    void testLessonList() {
        loginAs('bob', 'bobbobbob0')
        get('/lessons')
        assertStatus 200
        assertTitleContains 'Lessons'
        assertContentContains TestKeys.PROGRAM_KIDS_AEC
        assertContentContains TestKeys.PROGRAM_MENTORSHIP
        assertContentContains TestKeys.PROGRAM_ADULT_AEC

        assertContentContains TestKeys.LESSON_KIDS_AEC_INTRO

        // Break description into parts on newline, 'cause the HTML
        // formatting causes problems by putting in a <br />.
        def desc_parts = TestKeys.LESSON_KIDS_AEC_INTRO_DESCRIPTION.split("\n") 
        // Just make sure we see the pieces of the description.
        desc_parts.each {
            assertContentContains it
        }
        
    }

    // Change a lesson's name and its course
    // make sure changes are o.k.
    void testLessonEdit() {
        loginAs('bob', 'bobbobbob0')
        click('Courses')
        click(TestKeys.PROGRAM_KIDS_AEC)
        // we'll change the dummy lesson that's set up 
        // for this sole purpose.
        assertContentContains TestKeys.LESSON_KIDS_AEC_TEST_CHANGE
        click(TestKeys.LESSON_KIDS_AEC_TEST_CHANGE)
        click('Edit')
        assertStatus 200
        assertTitleContains 'Edit Lesson:'
        assertContentContains 'Edit Lesson:'
        // Should belong to kids Earn-A-Computer course
        assertContentContains TestKeys.PROGRAM_KIDS_AEC
        form('editLessonForm') {
            name = 'This is a Lesson in Politics'
            description = 'You ain\'t seen nothin\' yet'
            // Select Adult program for this lesson
            // TODO: See if we can select course by name, like the
            // user would.
            def adultEntry = byXPath("//option[. ='${TestKeys.PROGRAM_ADULT_AEC}']")
            assertNotNull adultEntry
            assertEquals 'com.gargoylesoftware.htmlunit.html.HtmlOption', adultEntry.class.name

            selects['course.id'].select adultEntry.getValueAttribute()
            sequence = 12345
            click ('Update')
        }

        assertStatus 200
        assertContentContains TestKeys.PROGRAM_ADULT_AEC
        assertContentContains 'This is a Lesson in Politics'
        assertContentContains 'You ain\'t seen nothin\' yet'
    }




}
