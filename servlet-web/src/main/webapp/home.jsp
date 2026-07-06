<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.example.web.UserServlet,com.example.web.DashboardServlet,com.example.web.listener.AppSessionListener,java.lang.management.ManagementFactory" %>
<%
    // Populate a few live counters for the landing page.
    java.util.Map<String,Object> stats = new java.util.LinkedHashMap<>();
    stats.put("activeUsers",    UserServlet.snapshotSize());
    stats.put("usersCreated",   DashboardServlet.CREATE_COUNT.get());
    stats.put("activeSessions", AppSessionListener.active());
    stats.put("jvmUptimeMs",    ManagementFactory.getRuntimeMXBean().getUptime());
    request.setAttribute("stats", stats);
%>
<c:set var="ctx"        value="${pageContext.request.contextPath}"/>
<c:set var="appName"    value="${pageContext.servletContext.getInitParameter('appName')}"/>
<c:set var="environment" value="${pageContext.servletContext.getInitParameter('environment')}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>${appName} &mdash; Home</title>
    <link rel="stylesheet" href="${ctx}/css/site.css">
</head>
<body>
<div class="app">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp">
        <jsp:param name="active" value="home"/>
    </jsp:include>

    <jsp:include page="/WEB-INF/views/layout/topbar.jsp">
        <jsp:param name="crumbsCurrent" value="Home"/>
    </jsp:include>

    <main class="content">
        <div class="page-head">
            <div>
                <h1>Welcome to ${appName}</h1>
                <p class="muted">
                    A Jakarta EE 9 / Servlet 6.0 sample running on
                    <strong>${pageContext.servletContext.serverInfo}</strong>
                    in environment <code>${environment}</code>.
                </p>
            </div>
            <div>
                <a class="btn btn-primary" href="${ctx}/dashboard">Open dashboard &rarr;</a>
            </div>
        </div>

        <section class="stats">
            <div class="stat">
                <div class="label">Active users</div>
                <div class="value">${stats.activeUsers}</div>
                <div class="delta">in-memory store</div>
            </div>
            <div class="stat">
                <div class="label">Users created</div>
                <div class="value">${stats.usersCreated}</div>
                <div class="delta">since startup</div>
            </div>
            <div class="stat">
                <div class="label">Active sessions</div>
                <div class="value">${stats.activeSessions}</div>
                <div class="delta">live HTTP sessions</div>
            </div>
            <div class="stat">
                <div class="label">JVM uptime</div>
                <div class="value">
                    <%= stats.get("jvmUptimeMs") instanceof Number
                            ? ((Number) stats.get("jvmUptimeMs")).longValue() / 1000 + "s"
                            : "?" %>
                </div>
                <div class="delta">${pageContext.servletContext.serverInfo}</div>
            </div>
        </section>

        <section class="card">
            <h2>Interactive Website Preview Configuration</h2>
            <p class="muted" style="margin-top:0">
                Nhập thông tin tùy biến dưới đây để xem trước trang web tĩnh Angular trong cửa sổ mới (không hiển thị thanh điều hướng).
            </p>
            
            <div style="display: flex; flex-direction: column; gap: 12px; max-width: 500px; margin-bottom: 16px;">
                <div style="display: flex; flex-direction: column; gap: 4px;">
                    <label style="font-weight: 600; font-size: 0.9rem;">Tiêu đề trang (Title / Name)</label>
                    <input type="text" id="previewTitle" class="form-control" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;" value="Next-Generation Enterprise Portal">
                </div>
                <div style="display: flex; flex-direction: column; gap: 4px;">
                    <label style="font-weight: 600; font-size: 0.9rem;">Mô tả / Vai trò (Description / Role)</label>
                    <input type="text" id="previewDesc" class="form-control" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;" value="Experience unparalleled speeds, custom branding, and server-isolated security.">
                </div>
            </div>

            <button class="btn btn-primary" onclick="launchPreview()">Xem thử giao diện (window.open) &rarr;</button>

            <script>
                function launchPreview() {
                    var title = document.getElementById('previewTitle').value;
                    var desc = document.getElementById('previewDesc').value;
                    
                    // Lưu dữ liệu xem trước vào localStorage (bảo mật, dung lượng lớn tới 5MB, không sợ tràn URL)
                    var previewData = {
                        title: title,
                        desc: desc
                    };
                    localStorage.setItem('preview_data', JSON.stringify(previewData));
                    
                    // Sử dụng bản build ứng dụng Landing Page độc lập 100% (preview-landing)
                    var url = '${ctx}/preview-landing';
                    
                    // Cấu hình mở cửa sổ popup nổi ở giữa màn hình (Centered Floating Popup Window)
                    var width = 1200;
                    var height = 800;
                    var left = (screen.width - width) / 2;
                    var top = (screen.height - height) / 2;
                    var features = 'width=' + width + ',height=' + height + ',top=' + top + ',left=' + left + ',resizable=yes,scrollbars=yes,status=no,toolbar=no,menubar=no,location=no';
                    
                    window.open(url, 'PreviewWindow', features);
                }
            </script>
        </section>

        <section class="card">
            <h2>Where to start</h2>
            <p class="muted" style="margin-top:0">
                The app exposes a small CRUD servlet (<code>/users</code>), a JSON API
                (<code>/api/*</code>), and a dashboard with live stats
                (<code>/dashboard</code>). Everything works on a vanilla Servlet 6.0
                container &mdash; including NEC WebOTX V10/V11.
            </p>
            <div style="display:flex; gap:8px; flex-wrap:wrap;">
                <a class="btn" href="${ctx}/dashboard">Dashboard</a>
                <a class="btn" href="${ctx}/users">Users</a>
                <a class="btn" href="${ctx}/api-docs">API docs</a>
                <a class="btn" href="${ctx}/hello?name=WebOTX">/hello demo</a>
            </div>
        </section>

        <section class="card">
            <h2>Build &amp; deploy</h2>
            <pre><code>mvn clean package                      # build WAR
mvn -Pwebotx-deploy clean package       # build &amp; redeploy to WebOTX</code></pre>
            <p class="muted" style="margin-bottom:0">
                Requires JDK 21 and Maven 3.8+. The deploy profile is opt-in; without it
                only the WAR is built and no server is touched.
            </p>
        </section>
    </main>
</div>
</body>
</html>
