package com.example.web;

import com.example.web.listener.AppSessionListener;
import com.example.web.util.Json;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Dashboard HTML view at {@code /dashboard} plus a JSON stats endpoint at
 * {@code /api/stats} (mapped via {@code web.xml}).
 */
@WebServlet(name = "DashboardServlet", urlPatterns = "/dashboard", loadOnStartup = 1)
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /** Incremented whenever {@link UserServlet} successfully creates a user. */
    public static final AtomicLong CREATE_COUNT = new AtomicLong();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Map<String, Object> stats = buildStats(req);
        req.setAttribute("stats", stats);

        if ("json".equalsIgnoreCase(req.getParameter("format"))) {
            writeJson(resp, Json.toJson(stats));
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }

    static Map<String, Object> buildStats(HttpServletRequest req) {
        Map<String, Object> stats = new LinkedHashMap<>();
        stats.put("appName",        req.getServletContext().getInitParameter("appName"));
        stats.put("environment",    req.getServletContext().getInitParameter("environment"));
        stats.put("serverInfo",     req.getServletContext().getServerInfo());
        stats.put("now",            Instant.now().toString());
        stats.put("jvmUptimeMs",    ManagementFactory.getRuntimeMXBean().getUptime());
        stats.put("activeUsers",    UserServlet.snapshotSize());
        stats.put("usersCreated",   CREATE_COUNT.get());
        stats.put("activeSessions", AppSessionListener.active());
        stats.put("contextPath",    req.getContextPath());
        return stats;
    }

    private static void writeJson(HttpServletResponse resp, String body) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(body);
    }
}
