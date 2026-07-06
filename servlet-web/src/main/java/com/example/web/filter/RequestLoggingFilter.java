package com.example.web.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Per-request access log. Useful for verifying deployment on WebOTX.
 */
@WebFilter(filterName = "requestLoggingFilter", urlPatterns = "/*")
public class RequestLoggingFilter implements Filter {

    private static final Logger log = LoggerFactory.getLogger(RequestLoggingFilter.class);

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        long start = System.nanoTime();
        try {
            chain.doFilter(req, resp);
        } finally {
            if (req instanceof HttpServletRequest httpReq
                    && resp instanceof HttpServletResponse httpResp) {
                long ms = (System.nanoTime() - start) / 1_000_000;
                log.info("{} {} -> {} ({} ms)",
                        httpReq.getMethod(),
                        httpReq.getRequestURI(),
                        httpResp.getStatus(),
                        ms);
            }
        }
    }
}
