<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx"     value="${pageContext.request.contextPath}"/>
<c:set var="appName" value="${pageContext.servletContext.getInitParameter('appName')}"/>
<c:set var="s"       value="${stats}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>${appName} &mdash; Dashboard</title>
    <link rel="stylesheet" href="${ctx}/css/site.css">
</head>
<body>
<div class="app">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp">
        <jsp:param name="active" value="dashboard"/>
    </jsp:include>

    <jsp:include page="/WEB-INF/views/layout/topbar.jsp">
        <jsp:param name="crumbsCurrent" value="Dashboard"/>
    </jsp:include>

    <main class="content">
        <div class="page-head">
            <div>
                <h1>Dashboard</h1>
                <p class="muted">Live runtime counters from the servlet container.</p>
            </div>
            <div>
                <a class="btn btn-sm" href="${ctx}/api/stats?format=json">View JSON</a>
                <a class="btn btn-sm btn-primary" href="${ctx}/dashboard">Refresh</a>
            </div>
        </div>

        <section class="stats">
            <div class="stat">
                <div class="label">Users in store</div>
                <div class="value">${s.activeUsers}</div>
                <div class="delta">${s.usersCreated} created since startup</div>
            </div>
            <div class="stat">
                <div class="label">Active sessions</div>
                <div class="value">${s.activeSessions}</div>
                <div class="delta">tracked by AppSessionListener</div>
            </div>
            <div class="stat">
                <div class="label">JVM uptime</div>
                <div class="value">
                    <fmt:formatNumber value="${s.jvmUptimeMs / 1000}" maxFractionDigits="0"/>s
                </div>
                <div class="delta">${s.serverInfo}</div>
            </div>
            <div class="stat">
                <div class="label">Environment</div>
                <div class="value" style="font-size:20px">
                    <span class="tag">${s.environment}</span>
                </div>
                <div class="delta">${s.appName}</div>
            </div>
        </section>

        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:16px;">
            <section class="card">
                <h2>Server</h2>
                <table class="grid" style="box-shadow:none;border:none;">
                    <tbody>
                        <tr><td class="muted">Server</td><td class="mono">${s.serverInfo}</td></tr>
                        <tr><td class="muted">App name</td><td class="mono">${s.appName}</td></tr>
                        <tr><td class="muted">Environment</td><td><span class="tag">${s.environment}</span></td></tr>
                        <tr><td class="muted">Context path</td><td class="mono">${s.contextPath}</td></tr>
                        <tr><td class="muted">Now</td><td class="mono">${s.now}</td></tr>
                    </tbody>
                </table>
            </section>

            <section class="card">
                <h2>Quick links</h2>
                <ul style="margin:0; padding-left: 18px;">
                    <li><a href="${ctx}/users">Manage users</a></li>
                    <li><a href="${ctx}/api-docs">API documentation</a></li>
                    <li><a href="${ctx}/api/health">Health JSON</a></li>
                    <li><a href="${ctx}/hello?name=WebOTX">Hello demo</a></li>
                </ul>
            </section>
        </div>
    </main>
</div>
</body>
</html>
