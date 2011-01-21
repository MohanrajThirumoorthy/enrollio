package org.bworks.bworksdb

import org.bworks.bworksdb.util.TestKeys
import org.bworks.bworksdb.auth.*
import org.grails.comments.*
import org.codehaus.groovy.grails.commons.ApplicationHolder
import grails.util.*

class DataLoadingService {

    def searchableService
    boolean transactional = true

    // load data from hard-coded filenames
    def loadFromFiles() {

      def importDir = ApplicationHolder.application.parentContext.getResource("/WEB-INF/importData").getFile()

      def messages = []

      log.info("Stopping Searchable Service")
      searchableService.stopMirroring()

      def classFile = new File(importDir, 'Class.xml')
      if (classFile.exists()) {
          log.info("adding class session data from ${classFile.name}")
          def xml = classFile.getText()
          def result = loadClassSessions(xml)
          messages.add(result['messages'])
          log.info("Done adding student data from ${classFile.name}")
      }

      def contactFile = new File(importDir, 'Contact.xml')
      if (contactFile.exists()) {
          log.info("Begin adding contact data from ${contactFile.name}")
          def xml = contactFile.getText()
          def result = loadContacts(xml)
          messages.add(result['messages'])
          log.info("Done adding contact data from ${contactFile.name}")
      }

      def studentFile = new File(importDir, 'Student.xml')
      if (studentFile.exists()) {
          log.info("Begin adding student data from ${studentFile.name}")
          def xml = studentFile.getText()
          def result = loadStudents(xml)
          messages.add(result['messages'])
          log.info("Done adding student data from ${studentFile.name}")
          log.info("Reindexing")
          searchableService.reindex()
      }

      log.info("Reindexing searchable service")
      searchableService.reindex()
      return [ 'messages' : messages.flatten() ]

    }

    def loadClassSessions(xmlString, course = null) {
        def results = [ messages : []]
        def importedSessions = 0
        if (!course) {
            course = getDefaultCourse()
        }
        def xml = new XmlSlurper().parseText(xmlString)
		def sessions = xml.children()
        sessions.each { xmlSess ->
            // Take first class date and put it into the name of the session
            // Date format looks like this:  
            //     <Class1Date>2006-03-11T00:00:00</Class1Date>
            def xmlStartDate = xmlSess.Class1Date.text().split('T')[0]
            def parsedDate
            try {
                parsedDate = Date.parse('yyyy-MM-dd', xmlStartDate)
                // if session don't have all 6 dates, then skip
                Date.parse('yyyy-MM-dd', xmlSess.Class6Date.text().split('T')[0])
            } catch (Exception e) {
                log.error("skipping session: ${xmlSess} because it doesn't have all 6 dates")
                return
            }

            def cs = new ClassSession(course:course, 
                name:xmlStartDate, 
                startDate: parsedDate)
            if (cs.validate() && cs.save()) {
                importedSessions = importedSessions + 1
                log.info("Imported class session ${cs.name} id: ${cs.id}")
                addCommentAboutId(cs, xmlSess.ClassID.text())
                // Now, load some awesome lesson dates for this session
                // from our import data.
                loadLessonDates(cs, xmlSess)
            }
            else {
                log.error("Couldn't import class session.  Errors are: ")
                cs.errors.allErrors.each {
                    log.error("Error: ${it}")
                }
            }
        }

        results.messages.add("${importedSessions} class sessions imported.")
        return results
    }

    // Load lesson dates from Class Session XML.
    // XML looks like this:
    // <Class>
    //     <Class1Date>2006-03-11T00:00:00</Class1Date>
    //     <Class2Date>2006-03-18T00:00:00</Class1Date>
    def loadLessonDates(cs, xmlSess) {
        def lessons = getDefaultCourse().lessons

        def eacLessons = [ 
           Lesson.findByName(TestKeys.LESSON_KIDS_AEC_INTRO),
           Lesson.findByName('Scratch Programming'),
           Lesson.findByName('Word Processing'),
           Lesson.findByName('Presentations'),
           Lesson.findByName('Email and WWW'),
           Lesson.findByName('Graduation')
        ]

        (1..6).each {
            def dt = xmlSess.getProperty("Class${it}Date")?.text().split("T")[0]

            // try to parse date, if not, then get the hell out
            def parsedDate
            try {
                parsedDate = Date.parse('yyyy-MM-dd', dt)
            } catch (Exception e) {
                // Get out if we don't have a valid date
                return
            }
            def lessonDate = new LessonDate(
                 lesson:eacLessons[it - 1],
                 lessonDate:parsedDate)
            cs.addToLessonDates(lessonDate)
            
        }
    }

