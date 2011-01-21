package org.bworks.bworksdb

import org.bworks.bworksdb.auth.*
import org.apache.shiro.crypto.hash.Sha1Hash
import org.bworks.bworksdb.util.TestKeys
import org.codehaus.groovy.grails.commons.*



class TestDataService {

    boolean transactional = true

    def courseService
    def classSessionService
    def config = ConfigurationHolder.config
    def shiroSecurityService

    // we don't want random data for integration tests
    def loadIntegrationTestData() {
        // get courses
        loadDefaultCourses()
        def adultCourse      = Course.findByName(TestKeys.PROGRAM_ADULT_AEC)
        def mentorshipCourse = Course.findByName(TestKeys.PROGRAM_MENTORSHIP)
        def childrensCourse  = Course.findByName(TestKeys.PROGRAM_KIDS_AEC)
                
        // build contact, student
        def contact = new Contact(firstName:TestKeys.CONTACT1_FIRST_NAME,
                            lastName:TestKeys.CONTACT1_LAST_NAME,
                            address1:'add1',
                            address2:'add2',
                            city:'Saint Louis',
                            state:'MO',
                            zipCode:'63043',
                            emailAddress:TestKeys.CONTACT_EMAIL).save()

        def student = new Student(lastName:TestKeys.STUDENT, contact:contact)
        def student2 = new Student(lastName:TestKeys.STUDENT2, contact:contact)
        def student3 = new Student(lastName:TestKeys.EDIT_STUDENT_TEST_NAME, contact:contact)

        contact.addToStudents(student)
        contact.addToStudents(student2)
        contact.addToStudents(student3)
        contact.save(flush:true)

        // interests
        addInterest(student, adultCourse , true)
        addInterest(student3, adultCourse , true)
        addInterest(student, childrensCourse, false)
        addInterest(student2, childrensCourse, true)

        loadDummyRegularUser()

        // load dummy class sessions for now -- we should
        // create more predictable test data for integration tests
        loadDummyClassSession(mentorshipCourse, 
                              TestKeys.SESSION_MENTORSHIP_DATE,
                              TestKeys.SESSION_MENTORSHIP_NAME)

        def childrensSession = loadDummyClassSession(childrensCourse, 
                              TestKeys.SESSION_KIDS_DATE,
                              TestKeys.SESSION_KIDS_NAME)
        enrollDummyStudent(student2, childrensSession)

        def adultClassSession = 
            loadDummyClassSession(adultCourse, 
                                  TestKeys.SESSION_ADULT_DATE,
                                  TestKeys.SESSION_ADULT_NAME)
        enrollDummyStudent(student, adultClassSession)

        enrollDummyStudent(student3, adultClassSession)
    }

    def enrollDummyStudent(student, classSession) {
        if (classSession.enrollments?.find { it.student.id == student.id }) {
            return
        }

        classSessionService.enrollStudent(student, classSession)
    }

    def loadDummyRegularUser() {

        // Administrator user and role.
        def userRole = ShiroRole.findByName("User")
        def user_password = 'bobbobbob0'
        def user = new ShiroUser(
            username: TestKeys.USER_BOB_USERNAME,
            firstName : TestKeys.USER_BOB_FIRSTNAME,
            lastName : TestKeys.USER_BOB_LASTNAME,
            password : user_password,
            passwordConfirm : user_password,
            passwordHash: shiroSecurityService.encodePassword(user_password)
        )
        if (!user.validate()) {
            log.error "User didn't validate!"
            log.error user.errors.allErrors
        }
        else {
            user.save()
            new ShiroUserRoleRel(user: user, role: userRole).save()
        }

    }

    def addInterest(student, course, isActive) {
        // add interest to course and student
        def note = new Note(text:TestKeys.NOTE).save()
        def interest = new Interest(active:isActive, student:student, course:course, note:note).save()        
        course.addToInterests(interest)
        student.addToInterests(interest)        

        student.save(flush:true)
        course.save(flush:true)
    }
    
    // Git some test data in these here parts
    def loadDevData(numContacts = 100) {
        loadDefaultCourses()
        loadDummyRegularUser()
 
        numContacts.times {
            loadDummyContactAndStudents()
        }
        loadAllDummyClassSessions()
        loadDummyUsers()
        loadDefaultConfigSettings()
    } 

