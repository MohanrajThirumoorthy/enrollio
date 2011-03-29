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

    void testRegularUserEditsContact() {
        gotoSomeContactShow() 
        def editContactLink = byName('editContactLink')
        assertNotNull(editContactLink)
        editContactLink.click()
        assertTitleContains('Edit Contact')
        assertStatus 200
        shouldFail() { assertContentContains('Frodo') }
        shouldFail() { assertContentContains('Bung Street') }

        form('editContactForm') {
            firstName = "Frodo"
            // Don't change last name -- other tests depend on it :o(
            // lastName = "Baggins"
            address1 = "Bung Street"
            click('Update')
        }

        assertStatus 200
        assertTitleContains "Contact"
        assertTitleContains "Frodo"
        assertTitleContains TestKeys.CONTACT1_LAST_NAME
        assertContentContains "Frodo"
        assertContentContains "Bung Street"
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
            studentLink = studentLink[0]
        }
        assertNotNull studentLink
        studentLink.click()

        assertStatus 200
        assertTitleContains 'Edit Student'
    }
}
