package org.bworks.bworksdb

import grails.test.*

class StudentDataLoadingIntegrationTests extends GrailsUnitTestCase {
    def dataLoadingService

   void testStudentBasicImport() {
        def torten1 = Student.findByLastName("Tortenweasel")
        assertNull "No Tortenweasel students", torten1

        // must load contacts before loading students
        dataLoadingService.loadContacts(fixtureMultipleContacts())
        def xml = fixtureMultipleStudents()
        dataLoadingService.loadStudents(xml)

        // Firstname and lastname are tested here
        torten1 = Student.findByLastNameAndFirstName("Tortenweasel", "Totoro" )
        assertNotNull "Tortenweasel student loaded", torten1

        assertEquals "Import Student Grade", '10', torten1.grade
        assertEquals "Import Student Email", 'totoro@alum.bworks.org', torten1.emailAddress
        

    }

    def fixtureMultipleStudents() {
        def xml = '''<?xml version="1.0" encoding="UTF-8"?>
<dataroot xmlns:od="urn:schemas-microsoft-com:officedata" xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance"  xsi:noNamespaceSchemaLocation="Student.xsd">
<Student>
<StudentID>188</StudentID>
<ParentID>8675309</ParentID>
<LastName>Bandit</LastName>
<FirstName>Smokey</FirstName>
<BirthDate>1997-01-07T00:00:00</BirthDate>
<Grade>10</Grade>
<ClassID>13</ClassID>
<GraduateDate>2007-08-18T00:00:00</GraduateDate>
<DropOut>0</DropOut>
<SystemReceivedID>0</SystemReceivedID>
<email>smokeybandit@reynolds.com</email>
</Student>
<Student>
<StudentID>188</StudentID>
<ParentID>1010101</ParentID>
<LastName>Tortenweasel</LastName>
<FirstName>Totoro</FirstName>
<BirthDate>1997-01-07T00:00:00</BirthDate>
<Grade>10</Grade>
<ClassID>13</ClassID>
<GraduateDate>2007-08-18T00:00:00</GraduateDate>
<DropOut>0</DropOut>
<SystemReceivedID>0</SystemReceivedID>
<email>totoro@alum.bworks.org</email>
</Student>
<Student>
<StudentID>188</StudentID>
<ParentID>1</ParentID>
<LastName>Nobodys</LastName>
<FirstName>Iam</FirstName>
<BirthDate>1996-01-07T00:00:00</BirthDate>
<Grade>4</Grade>
<ClassID>1</ClassID>
<GraduateDate>2007-08-18T00:00:00</GraduateDate>
<DropOut>0</DropOut>
<SystemReceivedID>0</SystemReceivedID>
<email>smokeybandit@reynolds.com</email>
</Student>
<Student>
<StudentID>188</StudentID>
<ParentID>1010101</ParentID>
<LastName>Tortenweasel</LastName>
<FirstName>Smokey</FirstName>
<BirthDate>1997-01-07T00:00:00</BirthDate>
<Grade>10</Grade>
<ClassID>13</ClassID>
<GraduateDate>2007-08-18T00:00:00</GraduateDate>
<DropOut>0</DropOut>
<SystemReceivedID>0</SystemReceivedID>
<email>smokeybandit@reynolds.com</email>
</Student>
</dataroot>
'''
        return xml

    }

    def fixtureMultipleContacts() {
        def xml = '''<?xml version="1.0" encoding="UTF-8"?>
<dataroot xmlns:od="urn:schemas-microsoft-com:officedata" xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance"  xsi:noNamespaceSchemaLocation="Parent.xsd">
<Parent>
<ParentID>1</ParentID>
<LastName>Malachi</LastName>
<FirstName>Satanya</FirstName>
<PrimaryPhone>(123) 222-4444</PrimaryPhone>
<DateOfSignUp>2009-10-10T00:00:00</DateOfSignUp>
<City>St. Elmo</City>
<State>MA</State>
<BroadbandAtHome>0</BroadbandAtHome>
<CouldNotReach>0</CouldNotReach>
<Address1>Level 1</Address1>
<Address2>Level Nine</Address2>
<Zip>63666</Zip>
</Parent>
<Parent>
<ParentID>3</ParentID>
<LastName>Chateaubolognese</LastName>
<ParentEmail>schmitzenblitzen@donner.com</ParentEmail>
<FirstName>Cherise</FirstName>
<PrimaryPhone>(314) 111-3333</PrimaryPhone>
<SecondPhone>(314) 111-2222</SecondPhone>
<DateOfSignUp>2006-01-02T00:00:00</DateOfSignUp>
<Address1>123 Chateaubolognese Street</Address1>
<Address2>Unit A</Address2>
<City>St. Louis</City>
<State>MO</State>
<Zip>63110</Zip>
<BroadbandAtHome>0</BroadbandAtHome>
<CouldNotReach>0</CouldNotReach>
</Parent>
<Parent>
<ParentID>1010101</ParentID>
<LastName>Tortenweasel</LastName>
<FirstName>Smitty</FirstName>
<PrimaryPhone>(314) 777-1111</PrimaryPhone>
<DateOfSignUp>2006-01-14T00:00:00</DateOfSignUp>
<Address1>789 Descending Street</Address1>
<City>St. Louis</City>
<State>MO</State>
<Zip>63104</Zip>
<BroadbandAtHome>0</BroadbandAtHome>
<CouldNotReach>0</CouldNotReach>
</Parent>
<Parent>
<ParentID>8675309</ParentID>
<LastName>Schmitzenbaumer</LastName>
<FirstName>Theresa</FirstName>
<PrimaryPhone>(314) 555-4444</PrimaryPhone>
<SecondPhone>(314) 333-2222</SecondPhone>
<DateOfSignUp>2006-01-21T00:00:00</DateOfSignUp>
<Address1>314 Phone Street</Address1>
<Address2>Unit Bevel Street</Address2>
<State>MO</State>
<Note>Some note that we should save.</Note>
<InfoTakenBy>Herr Cookie Monster</InfoTakenBy>
<BroadbandAtHome>0</BroadbandAtHome>
<CouldNotReach>1</CouldNotReach>
</Parent>
</dataroot>
'''
        return xml
    }
 
    // Utility method to search for comments that match
    // this thingy's origId
    def getCommentWithImportInfo(thingy, id) {

        def comment = thingy.comments.find {
            def matchString = "Original ID was :${id}"
            println "body" + it.body
            it.body =~ /Imported./ && it.body =~ /Original ID was :${id}:/
        }

        return comment
    }


}

