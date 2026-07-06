<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="appName" value="${pageContext.servletContext.getInitParameter('appName')}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>${appName} &mdash; API</title>
    <link rel="stylesheet" href="${ctx}/css/site.css">
</head>
<body>
<div class="app">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp">
        <jsp:param name="active" value="api"/>
    </jsp:include>

    <jsp:include page="/WEB-INF/views/layout/topbar.jsp">
        <jsp:param name="crumbsCurrent" value="API"/>
    </jsp:include>

    <main class="content">
        <div class="page-head">
            <div>
                <h1>API</h1>
                <p class="muted">All endpoints are reachable at <code>${ctx}</code>.</p>
            </div>
        </div>

        <section class="card" style="padding:0;">
            <div class="table-wrap" style="border:none; box-shadow:none; border-radius:0;">
                <table class="grid">
                    <thead>
                        <tr>
                            <th>Method</th>
                            <th>Path</th>
                            <th>Description</th>
                            <th style="text-align:right;">Try it</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><span class="tag tag-get">GET</span></td>
                            <td class="mono">/api/health</td>
                            <td>Liveness probe. Returns <code>{status, server, app, env, timestamp}</code>.</td>
                            <td style="text-align:right;"><a class="btn btn-sm" href="${ctx}/api/health" target="_blank">Open</a></td>
                        </tr>
                        <tr>
                            <td><span class="tag tag-get">GET</span></td>
                            <td class="mono">/api/echo</td>
                            <td>Echoes the incoming request (method, path, query, headers).</td>
                            <td style="text-align:right;"><a class="btn btn-sm" href="${ctx}/api/echo" target="_blank">Open</a></td>
                        </tr>
                        <tr>
                            <td><span class="tag tag-get">GET</span></td>
                            <td class="mono">/api/stats</td>
                            <td>Runtime stats (users, sessions, JVM uptime).</td>
                            <td style="text-align:right;"><a class="btn btn-sm" href="${ctx}/api/stats" target="_blank">Open</a></td>
                        </tr>
                        <tr>
                            <td><span class="tag tag-get">GET</span></td>
                            <td class="mono">/users</td>
                            <td>List users as HTML. Add <code>?format=json</code> for JSON.</td>
                            <td style="text-align:right;">
                                <a class="btn btn-sm" href="${ctx}/users" target="_blank">HTML</a>
                                <a class="btn btn-sm" href="${ctx}/users?format=json" target="_blank">JSON</a>
                            </td>
                        </tr>
                        <tr>
                            <td><span class="tag tag-get">GET</span></td>
                            <td class="mono">/users/&lcub;id&rcub;</td>
                            <td>Fetch one user as HTML form. Use <code>?format=json</code> for JSON.</td>
                            <td style="text-align:right;"><span class="muted">Use a real id</span></td>
                        </tr>
                        <tr>
                            <td><span class="tag tag-post">POST</span></td>
                            <td class="mono">/users</td>
                            <td>Create a user. Form fields: <code>username</code>, <code>email</code>, <code>displayName</code>.</td>
                            <td style="text-align:right;"><span class="muted">Use the UI</span></td>
                        </tr>
                        <tr>
                            <td><span class="tag tag-post">POST</span></td>
                            <td class="mono">/users/&lcub;id&rcub;</td>
                            <td>Update an existing user via form post (browser-friendly).</td>
                            <td style="text-align:right;"><span class="muted">Use the UI</span></td>
                        </tr>
                        <tr>
                            <td><span class="tag tag-put">PUT</span></td>
                            <td class="mono">/users/&lcub;id&rcub;</td>
                            <td>Update an existing user via JSON body.</td>
                            <td style="text-align:right;"><span class="muted">cURL / fetch</span></td>
                        </tr>
                        <tr>
                            <td><span class="tag tag-delete">DELETE</span></td>
                            <td class="mono">/users/&lcub;id&rcub;</td>
                            <td>Delete a user. Returns <code>204 No Content</code>.</td>
                            <td style="text-align:right;"><span class="muted">cURL / fetch</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>

        <section class="card">
            <h2>cURL examples</h2>
            <pre><code># Create a user
curl -X POST ${ctx}/users \
  -H 'Accept: application/json' \
  -d 'username=alice&amp;email=alice@example.com&amp;displayName=Alice'

# Update via JSON
curl -X PUT ${ctx}/users/&lt;id&gt; \
  -H 'Content-Type: application/json' \
  -d '{"email":"alice2@example.com"}'

# Delete
curl -X DELETE ${ctx}/users/&lt;id&gt;</code></pre>
        </section>
    </main>
</div>
</body>
</html>
