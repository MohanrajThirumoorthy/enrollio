import org.bworks.bworksdb.util.TestKeys
class AdminFunctionalTests extends functionaltestplugin.FunctionalTestCase {

    // AdminFunctionalTests are primarily used to test admin's capabilities on
    // the admin page
    // For security tests, use SecurityFiltersFunctionalTests.
    def testDataService

    void loginAdmin() {
        get('/login')
        form('loginForm') {
            username = 'admin'
            password = 'admin0'
            click "Sign in"
        }
    }

    // The settings list test could be refactored
    // later to a SettingsFunctionalTests.groovy file
    void testSettingsPage() {
        loginAs("admin", "admin0")
        click('Admin')
        click('Settings')
        assertStatus 200

        assertTitleContains 'Settings'
        assertContentContains 'Settings'
    }

}
