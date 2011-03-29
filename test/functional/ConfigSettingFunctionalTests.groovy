import org.bworks.bworksdb.util.TestKeys
class ConfigSettingFunctionalTests extends functionaltestplugin.FunctionalTestCase {

    def testDataService

    void testShowSettingPage() {
        loginAs("admin", "admin0")
        click('Admin')
        click('Settings')
        def settingLink = byName('settingLink_1')
        assertNotNull settingLink
        settingLink.click()
        assertStatus 200
        assertTitleContains "Setting: "
        assertContentContains "Setting:"

    }
    
    void testEditSettingPage() {
        loginAs("admin", "admin0")
        click("Admin")
        click('Settings')
        def settingLink = byName('settingLink_1')
        assertNotNull settingLink
        settingLink.click()
        assertStatus 200
        def editLink = byName('editSettingLink')
        assertNotNull editLink
        editLink.click()
        assertStatus 200

        form('editSettingForm') {
            description = "This is a new description, meow"
            value = "This is the new value"
            configKey = "Whole New Config Key"
            isDefault = false
            click('Update')
        }

        assertStatus 200
        assertTitleContains "Setting: Whole New Config Key"
        assertContentContains "This is a new description, meow"
        assertContentContains "This is the new value"
        assertContentContains "Whole New Config Key"
    }

 
}
