<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="appName" value="${pageContext.servletContext.getInitParameter('appName')}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>500 &middot; ${appName}</title>
    <link rel="stylesheet" href="${ctx}/css/site.css">
</head>
<body>
<div class="app">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

    <jsp:include page="/WEB-INF/views/layout/topbar.jsp">
        <jsp:param name="crumbsCurrent" value="Server error"/>
    </jsp:include>

    <main class="content">
        <div class="card">
            <div class="err-hero">
                <div class="code">500</div>
                <h2>Server error</h2>
                <p>Something went wrong while handling <code>${pageContext.request.requestURI}</code>.</p>
            </div>
        </div>

        <c:if test="${exception != null}">
            <section class="card">
                <h2>Exception</h2>
                <pre><code><%= exception.getClass().getName() %>: <%= exception.getMessage() %></code></pre>
            </section>
        </c:if>

        <p style="margin-top:16px;">
            <a class="btn" href="${ctx}/">&larr; Back to home</a>
        </p>
    </main>
</div>
</body>
</html>
