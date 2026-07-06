<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="appName" value="${pageContext.servletContext.getInitParameter('appName')}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>${appName} &mdash; Edit ${user.username}</title>
    <link rel="stylesheet" href="${ctx}/css/site.css">
</head>
<body>
<div class="app">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp">
        <jsp:param name="active" value="users"/>
    </jsp:include>

    <jsp:include page="/WEB-INF/views/layout/topbar.jsp">
        <jsp:param name="crumbsCurrent" value="Users / ${user.username}"/>
    </jsp:include>

    <main class="content">
        <div class="page-head">
            <div>
                <h1>Edit user</h1>
                <p class="muted">
                    ID <code class="mono">${user.id}</code> &middot;
                    created <span class="mono">${user.createdAt}</span>
                </p>
            </div>
            <div>
                <a class="btn" href="${ctx}/users">&larr; Back to list</a>
            </div>
        </div>

        <section class="card">
            <form action="${ctx}/users/${user.id}" method="post" class="form-grid">
                <div class="field">
                    <label for="username">Username</label>
                    <input id="username" type="text" name="username"
                           value="${user.username}" readonly>
                    <div class="hint">Username cannot be changed.</div>
                </div>
                <div class="field">
                    <label for="email">Email</label>
                    <input id="email" type="email" name="email"
                           value="${user.email}" required>
                </div>
                <div class="field full">
                    <label for="displayName">Display name</label>
                    <input id="displayName" type="text" name="displayName"
                           value="${user.displayName}">
                </div>
                <div class="full" style="display:flex; justify-content:flex-end; gap:8px;">
                    <a class="btn" href="${ctx}/users">Cancel</a>
                    <button class="btn btn-primary" type="submit">Save changes</button>
                </div>
            </form>
        </section>

        <section class="card">
            <h2>JSON view</h2>
            <p class="muted">The same record exposed via the JSON API.</p>
            <pre><code>${jsonView}</code></pre>
            <div class="card-foot">
                <a class="btn btn-sm" href="${ctx}/users/${user.id}?format=json" target="_blank">Open in new tab</a>
            </div>
        </section>
    </main>
</div>
</body>
</html>
