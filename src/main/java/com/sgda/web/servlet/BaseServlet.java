package com.sgda.web.servlet;

import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.web.util.SessionKeys;
import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public abstract class BaseServlet extends HttpServlet {

    protected AuthenticatedUser getAuthenticatedUser(HttpServletRequest request) {
        return (AuthenticatedUser) request.getSession().getAttribute(SessionKeys.AUTH_USER);
    }

    protected void forward(HttpServletRequest request, HttpServletResponse response, String jsp)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher(jsp);
        dispatcher.forward(request, response);
    }

    protected void redirect(HttpServletRequest request, HttpServletResponse response, String path)
            throws IOException {
        response.sendRedirect(request.getContextPath() + path);
    }

    protected void setFlash(HttpServletRequest request, String type, String message) {
        request.getSession().setAttribute("FLASH_TYPE", type);
        request.getSession().setAttribute("FLASH_MESSAGE", message);
    }

    protected void exposeFlash(HttpServletRequest request) {
        Object type = request.getSession().getAttribute("FLASH_TYPE");
        Object message = request.getSession().getAttribute("FLASH_MESSAGE");
        if (type != null && message != null) {
            request.setAttribute("flashType", type);
            request.setAttribute("flashMessage", message);
            request.getSession().removeAttribute("FLASH_TYPE");
            request.getSession().removeAttribute("FLASH_MESSAGE");
        }
    }
}

