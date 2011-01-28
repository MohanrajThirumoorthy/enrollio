<ul>
    <g:each var="comment" in="${contactInstance.getComments().sort({it.dateCreated }).reverse()[0 .. 3]}">
    <li>
    ${comment.body} <small>( ${comment.poster} ${comment.lastUpdated.format('MM/dd/yyyy')})</small>
    </li>
    </g:each>
</ul>
