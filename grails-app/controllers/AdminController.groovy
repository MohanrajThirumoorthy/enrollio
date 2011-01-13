import org.apache.shiro.SecurityUtils

class AdminController {


    def index = { }
    def searchableService

    static navigation = [
        group:'adminLinks',
        action:'index',
        title:'Admin',
        order:100,
        isVisible: { SecurityUtils.subject?.hasRole("Administrator") }
    ]
    

    def startMirroring = {
        searchableService.startMirroring()
        searchableService.reindex()
        flash.message = "Search engine is now mirroring, and re-indexed."
        render(view:'index')

    }

    def stopMirroring = {
        searchableService.stopMirroring()
        flash.message = "Search engine is no longer mirroring.  We suggest turning it back on a.s.a.p"
        render(view:'index')
    }

}
