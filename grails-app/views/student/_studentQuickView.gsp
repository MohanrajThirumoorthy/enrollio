<div class="ui-widget ui-widget-content ui-corner-all">
    <h1 class="ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
        <span starId="${studentInstance.id}" class="star">
            <g:render template="/utility/starredThingy" model="[thingy:studentInstance]" />
        </span>
        <g:link action="edit" name="editStudentLink${studentInstance.id}" 
        id="${studentInstance.id}" controller="student"
        title="${studentInstance}">
            ${studentInstance}
        </g:link>
    </h1>
        <table>
        <g:if test="${studentInstance.birthDate}">
            <tr class="prop">
                <td valign="top" class="name">Birth Date:</td>

                <td valign="top" class="value">
                    <enrollio:formatDate date="${studentInstance.birthDate}" />
                </td>

            </tr>
        </g:if>
        <g:if test="${studentInstance.grade}">
        <tr class="prop">
            <td valign="top" class="name">Grade:</td>

            <td valign="top" class="value">${fieldValue(bean:studentInstance, field:'grade')}</td>

        </tr>
        </g:if>
        <g:if test="${studentInstance.gender}">
            <td valign="top" class="name">Gender:</td>

            <td valign="top" class="value">${fieldValue(bean:studentInstance, field:'gender')}</td>
        </g:if>


            <g:if test="${studentInstance.emailAddress}">
            <tr class="prop">
                <td valign="top" class="name">Email Address:</td>

                <td valign="top" class="value">${fieldValue(bean:studentInstance, field:'emailAddress')}</td>

            </tr>
            </g:if>

            <tr class="prop">
                <td valign="top" class="name">Interests:</td>

                <td  valign="top" style="text-align:left;" class="value">
                    <g:activeInterestLinks student="${studentInstance}"
                    contactCallListPositions="${contactCallListPositions}"/>
                </td>

            </tr>

            <g:if test="${studentInstance.enrollments}">
            <tr class="prop">
                <td valign="top" class="name">Enrollments:</td>

                <td  valign="top" style="text-align:left;" class="value">
                <ul class="basicList">
                    <g:each var="enr" in="${studentInstance.enrollments}">
                    <li>
                    ${enr.classSession.course.name}
                    <g:link controller="classSession"
                            action="show"
                            id="${enr.classSession.id}">
                    <enrollio:formatDate date="${enr.classSession.startDate}" />
                    </g:link>
                    </g:each>
                    </li>
                </ul>
                </td>

            </tr>
            </g:if>

        </table>
    </div>
