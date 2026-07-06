package com.example.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet that serves as the entry point for the standalone Angular landing preview.
 * It redirects requests from /preview-landing to /preview-landing/browser/ to ensure
 * relative asset paths resolve correctly.
 */
@WebServlet(name = "LandingPreviewServlet", urlPatterns = "/preview-landing", loadOnStartup = 1)
public class LandingPreviewServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String contextPath = req.getContextPath();
        String queryString = req.getQueryString();
        String redirectUrl = contextPath + "/preview-landing/browser/";
        if (queryString != null && !queryString.isEmpty()) {
            redirectUrl += "?" + queryString;
        }
        resp.sendRedirect(redirectUrl);
    }
}
