 $(document).ready(function(){
      // Show date picker for the "Signup Date" that shown on the
      // new student form.  (It's rendered in the createStudent.gsp template below)
         $('#signupDate').datepicker({changeYear:true});
      $("select.multiselect").multiSelect({
          showHeader : false,
          noneSelectedText : 'Select Interests',
           selectedList:2   // selectedList shows the names of the selected interests!
      });

      $(".editNote").click(function() {
          var noteId = $( this ).attr( 'editNoteId' );
          var noteElement=$( "[noteId=" + noteId + "]");
          var noteText = noteElement.text().trim();
          
          noteElement.html(
              '<input noteTextId="' + noteId + '" ' +
              'value="' + noteText + '" />'
          );

          // register an event handler to trap ENTER key
          // which will send the updated note
          $('[noteTextId=' + noteId + ']').keydown(function(event) {
            if (event.keyCode == '13') {
                $("[[saveNoteId=" + noteId + "]").click();
                event.preventDefault();
             }
          });

          toggleNoteLinks(noteId);
          
          // Don't actually trigger the href
          return false;
          
      });

      $(".saveNote").click(function() {
          var noteId = $( this ).attr( 'saveNoteId' );
          var noteElement=$( "[noteTextId=" + noteId + "]");
          var noteText = noteElement.val().trim();
          toggleNoteLinks(noteId);

          $.ajax({
              url:'${createLink(controller:"contact", action:"updateNote")}',
              data:  { 'noteText' : noteText, 'id' : noteId },
              success: function(msg) {
                  $("[noteDiv=" + noteId + "]").replaceWith(msg)
              }});
          // Don't actually trigger the href
          return false;
      });

      $(".cancelNote").click(function() {
          var noteId = $( this ).attr( 'cancelNoteId' );
          var noteText = $( "[origNoteText=" + noteId + "]").val().trim();
          
          $( "[noteId=" + noteId + "]").text(noteText);

          toggleNoteLinks(noteId);

          // Don't actually trigger the href
          return false;
      });

      function toggleNoteLinks(noteId) {
          $("[editNoteId=" + noteId + "]").toggle();
          $("[cancelNoteId=" + noteId + "]").toggle();
          $("[saveNoteId=" + noteId + "]").toggle();
      }

      var url = "${createLink(action:'foobarform', controller:'course', id:courseInstance.id)}";
      $( "#newContactNoteForm" ).dialog({
          title : 'New Note',
          position : 'center',
          autoOpen : false,
          height: 300,
          width: 335,
          modal: true,
          buttons: {
              "Save": function() {
                  // hack an ajax call by using the form's action
                  var action = $(this).children('form').attr('action');
                  var formData = $(this).children('form').serialize();
                  $.post(action, formData, function(resultData) {
                      // $("#contactNotes").html(resultData)
                      alert(resultData);
                  });
                  $(this).dialog( "close" );
              },
              Cancel: function() {
                  $( this ).dialog( "close" );
              }
          }
      });
      $('#createContactNote').click(function() {
          $("#newContactNoteForm").dialog("open");
          return false;
      });
});
