<div id="studentSearchForm" style="float:right;margin 30px;">
    <g:form url="[controller: 'student', action: 'list']" id="studentSearchForm" name="searchableForm" method="get">
    <g:textField name="q" value="${params.q}" size="20" />
    <input id="studentSearchButton" type="submit" value="Search" />
    </g:form>
</div>
