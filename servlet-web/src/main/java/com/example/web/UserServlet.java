package com.example.web;

import com.example.web.model.User;
import com.example.web.util.Json;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

/**
 * CRUD-style servlet that keeps an in-memory user list, then
 * exposes it as both an HTML view (via JSP) and a JSON response.
 */
@WebServlet(name = "UserServlet", urlPatterns = "/users", loadOnStartup = 1)
public class UserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String VIEW_LIST = "/WEB-INF/views/users/list.jsp";
    private static final String VIEW_FORM = "/WEB-INF/views/users/form.jsp";

    private final Map<String, User> store = new ConcurrentHashMap<>();
    private static volatile UserServlet INSTANCE;

    @Override
    public void init(jakarta.servlet.ServletConfig config) throws jakarta.servlet.ServletException {
        super.init(config);
        INSTANCE = this;
        create("admin",  "admin@example.com", "Administrator");
        create("thucduy", "thucduy@example.com", "Thuc Duy");
    }

    private User create(String username, String email, String displayName) {
        User u = new User(UUID.randomUUID().toString(), username, email, displayName);
        store.put(u.getId(), u);
        DashboardServlet.CREATE_COUNT.incrementAndGet();
        return u;
    }

    /** Snapshot size of the user store. Used by the dashboard. */
    public static int snapshotSize() {
        UserServlet me = INSTANCE;
        return me == null ? 0 : me.store.size();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = trimToPath(req.getPathInfo());

        if (path.isEmpty() || "/".equals(path)) {
            Collection<User> all = new ArrayList<>(store.values());
            req.setAttribute("users", all);

            if ("json".equalsIgnoreCase(req.getParameter("format"))) {
                writeJson(resp, Json.toJson(all));
                return;
            }
            req.getRequestDispatcher(VIEW_LIST).forward(req, resp);
            return;
        }

        String id = path.substring(1);
        Optional<User> found = Optional.ofNullable(store.get(id));
        if (found.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "User " + id + " not found");
            return;
        }

        req.setAttribute("user", found.get());
        req.setAttribute("jsonView", Json.toJson(found.get()));
        if ("json".equalsIgnoreCase(req.getParameter("format"))) {
            writeJson(resp, Json.toJson(found.get()));
            return;
        }
        req.getRequestDispatcher(VIEW_FORM).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = trimToPath(req.getPathInfo());

        // POST /users/{id} -> update existing user (form-based edit)
        if (!path.isEmpty() && !"/".equals(path)) {
            String id = path.substring(1);
            User u = store.get(id);
            if (u == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
            applyFormUpdate(u, req);
            resp.sendRedirect(req.getContextPath() + "/users/" + id);
            return;
        }

        // POST /users -> create new user
        String username    = trim(req.getParameter("username"));
        String email       = trim(req.getParameter("email"));
        String displayName = trim(req.getParameter("displayName"));

        if (username == null || email == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "username and email are required");
            return;
        }

        User u = create(username, email, displayName == null ? username : displayName);

        resp.setStatus(HttpServletResponse.SC_CREATED);
        resp.setHeader("Location", req.getContextPath() + "/users/" + u.getId());

        if (wantsJson(req)) {
            writeJson(resp, Json.toJson(u));
        } else {
            resp.sendRedirect(req.getContextPath() + "/users/" + u.getId());
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = trimToPath(req.getPathInfo());
        if (path.isEmpty() || "/".equals(path)) {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }
        String id = path.substring(1);
        User u = store.get(id);
        if (u == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Map<String, String> body = Json.readFormOrJson(req);
        if (body.containsKey("email"))       u.setEmail(body.get("email"));
        if (body.containsKey("displayName")) u.setDisplayName(body.get("displayName"));
        store.put(id, u);

        writeJson(resp, Json.toJson(u));
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = trimToPath(req.getPathInfo());
        if (path.isEmpty() || "/".equals(path)) {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }
        String id = path.substring(1);
        User removed = store.remove(id);
        if (removed == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
    }

    private void applyFormUpdate(User u, HttpServletRequest req) {
        String email       = trim(req.getParameter("email"));
        String displayName = trim(req.getParameter("displayName"));
        if (email != null)       u.setEmail(email);
        if (displayName != null) u.setDisplayName(displayName);
        store.put(u.getId(), u);
    }

    private static String trimToPath(String pathInfo) {
        return pathInfo == null ? "" : pathInfo.trim();
    }

    private static String trim(String s) {
        return s == null ? null : s.trim();
    }

    private static boolean wantsJson(HttpServletRequest req) {
        String accept = req.getHeader("Accept");
        return accept != null && accept.toLowerCase().contains("application/json");
    }

    private static void writeJson(HttpServletResponse resp, String body) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(body);
    }
}