    def loadStudents(xmlString) {
        def xml = new XmlSlurper().parseText(xmlString)
        def results = [messages:[]]
        def numImported = 0
        def numEnrollmentsImported = 0
        def numInterestsImported = 0

		def students = xml.children()
        students.each { xmlStu ->
            def lastName = 
                xmlStu.LastName.text() == "" ? "Unknown" : xmlStu.LastName.text()
            def stu = new Student(firstName : xmlStu.FirstName.text(),
                                  lastName  : lastName)

            stu.emailAddress = xmlStu.email.text()
            if(xmlStu.Grade.text()) {
                stu.grade = xmlStu.Grade.text().toInteger()
            }
            stu.gender = xmlStu.Gender.text()
            if (xmlStu.BirthDate.text()) {
                stu.birthDate = Date.parse("yyyy-MM-dd",xmlStu.BirthDate.text() )
            }
            
            def con = findContactByOldId(xmlStu.ParentID.text())
            if (!con) {
                // Create kludge contact.
                // Purpose is to get as much data as possible
                log.info("Creating contact for student: " +
                          "${stu.firstName} ${stu.lastName}, " +
                          "studentID: ${xmlStu.StudentID.text()}, " +
                          "parentID: ${xmlStu.ParentID.text()}")
                con = createContactForOrphan(stu, xmlStu.ParentID.text())
            }
            if(!con) {
                return
            }
            con.addToStudents(stu)

            if (stu.validate() && stu.save()) {
                if (xmlStu.Notes.text()) {
                    addComment(stu, xmlStu.Notes.text())
                }

                if (xmlStu.ClassID.text() != '') {
                    numEnrollmentsImported += loadEnrollment(stu, xmlStu)
                }
                else {
                    numInterestsImported += loadInterest(stu)
                }
            
                log.info("Student ${stu} imported.")
                numImported = numImported + 1
            }
            else {
                log.error("Couldn't import student.  Errors are: ")
                stu.errors.allErrors.each {
                    log.error("Error: ${it}")
                }
            }
        }

        results.messages.add("${numInterestsImported} interests imported.")
        results.messages.add("${numEnrollmentsImported} enrollments imported.")
        results.messages.add("${numImported} students imported.")

        return results
    }

    def loadEnrollment(stu, xmlStu) {
        if (xmlStu.ClassID.text() != '') {
            log.info("Trying to find class session '" + xmlStu.ClassID.text() + "'")
            def cs = findClassSessionByOldId(xmlStu.ClassID.text())
            if (!cs) {
                return 0;
            }
            log.info("Found class session " + cs)
            log.info("Trying to add enrollment for student" + stu)
            log.info("Deciding enrollment status:")
            def enr = new Enrollment(student:stu)
            if (xmlStu.GraduateDate.text() != '') {
                // then student graduated.
                // Graduation date is tracked with the Class Session, so just
                // mark enrollment as GRADUATED and throw away GraudateDate
                enr.status = EnrollmentStatus.GRADUATED
                // assume that since student is graduated, that they attended all
                // of this session's classes
                cs.lessonDates.each {
                    it.addToAttendees(student : stu, status:"present")
                    it.save()
                }
            }
            else if (xmlStu.DropOut.text() == "1") { 
                enr.status = EnrollmentStatus.DROPPED_OUT
            }
            else if (new Date() - cs.startDate > 90) {
                // Default to dropped out if class session was > 90 days ago
                // we can go back to current class and un-drop out kids
                enr.status = EnrollmentStatus.DROPPED_OUT
            }
            cs.addToEnrollments(enr)
            return 1
        }
    }

        
    def loadInterest(stu) {
        // create an interest in the default course for this student
        // use the signup date for the student's parent as the signupDate for the Interest
        def crs = getDefaultCourse()
        def interest = new Interest(active:true, student:stu, 
                                    course: crs,
                                    signupDate:stu.contact.signupDate).save()        
        crs.addToInterests(interest) 
        stu.addToInterests(interest) 
        return 1
    }

