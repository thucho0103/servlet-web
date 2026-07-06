package com.example.web.listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Logs application lifecycle events so deployment health is visible
 * in WebOTX's server.log.
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    private static final Logger log = LoggerFactory.getLogger(AppContextListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        log.info("Application started: {} on {} (env={})",
                ctx.getInitParameter("appName"),
                ctx.getServerInfo(),
                ctx.getInitParameter("environment"));
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        log.info("Application stopped: {}", sce.getServletContext().getContextPath());
    }
}
