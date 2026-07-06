<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="appName" value="${pageContext.servletContext.getInitParameter('appName')}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>404 &middot; ${appName}</title>
    <link rel="stylesheet" href="${ctx}/css/site.css">
</head>
<body>
<div class="app">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

    <jsp:include page="/WEB-INF/views/layout/topbar.jsp">
        <jsp:param name="crumbsCurrent" value="Not found"/>
    </jsp:include>

    <main class="content">
        <div class="card">
            <div class="err-hero">
                <div class="code">404</div>
                <h2>Page not found</h2>
                <p>The path <code>${pageContext.request.requestURI}</code> does not exist on this server.</p>
                <p style="margin-top:18px;">
                    <a class="btn" href="${ctx}/">&larr; Back to home</a>
                    <a class="btn" href="${ctx}/api-docs">API docs</a>
                </p>
            </div>
        </div>
    </main>
</div>
</body>
</html>