    def loadContacts(xmlString) {
        def xml = new XmlSlurper().parseText(xmlString)
		def contacts = xml.children()
        def results = [ messages : []]
        def importedContacts = 0

        contacts.each { xmlCon ->
            def con = new Contact(lastName:xmlCon.LastName.text(),
                                  firstName:xmlCon.FirstName.text())

            con.address1 = xmlCon.Address1.text()
            con.address2 = xmlCon.Address2.text()
            con.city = xmlCon.City.text()
            con.zipCode = xmlCon.Zip.text()
            con.state = xmlCon.State.text()

            if (xmlCon.PrimaryPhone != '') {
                con.addToPhoneNumbers(new PhoneNumber(label:"Home", phoneNumber:xmlCon.PrimaryPhone.text()))
            }

            if (xmlCon.SecondPhone != '') {
                log.info("found second phone for ${con.lastName} ${xmlCon.SecondPhone}")
                con.addToPhoneNumbers(new PhoneNumber(label:"Other", phoneNumber:xmlCon.SecondPhone.text()))
            }

            if (xmlCon.ParentEmail != '') {
                con.emailAddress = xmlCon.ParentEmail.text()
            }

            con.cannotReach = xmlCon.CouldNotReach.text() == '1' ? true : false
    
            def signupDateString = xmlCon.DateOfSignUp.text().split('T')[0]
            // Record this date to the SignupDate, also
            con.signupDate = Date.parse('yyyy-MM-dd', signupDateString)

            if (con.validate() && con.save()) {
                addCommentAboutId(con, xmlCon.ParentID.text())
                importedContacts = importedContacts + 1

                if (xmlCon.Note != '') {
                    addComment(con, xmlCon.Note?.text())
                }
                if (xmlCon.InfoTakenBy != '') {
                    log.info("Adding infotakenby: ${xmlCon.InfoTakenBy?.text()}")
                    addComment(con, 'Info taken by: ' + xmlCon.InfoTakenBy.text())
                }

                // Add comment about the date that contact signed up.
                // Duplicate functionality of signupDate, but what the heck
                addComment(con, 'Signup Date:' + signupDateString)

                log.info("Imported contact ${con} id: ${con.id}")
            }
            else {
                log.error("Couldn't import contact.  Errors are: ")
                con.errors.allErrors.each {
                    log.error("Error: ${it}")
                }
            }

        }

        results.messages.add("${importedContacts} contacts imported.")
        return results
    }


    // utility method to find a course to load data into.
    // prev. version of dB did not have the concept of "Courses"
    // Default to children's EAC course.
    def getDefaultCourse() {
        def c = Course.findByNameIlike("chil") ?: Course.list[0]
        return c
    }

    def addCommentAboutId(thingy, id) {
        addComment(thingy,  "Imported.  Original ID was :${id}:")
    }

    def addComment(thingy, comment) {
        thingy.addComment(ShiroUser.findByUsername("admin"), comment) 
    }

    def findContactByOldId(oldContactId) {
        // go through contacts' notes, and find this oldContactId
        def c = CommentLink.createCriteria()
        def links = c.list {
            eq('type', GrailsNameUtils.getPropertyName(Contact.class))
            comment {
                like('body', "%:${oldContactId}:%")
            }
        }

        if (links) {
            return Contact.findById(links[0].commentRef)
        }
        else {
            return null
        }
        
    }

    def findClassSessionByOldId(oldId) {
        // go through sessions' notes, and find this oldId
        def c = CommentLink.createCriteria()
        def links = c.list {
            eq('type', GrailsNameUtils.getPropertyName(ClassSession.class))
            comment {
                like('body', "%:${oldId}:%")
            }
        }

        if (links) {
            def cs =ClassSession.findById(links[0].commentRef) 
            log.info("Found Class session with: " + oldId)
            log.info("Class Session name is: " + cs)
            log.info("Class Session start date is: " + cs.startDate)
            return cs
        }
        else {
            log.error("Couldn't find Class session having oldId: '${ oldId }'")
            return null
        }
    }

    def createContactForOrphan(student, contactId) {
        def con = new Contact(lastName:student.lastName,
                              firstName:'SuppliedByDataImport',
                              emailAddress:student.emailAddress,
                              signupDate : Date.parse('yyyy/MM/dd', '2006/1/1')
        )

        if (con.validate() && con.save()) {
            addCommentAboutId(con, contactId)
            addComment(con, "Auto-generated by import, non-existent contact in import data")
        }
        else {
            log.error("Couldn't save auto-generated contact:")
            con.errors.allErrors.each {
                log.error("Error: ${it}")
            }
            return null
        }

        return con
    }
}
