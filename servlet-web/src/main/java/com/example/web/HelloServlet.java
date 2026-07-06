package com.example.web;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

/**
 * Sample servlet demonstrating the lifecycle, init-params,
 * request handling and JSP forwarding on WebOTX.
 */
@WebServlet(
        name = "HelloServlet",
        urlPatterns = "/hello",
        loadOnStartup = 1,
        initParams = @WebInitParam(name = "defaultGreeting", value = "Xin chào từ WebOTX")
)
public class HelloServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger log = LoggerFactory.getLogger(HelloServlet.class);
    private static final DateTimeFormatter TS_FMT =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").withZone(ZoneId.systemDefault());

    private String greeting;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        this.greeting = config.getInitParameter("defaultGreeting");
        if (this.greeting == null || this.greeting.isBlank()) {
            this.greeting = "Hello";
        }
        log.info("HelloServlet initialized with greeting='{}'", greeting);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String name = req.getParameter("name");
        if (name == null || name.isBlank()) {
            name = "World";
        }

        req.setAttribute("greeting", greeting);
        req.setAttribute("name", name);
        req.setAttribute("serverInfo", getServletContext().getServerInfo());
        req.setAttribute("timestamp", TS_FMT.format(Instant.now()));
        req.setAttribute("servletName", getServletName());

        req.getRequestDispatcher("/WEB-INF/views/hello.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    public void destroy() {
        log.info("HelloServlet destroyed");
        super.destroy();
    }
}
