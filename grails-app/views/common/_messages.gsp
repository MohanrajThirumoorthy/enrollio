<g:if test="${flash.message}">
<div class="info ui-widget">
    <div style="margin-top: 20px; padding: 0pt 0.7em;" class="ui-state-default ui-corner-all"> 
        <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-info"></span>
        <strong>Info:</strong>${flash.message}</p>
    </div>
</div>
</g:if>
<g:if test="${flash.warning}">
<div class="ui-widget">
    <div style="margin-top: 20px; padding: 0pt 0.7em;" class="ui-state-highlight ui-corner-all"> 
        <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
        <strong>Warning:</strong>${flash.warning}</p>
    </div>
</div>
</g:if>
<g:if test="${flash.error}">
<div class="ui-widget">
    <div style="margin-top: 20px; padding: 0pt 0.7em;" class="ui-state-error ui-corner-all"> 
        <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
        <strong>Error:</strong>${flash.error}</p>
    </div>
</div>
</g:if>
