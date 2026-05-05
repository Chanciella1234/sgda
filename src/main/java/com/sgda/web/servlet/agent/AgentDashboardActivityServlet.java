package com.sgda.web.servlet.agent;

import com.sgda.service.DashboardService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.service.dto.ChartSeriesData;
import com.sgda.web.servlet.BaseServlet;
import com.sgda.web.util.JsonUtils;
import java.io.IOException;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AgentDashboardActivityServlet", urlPatterns = {"/agent/dashboard/activity"})
public class AgentDashboardActivityServlet extends BaseServlet {

    @Inject
    private DashboardService dashboardService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        String range = request.getParameter("range");
        ChartSeriesData data = dashboardService.getAgentActivityData(user.getId(), range);
        writeJson(response, JsonUtils.toJson(data));
    }
}
