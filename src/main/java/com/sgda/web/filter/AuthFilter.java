package com.sgda.web.filter;

import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.web.util.SessionKeys;
import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/student/*", "/agent/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        AuthenticatedUser user = (AuthenticatedUser) httpRequest.getSession()
                .getAttribute(SessionKeys.AUTH_USER);

        if (user == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        if (path.startsWith("/student") && !"ETUDIANT".equals(user.getRoleCode())) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }
        if (path.startsWith("/agent") && !"AGENT".equals(user.getRoleCode())) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }
        if (path.startsWith("/admin") && !"ADMIN".equals(user.getRoleCode())) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}

