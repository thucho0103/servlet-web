<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="appName" value="${pageContext.servletContext.getInitParameter('appName')}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>${appName} &mdash; Users</title>
    <link rel="stylesheet" href="${ctx}/css/site.css">
</head>
<body>
<div class="app">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp">
        <jsp:param name="active" value="users"/>
    </jsp:include>

    <jsp:include page="/WEB-INF/views/layout/topbar.jsp">
        <jsp:param name="crumbsCurrent" value="Users"/>
    </jsp:include>

    <main class="content">
        <div class="page-head">
            <div>
                <h1>Users</h1>
                <p class="muted">In-memory store seeded by <code>UserServlet#init</code>.</p>
            </div>
            <div style="display:flex; gap:8px;">
                <a class="btn" href="${ctx}/users?format=json">JSON</a>
                <a class="btn btn-primary" href="#new-user">+ New user</a>
            </div>
        </div>

        <section class="card" id="new-user">
            <h2>Add user</h2>
            <form action="${ctx}/users" method="post" class="form-grid">
                <div class="field">
                    <label for="username">Username</label>
                    <input id="username" type="text" name="username" required
                           autocomplete="off" placeholder="e.g. alice">
                </div>
                <div class="field">
                    <label for="email">Email</label>
                    <input id="email" type="email" name="email" required
                           placeholder="alice@example.com">
                </div>
                <div class="field full">
                    <label for="displayName">Display name <span class="muted">(optional)</span></label>
                    <input id="displayName" type="text" name="displayName"
                           placeholder="Alice in Wonderland">
                </div>
                <div class="full" style="display:flex; justify-content:flex-end;">
                    <button class="btn btn-primary" type="submit">Create user</button>
                </div>
            </form>
        </section>

        <section class="card" style="padding:0;">
            <div class="table-wrap" style="border:none; box-shadow:none; border-radius:0;">
                <table class="grid">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Display name</th>
                            <th>Created</th>
                            <th style="text-align:right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td class="mono" title="${u.id}">${u.id}</td>
                            <td><strong>${u.username}</strong></td>
                            <td>${u.email}</td>
                            <td>${u.displayName}</td>
                            <td class="mono muted">${u.createdAt}</td>
                            <td style="text-align:right; white-space:nowrap;">
                                <a class="btn btn-sm" href="${ctx}/users/${u.id}">Edit</a>
                                <a class="btn btn-sm btn-danger"
                                   href="${ctx}/users/${u.id}?format=json">API</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="6">
                                <div class="empty">
                                    <h3>No users yet</h3>
                                    <p>Add the first one with the form above.</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>
