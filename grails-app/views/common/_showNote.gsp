${noteInstance.body} 
( ${noteInstance.poster}
${noteInstance.lastUpdated.format('MM/dd/yyyy')}
)
<a href="#" class="editNote" editNoteId="${noteInstance.id}">Edit</a>&nbsp;
<a href="#" class="saveNote" saveNoteId="${noteInstance.id}" style="display:none">Save</a>&nbsp;
<a href="#" class="cancelNote" cancelNoteId="${noteInstance.id}" style="display:none">Cancel</a>
<input type="hidden" origNoteText="${noteInstance.id}" value="${noteInstance.body}" />