    // General method to load awesome dummy class sessions
    def loadAllDummyClassSessions(moreSessions = 0) {
        def adultCourse      = Course.findByName(TestKeys.PROGRAM_ADULT_AEC)
        def mentorshipCourse = Course.findByName(TestKeys.PROGRAM_MENTORSHIP)
        def childrensCourse  = Course.findByName(TestKeys.PROGRAM_KIDS_AEC)
                
        // load dummy class sessions for now -- we should
        // create more predictable test data for integration tests
        loadDummyClassSession(mentorshipCourse, 
                              TestKeys.SESSION_MENTORSHIP_DATE,
                              TestKeys.SESSION_MENTORSHIP_NAME)

        loadDummyClassSession(childrensCourse, 
                              TestKeys.SESSION_KIDS_DATE,
                              TestKeys.SESSION_KIDS_NAME)

        loadDummyClassSession(adultCourse, 
                              TestKeys.SESSION_ADULT_DATE,
                              TestKeys.SESSION_ADULT_NAME)

        moreSessions.times {
            def d = new Date() + it
            loadDummyClassSession(mentorshipCourse, 
                                    d,
                                  TestKeys.SESSION_MENTORSHIP_NAME + d)

        }

    }

    def loadDummyClassSession(course, startDate, sessionName) {
        def classSession = 
            new ClassSession(name:sessionName,
                           course:course,
                           startDate: startDate).save()

        def nextLessonDates = 
            courseService.nextAvailableLessonDates(course, startDate)

        nextLessonDates.each { lessonDate ->
            classSession.addToLessonDates(lessonDate)
        }

        classSession.save()

        return classSession

   }

    def loadDummyUsers(numUsers = 3) {
        numUsers.times {
            def userRole = ShiroRole.findByName("User")
            def lastName = randomLastName()
            def firstName = randomFirstName()
            def userName = firstName.substring(0,1) + lastName 
            
            def password = "${firstName}0"
            if (password.length() != 5) { password = "${firstName}${firstName}0" }
            
            def dummyUser = new ShiroUser(username: userName,
                    firstName : firstName,
                    lastName : lastName,
                    password : password,
                    passwordConfirm : password,
                    passwordHash: shiroSecurityService.encodePassword(password)
            )
            if (!dummyUser.validate()) {
                log.error "User didn't validate!"
                log.error dummyUser.errors.allErrors
            }
            else {
                dummyUser.save()
                new ShiroUserRoleRel(user: dummyUser, role: userRole).save()
            }
        }
    }

    def loadDefaultConfigSettings() {

        def defaultSettings = [
            [ 'name'   : ConfigSetting.DEFAULT_STATE,
              'value'  : 'MO',
              'desc'   : 'What it says'],

            [ 'name'   : ConfigSetting.DEFAULT_CITY,
              'value'  : 'St. Louis',
              'desc'   : 'What it says'],

            [ 'name'   : ConfigSetting.DEFAULT_AREA_CODE,
              'value'  : '314',
              'desc'   : 'What it says'],

            [ 'name'   : ConfigSetting.MASCOT_ICON,
              'value'  : config.grails.serverURL + '/images/mascot.png',
              'desc'   : 'Enrollio Mascot Icon Used on every page'
            ]
        ]

        defaultSettings.each { setting ->
            // if this setting hasn't been defined, load it.
            if (! ConfigSetting.findByConfigKeyAndIsDefault(setting['name'], true)) {

                def cs = new ConfigSetting(
                                  configKey:setting['name'],
                                  value : setting['value'],
                                  description : setting['desc'],
                                  isDefault : true)
                if (!cs.validate()) {
                    cs.errors.allErrors.each {
                        log.error("Error initializing settings: " + it)
                    }
                }
                else {
                    cs.save()
                }
            }
        }
    }

    def loadDefaultCourses() {
        def p0 = new Course(description:"Byteworks Children's Earn-A-Computer Course",
                              name:TestKeys.PROGRAM_KIDS_AEC).save()

        // Define sample lessons.  Use a hard-coded description for
        // the test Earn-A-Computer lesson.
        def eacLessons = [ 
           [ name: TestKeys.LESSON_KIDS_AEC_INTRO, desc: TestKeys.LESSON_KIDS_AEC_INTRO_DESCRIPTION],
           [ name: 'Scratch Programming' ], 
           [ name: TestKeys.LESSON_KIDS_AEC_TEST_CHANGE, desc: TestKeys.LESSON_KIDS_AEC_TEST_CHANGE_DESCRIPTION],
           [ name: 'Presentations' ],
           [ name: 'Email and WWW' ],
           [ name: 'Graduation' ]
        ]

        eacLessons.eachWithIndex { it, i ->
            if (!it.desc) { it.desc = it.name + "\n\nA description of " + it.name }
            p0.addToLessons(new Lesson(description:it.desc,
                                       name:it.name,
                                       sequence:courseService.nextAvailSequence(p0)))
        }
            
        loadAdultCourse()
        loadBikeCourse()
        
        new Course(description:"Byteworks Mentorship Course", name:TestKeys.PROGRAM_MENTORSHIP).save()
 
        def s0 = new ConfigSetting(configKey:ConfigSetting.DEFAULT_COURSE,
                                   value:1,
                                   isDefault: true,
                                   description:'When entering Students, this course will be the default course they\'re interested in').save()
    }

