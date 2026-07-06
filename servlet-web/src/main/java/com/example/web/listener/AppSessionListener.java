package com.example.web.listener;

import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * Tracks live session count. Useful for verifying that WebOTX
 * is distributing requests across the configured cluster.
 */
@WebListener
public class AppSessionListener implements HttpSessionListener {

    private static final Logger log = LoggerFactory.getLogger(AppSessionListener.class);
    private static final AtomicInteger ACTIVE = new AtomicInteger();

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        int n = ACTIVE.incrementAndGet();
        log.info("Session created ({}): id={}", n, se.getSession().getId());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        int n = ACTIVE.decrementAndGet();
        log.info("Session destroyed ({}): id={}", n, se.getSession().getId());
    }

    public static int active() { return ACTIVE.get(); }
}
