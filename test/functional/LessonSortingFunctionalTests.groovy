import org.bworks.bworksdb.util.TestKeys
import org.bworks.bworksdb.Program
class LessonSortingFunctionalTests extends functionaltestplugin.FunctionalTestCase {

    def testDataService
    def sessionFactory

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

    protected void setUp() {
        super.setUp()
        sessionFactory.currentSession.flush()
        sessionFactory.currentSession.clear()
        testDataService.loadIntegrationTestData()

    }

    // TODO just test the lesson re-sort page
    void testLessonResort() {
    }

    // TODO: Should probably use hard-coded data
    // for the lesson names, and not fish it from the HTML pages
    void testNewLessonWithResort() {
        loginAs('bob', 'bobbobbob0')
        click('Programs')
        click(TestKeys.PROGRAM_KIDS_AEC)
        click('New Lesson')
        assertStatus 200


        def lessonNodes = byXPath("//td[starts-with(@name, 'lessonName_')]")
        assertEquals 'Intro to Computers', lessonNodes[0].getTextContent()

        def lessonNames = lessonNodes.collect {
            it.getTextContent()
        }

        def lessonSequences = byXPath("//input[starts-with(@name, 'lessonId_')]")
        lessonSequences.each {
            it.setAttribute('value', '-' + it.getValueAttribute())    
        }

        form('newLessonForm') {
            name = 'Re-sort Foo Lesson'
            // Give this lesson the same seq. as another lesson
            sequence = 123
            click('Save')
        }

        // TODO: assert that we saved o.k.

        // Whew!  Now, click 'Lessons'
        click('Lessons')

        // Make sure our lessons are reversed.
        def expectedLessons = lessonNames.reverse()
        expectedLessons.add(0, 'Re-sort Foo Lesson')

        def shownLessonNodes = byXPath("//a[starts-with(@name, 'lessonLink')]")
        def shownLessons = shownLessonNodes.collect {
            it.getTextContent()
        }
        assertEquals expectedLessons, shownLessons

    }
}