    def loadBikeCourse() {
        def bikeCrs = new Course(description:"Bicycleworks Earn-A-Bike Course",
        name:TestKeys.PROGRAM_EARN_A_BIKE).save()

        def bikeLessons = [ 
           [ name: TestKeys.LESSON_BIKE_INTRO, 
             desc: TestKeys.LESSON_BIKE_INTRO_DESCRIPTION],
           [ name: 'Bicycle Safety' ], 
           [ name: 'Transmission Repair' ], 
           [ name: 'Brakes and Reflectors' ],
           [ name: 'Cross-country Bicycling' ],
           [ name: 'Graduation' ]
        ]
        bikeLessons.eachWithIndex { it, i ->
            if (!it.desc) { it.desc = it.name + "\n\nA description of " + it.name }
            bikeCrs.addToLessons(new Lesson(description:it.desc,
                                       name:it.name,
                                       sequence:courseService.nextAvailSequence(bikeCrs)))
        }
    }

    def loadAdultCourse() {
        def adultCrs = new Course(description:"Byteworks Adult Earn-A-Computer Course", 
                    name:TestKeys.PROGRAM_ADULT_AEC).save()
        def adultLessons = [ 
           [ name: TestKeys.LESSON_KIDS_AEC_INTRO, desc: TestKeys.LESSON_KIDS_AEC_INTRO_DESCRIPTION],
           [ name: 'Word Processing' ], 
           [ name: 'Spreadsheets' ], 
           [ name: 'Presentations' ],
           [ name: 'Email and WWW' ],
           [ name: 'Graduation' ]
        ]
        adultLessons.eachWithIndex { it, i ->
            if (!it.desc) { it.desc = it.name + "\n\nA description of " + it.name }
            adultCrs.addToLessons(new Lesson(description:it.desc,
                                       name:it.name,
                                       sequence:courseService.nextAvailSequence(adultCrs)))
        }
    }

    def loadDummyContacts(numContacts = 100) {

        numContacts.times {
            loadDummyContactAndStudents()
        }
    }
 
    // Method used to create a dummy contact, student and an interest
    // in a course
    def loadDummyContactAndStudents() {
        def seed = new Random()
        def randAddress = seed.nextInt(1000) 
        def address2 = ''
 
        if (randAddress.mod(3) == 0) {
            address2 = 'Apt. A'
        }
        def zip = '63' + seed.nextInt(100).toString().padLeft(3, "0") + '-1234'
        def lastName = randomLastName()
        def firstName = randomFirstName()
        // Use an email address for 50% of the people
        def emailAddress = seed.nextInt(2) == 1 ? '' : "${firstName}.${lastName}@" + randomEmailServer() + ".com"
        def c0 = new Contact(firstName:firstName,
                            lastName:lastName,
                            address1:randAddress.toString() + ' ' + randomStreetName(),
                            address2:address2,
                            cannotReach: seed.nextInt(100) < 10,
                            city:'Saint Louis',
                            state:'MO',
                            zipCode:zip,
                            emailAddress:emailAddress).save()
 
        // add comments to test comment search indexing, as well as comment dates.
        c0.addComment(ShiroUser.findByUsername("admin"), "This guy knows " + randomLastName() + c0.lastName) 
        c0.comments.each {
            def randomDay = seed.nextInt(1000) 
            it.dateCreated = new Date() - randomDay
            if (randomDay.mod(6) == 0) {
                // nextInt must be positive, so remove chance of it being 0
                // This was an error found when upgrading to Grails 1.3.6
                it.lastUpdated = new Date() - seed.nextInt(randomDay + 1)
            }
            it.save()
        }

        def randPhone = seed.nextInt(10000) - 1
        randPhone = randPhone.toString().padLeft(4, "0")
        c0.addToPhoneNumbers(new PhoneNumber(label:'Home', 
                                             phoneNumber:"(314)-123-$randPhone"))
 
        randPhone = seed.nextInt(10000) - 1
        randPhone = randPhone.toString().padLeft(4, "0")
        c0.addToPhoneNumbers(new PhoneNumber(label:'Work', 
                                             phoneNumber:"(314)-444-${randPhone}"))
 
        def numStudents = seed.nextInt(3) + 1
        numStudents.times {
            def stud = new Student(lastName:lastName,
                                    firstName:randomFirstName())
 
            c0.addToStudents(stud)
            c0.save(flush:true)
           
            // Add a random amount of interests to random courses :-)
            def courses = Course.findAll().collect { it.id }
            def availProgs = courses.clone()
            // Get 0 .. numCourses -- some students might not have interests
            def numProgsForStudent = seed.nextInt(courses.size() + 1)
            numProgsForStudent.times {
                
                def randomProg = seed.nextInt(availProgs.size())
               
                def prog = availProgs.remove(randomProg)
                stud.addToInterests(new Interest(course:Course.get(prog), active:true))
            }
        }
 
    }
 
