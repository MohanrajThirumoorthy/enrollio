class UrlMappings {
	static mappings = {

        // admin controller
        '/admin'(controller: 'admin', action: 'index')
        '/startMirroring'(controller: 'admin', action: 'startMirroring')
        '/stopMirroring'(controller: 'admin', action: 'stopMirroring')

        // auth controller
        '/login'(controller: 'auth', action: 'login')
        '/logout'(controller: 'auth', action: 'logout')
        '/unauthorized' (controller: 'auth', action: 'unauthorized')
        '/signin'(controller: 'auth', action: 'signIn')

        // classSession controller
        '/classSessions'(controller: 'classSession', action: 'list')
        "/classSession/$id"(controller: 'classSession', action: 'show')
        "/editClassSession/$id"(controller: 'classSession', action: 'edit')
        "/updateClassSession"(controller: 'classSession', action: 'update')
        '/createClassSession'(controller: 'classSession', action: 'create')
        '/saveClassSession'(controller: 'classSession', action: 'save')
        "/printGradCerts"(controller: 'classSession', action: 'printGradCerts')
        "/certificates/$id"(controller: 'classSession', action: 'certificates')
        "/printWelcomeLetter"(controller: 'classSession', action: 'printWelcomeLetter')
        "/graduation/$id"(controller: 'classSession', action: 'graduation')
        "/attendanceSheet/$id"(controller: 'classSession', action: 'attendanceSheet')
        "/enrollStudent"(controller: 'classSession', action: 'enrollStudent')
        "/attendance/$id"(controller: 'classSession', action: 'attendance')
        "/reserveContact"(controller: 'classSession', action: 'reserveContact')
        "/welcomeLetters/$id"(controller: 'classSession', action: 'welcomeLetters')
        "/quickCallList/$id"(controller: 'classSession', action: 'quickCallList')
        "/envelopes/$id"(controller: 'classSession', action: 'envelopes')

        // attendance controller
        "/updateStatus"(controller: 'attendance', action: 'updateStatus')

        // enrollment controller
        "/enrollmentStatus"(controller: 'enrollment', action: 'enrollmentStatus')
        // configSetting controller
        '/settings'(controller: 'configSetting', action: 'list')
        "/showSetting/$id"(controller: 'configSetting', action: 'show')
        "/editSetting/$id"(controller: 'configSetting', action: 'edit')
        "/updateSetting"(controller: 'configSetting', action: 'update')
        "/testData"(controller:'configSetting', action:'testDataRequest')
        "/generateTestSessions"(controller:'configSetting', action:'generateTestSessions')
        "/generateTestCourses"(controller:'configSetting', action:'generateTestCourses')
        "/generateTestContacts"(controller:'configSetting', action:'generateTestContacts')
        "/loadDataFromFile"(controller:'configSetting', action:'loadDataFromFile')
        "/loadDataRequest"(controller:'configSetting', action:'loadDataRequest')

        // userSetting controller
        '/userSettings'(controller: 'userSetting', action: 'list')
        "/editUserSetting"(controller: 'userSetting', action: 'edit')
        "/updateUserSetting"(controller: 'userSetting', action: 'update')

        // contact controller
        '/contact'(controller: 'contact', action: 'index')
        '/contacts'(controller: 'contact', action: 'list')
        "/contact/$id"(controller: 'contact', action: 'show')
        "/createContact"(controller: 'contact', action: 'create')
        "/saveStudent"(controller: 'contact', action: 'saveStudent')
        "/editContact/$id"(controller: 'contact', action: 'edit')
        "/updateContact"(controller: 'contact', action: 'update')
        "/addContactNote/$id"(controller:'contact', action: 'addNote')
        "/updateContactNote"(controller: 'contact', action: 'updateNote')

        // help controller
        "/"(controller:"help", action:'about')
        '/help'(controller: 'help', action: 'index')
        '/thanks'(controller: 'help', action: 'thanks')
        '/whatsnew'(controller: 'help', action: 'whatsnew')

        // home controller
        '/home'(controller: 'home', action: 'index')

        // interest controller
        "/updateInterest"(controller: 'interest', action: 'updateInterest')

        // lesson controller
        "/lesson/$id"(controller: 'lesson', action: 'show')
        '/createLesson'(controller: 'lesson', action: 'create')
        '/saveLesson'(controller: 'lesson', action: 'save')
        "/editLesson/$id"(controller: 'lesson', action: 'edit')
        "/updateLesson"(controller: 'lesson', action: 'update')
        "/lessons"(controller: 'lesson', action: 'list')

        // lessonDate controller
        "/lessonDate/$id"(controller: 'lessonDate', action: 'show')
        "/calendar"(controller: 'lessonDate', action: 'calendar')
        "/lessonDateData"(controller: 'lessonDate', action: 'lessonDateData')

        // jasper controller
        '/jasper/index'(controller:'jasper', action:'index')

        // course controller
        '/courses'(controller: 'course', action: 'list')
        "/printableCallList/$id"(controller: 'course', action: 'printableCallList')
        "/course/$id"(controller: 'course', action: 'show')
        '/createCourse'(controller: 'course', action: 'create')
        '/saveCourse'(controller: 'course', action: 'save')
        "/editCourse/$id"(controller: 'course', action: 'edit')
        "/manageCallList/$id"(controller: 'course', action: 'manageCallList')
        "/updateCourse"(controller: 'course', action: 'update')
        "/nextAvailableLessonDates"(controller: 'course', action: 'nextAvailableLessonDates')
        "/courseLessons/$id"(controller: 'course', action: 'lessons')
        "/sortLessons/$id"(controller: 'course', action: 'sortLessons')
        "/saveLessonSort"(controller: 'course', action: 'saveLessonSort')
        "/interestedStudents/$id"(controller: 'course', action: 'interestedStudents')

        // shiroUser controller
        '/createUser'(controller: 'shiroUser', action: 'create')
        '/users'(controller: 'shiroUser', action: 'list')
        "/editUser/$username"(controller: 'shiroUser', action: 'edit')
        "/deleteUser/$id"(controller: 'shiroUser', action: 'delete')
        "/showUser/$username"(controller: 'shiroUser', action: 'show')
        "/updateUser"(controller: 'shiroUser', action: 'update')
        "/saveUser"(controller: 'shiroUser', action: 'save')

        // student controller
        '/students'(controller: 'student', action: 'list')
        "/student/$id"(controller: 'student', action: 'show')
        "/editStudent/$id"(controller: 'student', action: 'edit')
        "/updateStudent"(controller: 'student', action: 'update')
        "/student/toggleStar"(controller: 'student', action: 'toggleStar')

        // Errors that were handled, but can't send any better place:
        "/oops"(controller:'error', action:'oops')

        // response codes
        "500"(view:'/error')
        "404"(controller:'error', action:'pageNotFound')
}
