package com.sgda.web.servlet.agent;

import com.sgda.service.DashboardService;
import com.sgda.service.dto.AgentDashboardData;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.web.servlet.BaseServlet;
import java.io.IOException;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AgentDashboardServlet", urlPatterns = {"/agent/dashboard"})
public class AgentDashboardServlet extends BaseServlet {

    @Inject
    private DashboardService dashboardService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        AgentDashboardData dashboard = dashboardService.getAgentDashboard(user.getId());
        request.setAttribute("dashboard", dashboard);
        exposeFlash(request);
        forward(request, response, "/WEB-INF/views/agent/dashboard.jsp");
    }
}
