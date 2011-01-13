package org.bworks.bworksdb

class HelpController {
    
    static navigation = [
        group:'help',
        action:'index',
        title:'Help',
        order:200
    ]

    def index = { redirect(action:'about',params:params) }

    def about = { }

    def whatsnew = { }

    def thanks = { }
}
