import org.bworks.bworksdb.util.TestKeys
class UserFunctionalTests extends functionaltestplugin.FunctionalTestCase {

    // AdminFunctionalTests are primarily used to test admin's capabilities on
    // the admin page
    // For security tests, use SecurityFiltersFunctionalTests.
    def testDataService

    void loginAdmin() {
        loginAs("admin", "admin0")
    }

    void gotoUsersPageAsAdmin() {
        loginAdmin()
        click('Admin')
        click('Users')
    }

    // The settings list test could be refactored
    // later to a SettingsFunctionalTests.groovy file
    void testListUsersPage() {
        gotoUsersPageAsAdmin()
        assertStatus 200

        assertTitleContains 'Users'
        assertContentContains 'bob'
        assertContentContains 'admin'
    }

    // The settings list test could be refactored
    // later to a SettingsFunctionalTests.groovy file
    void testEditUser() {
        gotoUsersPageAsAdmin()

        def bobLink = byName('editUserLink_bob')
        assertNotNull bobLink
        bobLink.click()
        assertTitleContains('Edit User: bob')
        assertContentContains(TestKeys.USER_BOB_LASTNAME)
        assertContentContains(TestKeys.USER_BOB_FIRSTNAME)
        assertContentContains(TestKeys.USER_BOB_USERNAME)
    }

    void testShowUserPage() {
        gotoUsersPageAsAdmin()

        def adminLink = byName('userLink_admin')
        assertNotNull adminLink
        adminLink.click()
        assertStatus 200

        assertTitleContains "Show User: admin"
        assertContentContains "Bert"
        assertContentContains "Adminbadboy"

    }

    // test the Edit User link on the Admin Menu
    // Should only show up when viewing a user
    // void testEditUserLinkOnAdminMenu() {
    //     loginAdmin()
    //     click('Admin')
    //     click('Users')
    //     assertStatus 200

    //     // Shouldn't see this link when viewing a LIST of users
    //     def bobLink = bXPath('//a[starts-with(@name, "editUserLink_")]')
    //     assertNull bobLink

    // }


    void testCreateUserPage() {
        gotoUsersPageAsAdmin()
        click('Create')
        assertStatus 200

        assertTitleContains 'Create User'

        form('newUserForm') {
            username = "bazooka"
            firstName = "Joe"
            lastName = "Banana"

            // password must be 5 char and contain digit!
            password = "superserial0"
            passwordConfirm = "superserial0"

            click('Save')
            
        }

        assertStatus 200
        assertTitleContains "User: bazooka"
        assertContentContains "Banana"
        assertContentContains "Joe"

        // No password should be in the show page.
        shouldFail() {
            assertContentContains "superserial"
        }

    }
}
