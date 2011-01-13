<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
        <script type="text/javascript" src="${resource(dir:'js', file:'jquery-1.4.2.min.js')}"></script>
        <script type="text/javascript">
             $(document).ready(function(){
                     $('#changeAllLink').click().toggle(
                         function() { $('#changeAllDiv').show() },
                         function() { $('#changeAllDiv').hide() }
                     );
                     $('#changeAllSelectBox').change(function() {
                         var reserveForUser = $(this).val()
                        $('.reserveContact').each(function() {
                            $(this).val(reserveForUser).change(); 
                        });
                        // hide select box
                        $('#changeAllDiv').hide()
                     });
                $('.enrollStudent').click(function() {
                    $.post('${createLink(controller:"classSession",
                                            action:"enrollStudent")}',
                            { 'enroll' : $(this).attr('checked'), 
                            'studentId' : $(this).attr("studentId"),
                            'classSessionId' : $(this).attr("classSessionId") },
                            function(data) {
                            // update student count w/results from enrollStudent action
                                $('#studentCount').html(data);
                            });
                    });
                // When user clicks any entry that has a class of "reserveContact", then
                // submit a POST to the app, with the contactId and classSessionId, and then
                // the contact will be "reserved" for the current user.  meow.
                $('.reserveContact').change(function() {
                    postReservation($(this), $(this).val());
                    updatePushPin($(this).parent(), $(this).val())
                });
                $('.reservationPushPin').click(function() {
                    var pushPin = $(this);
                    var userId = pushPin.attr("userId");
                    postReservation(pushPin, userId);
                    // Change drop-down to reflect who (if anybody) has
                    // reserved this contact
                    updatePushPin(pushPin.parent(), userId)
                    // Update the select box
                    pushPin.parent().find('.reserveContact').val(userId)
                })
                
             });

            // generic function to handle sending POSTS to 
            // reserveContact action
            function postReservation(element, userId) {
                $.post('${createLink(controller:"classSession",
                                        action:"reserveContact")}',
                    { 'contactId' : $(element).attr("contactId"), 
                         'userId' : userId,
                 'courseId' : $(element).attr("courseId") });
            }

            // update the push pin that's in the parent TD
            function updatePushPin(parent, reservationUserId) {
                var pushPin = parent.find('.reservationPushPin');
                // If reservationUserId = this push pin's userId, then show red, and 
                // DELETE the userId attribute
                if(reservationUserId != "" && reservationUserId == pushPin.attr("userId")) {
                    pushPin.attr("src", 
                        "${resource(dir:'images/icons', file:'push_pin_red.png')}");
                    pushPin.attr("userId", "")
                }
                else {
                    // Add the current user's ID to this push pin, and make it gray
                    // when push pin is pressed, this userID is sent to server to reserve the contact
                    pushPin.attr("src" , 
                        "${resource(dir:'images/icons', file:'push_pin_gray.png')}"); 
                    pushPin.attr("userId", "${currentUser.id}")
                }
                
            }

        </script>
        <title></title>
    </head>
    <body>
        <div id="wrapper">
            <div id="content">
                <div class="rightnow">
                    <h3 class="reallynow">
                        <g:if test="${classSessionInstance}">
                                <g:link controller="classSession"
                                           class="headerLink calendar"
                                           action="show"
                                           id="${classSessionInstance.id}" >
                                           ${classSessionInstance.name}</g:link>
                        </g:if>
                        <g:else>
                            <span>Waiting List for ${courseInstance}</span>
                        </g:else>
                        <br />
                    </h3>
                        <g:form controller="course" action="interestedStudents" 
                            id="${courseInstance.id}"
                            method="GET">

                            <g:hiddenField name="classSessionId" value="${classSessionInstance?.id}" />
                            <table>
                                <tr>
                                    <td>
                                        <label for="q">Contact Name:</label>
                                        <g:textField name="q" value="${params.q}" size="20" />
                                    </td>
                                    <td>
                                        <label for="reservedForUser">Reserved For:</label>
                                        <g:select 
                                        name="reservedForUser"
                                        courseId="${courseInstance.id}"
                                        from="${users}" 
                                        optionKey="id" 
                                        value="${reservedForUserId}"
                                        noSelection="['':'']" />
                                        <g:submitButton name="submitFilter" value="Search" />
                                        <g:link action="interestedStudents" 
                                        controller="course" id="${courseInstance.id}">
                                        Clear
                                        </g:link>
                                    </td>

                                </tr>
                            
                        <g:if test="${classSessionInstance}">
                                <tr>
                                
                                    <td>
                                    ${contactInstanceTotal} students interested in 
                                    <g:link action="show" controller="course" id="${courseInstance.id}">${courseInstance}</g:link>
                                    </td>
                                    <td>
                                        <span id="studentCount">
                                        <b>${classSessionInstance.enrollments?.size()}</b> 
                                        students enrolled.
                                        </span>
                                    </td>
                                </tr>
                        </g:if>
                        </table>
                        </g:form>
                    <table>
                        <thead>
                            <th colspan="2">Contact</th>
                            <th>Students</th>
                        </thead>
                        <g:each var="con" 
                            in="${contactInstanceList}">
                        <g:render template="interestedContact" 
                        model="[
                            users : users,
                            contactInstance : con,
                            selectedContactId : selectedContactId,
                            callListContacts : callListContacts,
                            courseInstance : courseInstance,
                            classSessionInstance : classSessionInstance ]" />
                        </g:each>
                    </table>
                </div>
                <div class="paginateButtons">
                    <g:paginate id="${courseInstance.id}" 
                    total="${contactInstanceTotal}"
                    params="[ reservedForUser : reservedForUserId ?: '',
                                classSessionId:classSessionInstance?.id]" />
                </div>
            </div>
            <div id="sidebar">
                <g:if test="${classSessionInstance}">
                    <g:render template="/classSession/individualClassSessionMenu" 
                    model="[classSessionInstance:classSessionInstance]" />
                </g:if>
                <g:else>
                <g:render template="individualCourseMenu" 
                        model="[q:params.q, reservedForUserId : reservedForUserId]"/>
                </g:else>
            </div>
        </div>
    </body>
</html>
