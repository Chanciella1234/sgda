package com.sgda.web.servlet;

import com.sgda.web.util.SessionKeys;
import java.io.IOException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.getSession().removeAttribute(SessionKeys.AUTH_USER);
        request.getSession().invalidate();
        redirect(request, response, "/login");
    }
}

