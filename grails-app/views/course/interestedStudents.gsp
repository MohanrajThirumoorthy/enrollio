<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
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
        <style>
                fieldset label {
                    float:left;
                    padding:4px;
                }
		h1 { font-size: 1.2em; margin: .6em 0; }
		div#users-contain { margin: 20px 0; }
		div#users-contain table { margin: 1em 0; border-collapse: collapse; width: 100%; }
		div#users-contain table td, div#users-contain table th { border: 1px solid #eee; padding: .6em 10px; text-align: left; }
		.ui-dialog .ui-state-error { padding: .3em; }
		.validateTips { border: 1px solid transparent; padding: 0.3em; }
	</style>
    </head>
    <body>
        <g:render template="/common/messages" />
        <div id="someMenu" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
            <a href="#"></a>
        </div>
        <div id="contentContainer" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
            <ul id="ulSecond" class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-bottom">
                <g:each var="course" in="${courseInstanceList}">
                <li class="ui-state-default ui-corner-top ${course.id == courseInstance.id ? 'ui-tabs-selected ui-state-active' : ''}">
                <g:link id="${course.id}" action="show" controller="course">${course.name}</g:link>
                </li>
                </g:each>
            </ul>

            <div style="overflow:hidden;" class="ui-tabs-panel ui-widget-content ui-corner-bottom">
                <g:form controller="course" action="interestedStudents" id="${courseInstance.id}" method="GET">
                <fieldset id="waitingListSearch">
                <legend>Waiting List</legend>
                    <label for="q">Contact Name:</label>

                    <g:textField name="q" value="${params.q}" size="20" />
                    <g:submitButton name="submitFilter" value="Search" />
                    <g:link action="interestedStudents" controller="course" id="${courseInstance.id}"> Clear </g:link>
                </g:form>
            </fieldset>
                <table id="interestedStudents" style="width:100%;float:left;" class="ui-widget ui-widget-content">
                    <thead>
                        <tr class="ui-widget-header2 ">
                            <th colspan="3">Waiting List</th>
                        </tr>
                    </thead>

                <g:each var="con" in="${contactInstanceList}">
                <g:render template="interestedContact" model="[ users : users,
                    contactInstance : con,
                    selectedContactId : selectedContactId,
                    callListContacts : callListContacts,
                    courseInstance : courseInstance,
                    classSessionInstance : classSessionInstance ]" />
                    </g:each>




                </table>
                <div style="float:left;" class="paginateButtons">
                    <g:paginate id="${courseInstance.id}" total="${contactInstanceTotal}"
                    params="[ reservedForUser : reservedForUserId ?: '', classSessionId:classSessionInstance?.id]" />
                </div>
            </div>
        </div>
    </body>
</html>
