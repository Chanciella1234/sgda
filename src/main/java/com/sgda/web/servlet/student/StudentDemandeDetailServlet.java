package com.sgda.web.servlet.student;

import com.sgda.domain.Demande;
import com.sgda.service.DemandeService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.web.servlet.BaseServlet;
import com.sgda.web.util.ServletUtils;
import java.io.IOException;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "StudentDemandeDetailServlet", urlPatterns = {"/student/demande/detail"})
public class StudentDemandeDetailServlet extends BaseServlet {

    @Inject
    private DemandeService demandeService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        Long demandeId = ServletUtils.paramAsLong(request, "id");
        Demande demande = demandeService.findDetailForUser(demandeId, user.getId());

        request.setAttribute("demande", demande);
        request.setAttribute("roleBasePath", "/student");
        request.setAttribute("backPath", "/student/demandes");
        exposeFlash(request);
        forward(request, response, "/WEB-INF/views/common/demande-detail.jsp");
    }
}

