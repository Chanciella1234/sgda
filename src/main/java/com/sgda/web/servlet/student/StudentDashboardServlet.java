package com.sgda.web.servlet.student;

import com.sgda.service.DashboardService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.service.dto.StudentDashboardData;
import com.sgda.web.servlet.BaseServlet;
import java.io.IOException;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/student/dashboard"})
public class StudentDashboardServlet extends BaseServlet {

    @Inject
    private DashboardService dashboardService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        StudentDashboardData dashboard = dashboardService.getStudentDashboard(user.getId());
        request.setAttribute("dashboard", dashboard);
        exposeFlash(request);
        forward(request, response, "/WEB-INF/views/student/dashboard.jsp");
    }
}
