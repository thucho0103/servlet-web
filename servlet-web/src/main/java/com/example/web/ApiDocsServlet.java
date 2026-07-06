package com.example.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Serves the human-readable API documentation page at {@code /api-docs}.
 * The actual API lives on {@link ApiServlet}; this is a thin read-only view.
 */
@WebServlet(name = "ApiDocsServlet", urlPatterns = "/api-docs", loadOnStartup = 1)
public class ApiDocsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/api-docs.jsp").forward(req, resp);
    }
}
