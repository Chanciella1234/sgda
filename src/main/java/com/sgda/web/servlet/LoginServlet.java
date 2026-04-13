package com.sgda.web.servlet;

import com.sgda.service.AuthService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.service.exception.BusinessException;
import com.sgda.web.util.SessionKeys;
import com.sgda.web.util.ServletUtils;
import java.io.IOException;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends BaseServlet {

    @Inject
    private AuthService authService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        exposeFlash(request);
        forward(request, response, "/WEB-INF/views/auth/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String login = ServletUtils.param(request, "login");
        String password = ServletUtils.param(request, "password");

        try {
            AuthenticatedUser user = authService.authenticate(login, password);
            request.getSession().setAttribute(SessionKeys.AUTH_USER, user);

            if ("ADMIN".equals(user.getRoleCode())) {
                redirect(request, response, "/admin/demandes");
                return;
            }
            if ("AGENT".equals(user.getRoleCode())) {
                redirect(request, response, "/agent/demandes");
                return;
            }
            redirect(request, response, "/student/demandes");
        } catch (BusinessException ex) {
            request.setAttribute("error", ex.getMessage());
            forward(request, response, "/WEB-INF/views/auth/login.jsp");
        } catch (Exception ex) {
            request.setAttribute("error", buildTechnicalErrorMessage(ex));
            forward(request, response, "/WEB-INF/views/auth/login.jsp");
        }
    }

    private String buildTechnicalErrorMessage(Exception ex) {
        Throwable rootCause = ex;
        while (rootCause.getCause() != null && rootCause.getCause() != rootCause) {
            rootCause = rootCause.getCause();
        }

        StringBuilder builder = new StringBuilder("Erreur technique pendant la connexion : ");
        builder.append(ex.getClass().getSimpleName());

        if (rootCause != ex) {
            builder.append(" | cause racine: ").append(rootCause.getClass().getSimpleName());
        }

        String message = rootCause.getMessage();
        if (message != null && !message.isBlank()) {
            builder.append(" - ").append(message);
        }

        return builder.toString();
    }
}

