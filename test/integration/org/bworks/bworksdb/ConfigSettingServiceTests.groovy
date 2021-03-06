package org.bworks.bworksdb

import grails.test.*

class ConfigSettingServiceTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    def configSettingService
    def userService

    void testBasicConfigSetting() {

        // pretend like nobody is logged in
        userService.metaClass.loggedInUser = {
            null
        }

        def defaultSetting = new ConfigSetting(configKey:'foo', value:'Default', isDefault:true)
        assert defaultSetting.validate()
        defaultSetting.save()
        def nonDefaultSetting = new ConfigSetting(configKey:'foo', value:'NonDefault', isDefault:false)
        assert nonDefaultSetting.save()

        def setting = configSettingService.getSetting('foo')
        assert setting.value == 'NonDefault'

        // Now, zap the non-default setting and ensure that we get the default value.
        nonDefaultSetting.delete()
        setting = configSettingService.getSetting('foo')
        assert setting.value == 'Default'



    }
}
