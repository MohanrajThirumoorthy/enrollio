<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <meta name="tabName" content="course" />
        <script type="text/javascript">
             $(document).ready(function(){

                var url = "${createLink(action:'foobarform', controller:'course', id:courseInstance.id)}";
                $('.enrollStudent').click(function() {
                    var studentId = $(this).attr('studentid')
                    // populate enrollmentform
                    $.get(url,
                        { studentId : studentId } , function(data) { $('#dialog-form').html(data); }
                    );
                    $( "#dialog-form" ).dialog({
                        title : $(this).attr('studentName'), 
                        position : 'center',
                        height: 300,
                        width: 350,
                        modal: true,
                        buttons: {
                            "Save": function() {
                                // hack an ajax call by using the form's action
                                var action = $(this).children('form').attr('action');
                                var formData = $(this).children('form').serialize();
                                $.post(action, formData, function(resultData) {
                                    $("#studentEnrollmentData" + studentId).html(resultData)
                                });
                                $(this).dialog( "close" );
                            },
                            Cancel: function() {
                                $( this ).dialog( "close" );
                            }
                        }
                    });
                    return false;
                });
            });
            

        </script>
        <title>Interested Students</title>
        <style>
		label, input { display:block; }
		input.text { margin-bottom:12px; width:95%; padding: .4em; }
		fieldset { padding:0; border:0; margin-top:25px; }
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
        <div id="dialog-form">
            <g:form id="saveEnrollmentsForm"></g:form>
        </div>
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
