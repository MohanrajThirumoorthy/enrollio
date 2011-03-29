import org.bworks.bworksdb.util.TestKeys
import org.bworks.bworksdb.Course
class LessonSortingFunctionalTests extends functionaltestplugin.FunctionalTestCase {

    def testDataService
    def sessionFactory

    // TODO: Should probably use hard-coded data
    // for the lesson names, and not fish it from the HTML pages
    void testNewLessonWithSort() {
        loginAs('bob', 'bobbobbob0')
        click('Courses')
        click('New Lesson')
        assertStatus 200

        def lessonNodes = byXPath("//*[starts-with(@name, 'lessonName_')]")
        // assertEquals 'Intro to Computers', lessonNodes[0].getTextContent().trim()

        def lessonNames = lessonNodes.collect {
            it.getTextContent().trim()
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

        // Make sure our lessons are reversed.
        def expectedLessons = lessonNames.reverse()
        expectedLessons.add(0, 'Re-sort Foo Lesson')

        def shownLessonNodes = byXPath("//a[starts-with(@name, 'lessonLink')]")
        def shownLessons = shownLessonNodes.collect {
            it.getTextContent().trim()
        }
        assertEquals expectedLessons, shownLessons

    }

    void testLessonSortPage() {
        loginAs('bob', 'bobbobbob0')
        click('Courses')
        click(TestKeys.PROGRAM_KIDS_AEC)
        click('Sort')
        assertStatus 200
        assertTitleContains 'Sort Lessons - Children'

        def lessonNodes = byXPath("//*[starts-with(@name, 'lessonName_')]")
        // assertEquals 'Intro to Computers', lessonNodes[0].getTextContent()

        def lessonNames = lessonNodes.collect {
            it.getTextContent().trim()
        }

        def lessonSequences = byXPath("//input[starts-with(@name, 'lessonId_')]")
        lessonSequences.each {
            it.setAttribute('value', '-' + it.getValueAttribute())    
        }

        // TODO: assert that we saved o.k.
        click('saveButton')

        assertContentContains "Lessons successfully sorted."

        // Make sure our lessons are reversed.
        def expectedLessons = lessonNames.reverse()

        def shownLessonNodes = byXPath("//a[starts-with(@name, 'lessonLink')]")
        def shownLessons = shownLessonNodes.collect {
            it.getTextContent().trim()
        }
        assertEquals expectedLessons, shownLessons

    }

}
