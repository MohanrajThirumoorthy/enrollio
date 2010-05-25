package org.bworks.bworksdb

class ConfigSettingService {

    boolean transactional = true

    def userService

    def getSetting(key) {
        def curUser = userService.loggedInUser()
        def setting
        if (curUser) {
            setting = curUser.userSettings.find {
                it.configKey == key
            }
            if (setting) { return setting }
        }

        setting = ConfigSetting.findByConfigKeyAndIsDefault(key, false)
        if (!setting) {
            setting = ConfigSetting.findByConfigKeyAndIsDefault(key, true)
        }
        return setting
    }

    def setSetting(key, value, description = '') {
        def setting = ConfigSetting.findByConfigKey(key)
        if (!setting) {
            setting = new ConfigSetting()
        }

        setting.configKey = key
        setting.value = value
        setting.description = description
        setting.isDefault = false

        if (!setting.validate()) {
            return null
        }
        setting.save()
        return setting
    }

    // create new UserSetting, unless useSystemSetting is true.
    // zap User Setting if useSystemSetting = true
    def setUserSetting(key, value) {
        def curUser = userService.loggedInUser()
        def setting
        if (curUser) {
            setting = curUser.userSettings.find {
                it.configKey == key
            }
        } else {
            // TODO Throw error
            return null
        }
        if (setting) {
            setting.value = value
            setting.save()
            
        }
        else {
            // create a new UserSetting
            setting = curUser.addToUserSettings(
                new UserSetting(configKey:key, value:value).save());
        }
        curUser.save(flush:true)

        return setting
    }

    def userSettingsList() {
        def userSettings = [:]

        def crit = ConfigSetting.createCriteria()
        def results = crit.list() {
            projections {
                distinct('configKey')
            }
        }

        crit = UserSetting.createCriteria()
        crit.list() {
            projections {
                distinct('configKey')
            }
        }.each {
            results.add it
        }

        results.unique().each { configKey ->
            userSettings[configKey] = getSetting(configKey).toString()
        }

        return userSettings
    }

    def systemSettingsList() {
    }

}
