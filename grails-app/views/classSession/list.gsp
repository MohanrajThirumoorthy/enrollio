<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="main" />
    <meta name="tabName" content="classSession" />
    <title>Sessions</title>
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
	</style><script>
	$(function() {
		// a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
		$( "#dialog:ui-dialog" ).dialog( "destroy" );
		
		var name = $( "#name" ),
			email = $( "#email" ),
			password = $( "#password" ),
			allFields = $( [] ).add( name ).add( email ).add( password ),
			tips = $( ".validateTips" );

		function updateTips( t ) {
			tips
				.text( t )
				.addClass( "ui-state-highlight" );
			setTimeout(function() {
				tips.removeClass( "ui-state-highlight", 1500 );
			}, 500 );
		}

		function checkLength( o, n, min, max ) {
			if ( o.val().length > max || o.val().length < min ) {
				o.addClass( "ui-state-error" );
				updateTips( "Length of " + n + " must be between " +
					min + " and " + max + "." );
				return false;
			} else {
				return true;
			}
		}

		function checkRegexp( o, regexp, n ) {
			if ( !( regexp.test( o.val() ) ) ) {
				o.addClass( "ui-state-error" );
				updateTips( n );
				return false;
			} else {
				return true;
			}
		}
		
		$( "#dialog-form" ).dialog({
			autoOpen: false,
			height: 300,
			width: 350,
			modal: true,
			buttons: {
				"Save": function() {
					var bValid = true;

                                        $( "#users tbody" ).append( "SANGLE!"); 
                                        $( this ).dialog( "close" );
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			},
			close: function() {
				allFields.val( "" ).removeClass( "ui-state-error" );
			}
		});

		$( ".create-user" )
			.click(function() {
                        $("#dialog-form #bup").text($(this).text());
				$( "#dialog-form" ).dialog( "open" );

			});
	});
	</script>
</head>

<body>
    <div id="contentContainer" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
        <div style="float:left;" class="ui-corner-all ui-widget-content ui-corner-bottom">

<div class="demo">

<div id="dialog-form" title="Create new user">
	<form>
	<fieldset>
		<label id="bup" for="session1">Name</label>
                <input type="checkbox" id="session1" name="cannotReach">
		<label for="session2">Sessoin 3</label>
                <input type="checkbox" id="session2" name="session2">
		<label for="session3">Sessoin 3</label>
                <input type="checkbox" id="session3" name="session3">
		<label for="session4">Sessoin 3</label>
                <input type="checkbox" id="session4" name="session4">
	</fieldset>
	</form>
</div>


<div id="users-contain" class="ui-widget">
	<table id="users" class="ui-widget ui-widget-content">
		<thead>
			<tr class="ui-widget-header ">
				<th>Contact</th>
				<th>Student</th>
				<th>Enrollments</th>
			</tr>
		</thead>
		<tbody>
			<tr>
                            <td>John Doe
                                Lorem ipsum dolor sit amet, <br />
                                consectetur adipisicing elit, <br />
                                sed do eiusmod tempor incididunt ut labore et dolore <br />
                                magna aliqua. Ut enim ad minim veniam, <br />
                                quis nostrud exercitation ullamco laboris nisi ut aliquip ex <br />
                            
                            
                            
                            </td>
				<td>Bplug <a href="#" class="create-user" id="create-user">Create new user</a></td>
				<td>Earn-A-Computer 10/12/2009</td>
			</tr>
                        <tr>
                            <td></td>
				<td>Dangle <a class="create-user" href="#" id="create-user">Smurf</a></td>
                            <td>Earn-A-Computer 10/12/2009</td>
                        </tr>
		</tbody>
	</table>
</div>

</div><!-- End demo -->


</body>
