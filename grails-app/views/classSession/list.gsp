<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="main" />
    <meta name="tabName" content="classSession" />
    <title>Sessions</title>
</head>

<body>

    <g:each var="classSessionInstance" in="${classSessionInstanceList}">
    <p>${classSessionInstance.name} <enrollio:formatDate date="${classSessionInstance.startDate}" /></p>

    </g:each>
</body>
