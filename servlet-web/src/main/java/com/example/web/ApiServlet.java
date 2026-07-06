package com.example.web;

import com.example.web.util.Json;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Lightweight JSON endpoint: health/status + request echo.
 * Mapped at /api/*.
 */
@WebServlet(name = "ApiServlet", urlPatterns = "/api/*", loadOnStartup = 1)
public class ApiServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        Map<String, Object> body = new LinkedHashMap<>();

        switch (path) {
            case "/":
            case "/health":
                body.put("status", "UP");
                body.put("server", getServletContext().getServerInfo());
                body.put("app", getServletContext().getInitParameter("appName"));
                body.put("env", getServletContext().getInitParameter("environment"));
                body.put("timestamp", Instant.now().toString());
                break;

            case "/echo":
                body.put("method", req.getMethod());
                body.put("path", req.getRequestURI());
                body.put("query", req.getQueryString());
                body.put("headers", Json.headersOf(req));
                break;

            case "/stats":
                body.putAll(DashboardServlet.buildStats(req));
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
        }

        resp.setStatus(HttpServletResponse.SC_OK);
        resp.setContentType("application/json;charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(Json.toJson(body));
    }
}
