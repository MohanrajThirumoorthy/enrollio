<g:hasErrors bean="${bean}">
<div class="ui-widget">
    <div style="" class="ui-state-error ui-corner-all"> 
        <p>
        <span style="float: left; margin-right: 0.3em;" 
            class="ui-icon ui-icon-alert">
        </span> 
        <strong>Alert:</strong> 
        <g:renderErrors bean="${bean}" as="list" />
        </p>
    </div>
</div>
</g:hasErrors>
