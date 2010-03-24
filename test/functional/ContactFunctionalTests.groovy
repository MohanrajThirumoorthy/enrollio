import org.bworks.bworksdb.util.TestKeys

// Note: BootStrap adds methods to FunctionalTestCase

class ContactFunctionalTests extends functionaltestplugin.FunctionalTestCase {

    def testDataService

    def gotoSomeContactShow() {
        loginAs('bob', 'bobbobbob0')
        click("Students")
        def contactLink = byXPath('//a[starts-with(@name, "contactLink")]')

        if (contactLink instanceof ArrayList) {
            contactLink = contactLink.find {
                it.getTextContent() =~ TestKeys.CONTACT1_LAST_NAME
            }
        }
        assertNotNull contactLink
        contactLink.click()
        assertStatus 200
    }

    void testRegularUserGoesToContactShow() {
        gotoSomeContactShow()
        assertTitleContains('Contact:')
    }

    void testRegularUserGoesToContactEdit() {
        gotoSomeContactShow() 
        click("Edit Contact")
        assertTitleContains('Edit Contact')
        assertStatus 200
    }

    void testContactsShownOnStudentsPage() {
        gotoSomeContactShow()
        assertContentContains TestKeys.CONTACT1_LAST_NAME
    }

    void testStudentEditLinkFromContactPage() {
        gotoSomeContactShow()
        assertContentContains TestKeys.CONTACT1_LAST_NAME

        def studentLink = byXPath('//a[starts-with(@name, "editStudent")]')

        if (studentLink instanceof ArrayList) {
            studentLink = studentLink.find {
                it.getAttribute('title') =~ TestKeys.STUDENT
            }
        }
        assertNotNull studentLink
        studentLink.click()

        assertStatus 200
        assertTitleContains 'Edit Student'
        assertContentContains TestKeys.STUDENT
    }
}
