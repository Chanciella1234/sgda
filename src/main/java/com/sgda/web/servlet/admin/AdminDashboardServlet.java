package com.sgda.web.servlet.admin;

import com.sgda.service.DashboardService;
import com.sgda.service.dto.AdminDashboardData;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.web.servlet.BaseServlet;
import java.io.IOException;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends BaseServlet {

    @Inject
    private DashboardService dashboardService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        AdminDashboardData dashboard = dashboardService.getAdminDashboard(user.getId());
        request.setAttribute("dashboard", dashboard);
        exposeFlash(request);
        forward(request, response, "/WEB-INF/views/admin/dashboard.jsp");
    }
}
