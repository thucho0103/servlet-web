<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="appName" value="${pageContext.servletContext.getInitParameter('appName')}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>${appName} &mdash; Hello</title>
    <link rel="stylesheet" href="${ctx}/css/site.css">
</head>
<body>
<div class="app">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

    <jsp:include page="/WEB-INF/views/layout/topbar.jsp">
        <jsp:param name="crumbsCurrent" value="Hello"/>
    </jsp:include>

    <main class="content">
        <div class="page-head">
            <div>
                <h1>${greeting}, ${name}!</h1>
                <p class="muted">Served by <code>${servletName}</code>.</p>
            </div>
        </div>

        <section class="card">
            <h2>Request details</h2>
            <table class="grid" style="box-shadow:none;border:none;">
                <tbody>
                    <tr><td class="muted">Greeting</td><td>${greeting}</td></tr>
                    <tr><td class="muted">Name</td><td>${name}</td></tr>
                    <tr><td class="muted">Servlet</td><td class="mono">${servletName}</td></tr>
                    <tr><td class="muted">Server</td><td class="mono">${serverInfo}</td></tr>
                    <tr><td class="muted">Timestamp</td><td class="mono">${timestamp}</td></tr>
                </tbody>
            </table>
        </section>

        <p><a class="btn" href="${ctx}/">&larr; Back to home</a></p>
    </main>
</div>
</body>
</html>