    def randomFirstName() {
        def seed = new Random()
        def names = ['Bob', 'Jane', 'Dooge', 'Patty', 'Charlie', 'Snoopy', 'Woodstock', 
                     'Schizoid', 'Nate', 'Dan', 'Mary', 'Adam', 'Chris', 'Theresa', 
                     'Snarf', 'Peter', 'Missie', 'Julie', 'Wong', 'Debbie']
        return names[seed.nextInt(names.size() - 1)]
    }
    
    def randomEmailServer() {
        def seed = new Random()
        def names = ['yahoo', 'aol', 'gmail', 'grails', 'fiddlesticks']
        return names[seed.nextInt(names.size() - 1)]
    }
 
    def randomLastName() {
        def seed = new Random()
        def names = ['Neff', 'James', 'Jones', 'Ryholight', 'Klein', 'Jackson',
                     'Birdcage', 'Lionheart', 'Braveheart', 'Gibson', 'Snippet',
                     'Black', 'Caldwell', 'Spacely', 'Jetson', 'Flintstone', 'Fudd',
                     'Zapata', 'Wolfenstein', 'Davis', 'Washington', 'Jefferson', 'Madison',
                     'Pujols', 'La Russa', 'Dempster', 'Ryan', 'Ramirez', 'Gonzalez',
                     'Manson', 'Dahmer', 'Link', 'Stephanopolis', 'Rather', 'Walters',
                     'Klez', 'Klockenhammer', 'Gosling', 'Torvalds', 'Stallman']
        return names[seed.nextInt(names.size() - 1)]
    }
 
    def randomStreetName() {
        def seed = new Random()
        def names = ['Neff', 'James', 'Jones', 'Ryholight', 'Klein', 'Jackson', 'Main',
                     'Oklahoma', 'Virginia', 'Royal', 'Arsenal Boulevard', 'Zipenstein', 'McCausland Avenue']
        return names[seed.nextInt(names.size() - 1)]
    }

    // Utility method to zap data loaded by
    // loadIntegrationTestData()
    def deleteIntegrationTestData() {
        // student stuff
        Enrollment.list()*.delete(flush:true)
        Student.list()*.delete(flush:true)
        LessonDate.list()*.delete(flush:true)
        ClassSession.list()*.delete(flush:true)
        // ConfigSetting.groovy
        Contact.list()*.delete(flush:true)
        // Interest.groovy
        Lesson.list()*.delete(flush:true)
        // Note.groovy
        // PhoneNumber.groovy
        Course.list()*.delete(flush:true)
        // Attendance.list()*.delete(flush:true)
        def u = ShiroUser.findByUsername('bob')
        ShiroUserRoleRel.findByUser(u).delete()
        u.delete(flush:true)
    }

    // utility method to simplify student/contact setup
    // returns a list with contact, student
    // You can specify > 1 courseName if you want to add interests to mult. courses.
    // If contact/student with contactLastName, studentFirstName already exist, they are
    // NOT re-created.
    def setupContactAndStudentWithCourse(contactLastName, 
                                         studentFirstName, 
                                         String... courseNames) {
        def retVals = []
        def c = Contact.findByLastName(contactLastName)
        if (!c) {
            c = new Contact(lastName:contactLastName, firstName:'Fuzzball').save()
        }

        retVals.add(c)

        def s = Student.findByLastNameAndFirstName(contactLastName, studentFirstName)
        if (!s) {
            s = new Student(firstName:studentFirstName, lastName:contactLastName)
        } 

        retVals.add(s)

        c.addToStudents(s).save()

        courseNames.each {
            def course = Course.findByName(it)
            if (! course) {
                course = new Course(name:it, description:it).save()
                retVals.add(course)
            }

            def i = new Interest(course:course, student:s, active:true)
            s.addToInterests(i).save()
            course.addToInterests(i).save()
        }

        return retVals
    }

    // utility method to set up a class session
    // in a specified course
    // a lesson is added, and a lesson date is added
    def setupFullClassSession(course) {
        def lesson = new Lesson(sequence:1, name:"Foo Lesson", course:course, description: "Foo lesson")
        assert lesson.validate()
        lesson.save()

        course.addToLessons(lesson)
        def classSession = new ClassSession(name:"Foo Session",
                                      course:course,
                                      startDate: new Date()).save()
        course.addToClassSessions(classSession).save()
        def nextLessonDates = 
                courseService.nextAvailableLessonDates(course, classSession.startDate)
        println "next lesson dates " + nextLessonDates

        nextLessonDates.each { lessonDate ->
            classSession.addToLessonDates(lessonDate)
        }

        if (!classSession.validate()) {
            classSession.errors.allErrors.each {
            println it
            }
        }
        classSession.save()

        return classSession

    }
}
