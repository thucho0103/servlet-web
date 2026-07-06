<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="active" value="${active != null ? active : ''}"/>
<aside class="sidebar">
    <div class="brand">
        <div class="brand-mark">SW</div>
        <div>
            <div class="brand-name">servlet-web</div>
            <div class="brand-sub">on WebOTX</div>
        </div>
    </div>

    <nav>
        <div class="group-label">Overview</div>
        <a class="nav-link ${active eq 'home'      ? 'active' : ''}" href="${ctx}/">Home</a>
        <a class="nav-link ${active eq 'dashboard' ? 'active' : ''}" href="${ctx}/dashboard">Dashboard</a>

        <div class="group-label">Manage</div>
        <a class="nav-link ${active eq 'users'     ? 'active' : ''}" href="${ctx}/users">Users</a>
        <a class="nav-link ${active eq 'api'       ? 'active' : ''}" href="${ctx}/api-docs">API</a>

        <div class="group-label">System</div>
        <a class="nav-link" href="${ctx}/api/health">Health</a>
        <a class="nav-link" href="${ctx}/api/stats">Stats</a>
    </nav>

    <div class="footer-note">
        ${appName} &middot; ${environment}<br>
        Jakarta EE 9 / Servlet 6.0
    </div>
</aside>
