package com.sgda.web.servlet.student;

import com.sgda.domain.Demande;
import com.sgda.service.DemandeService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.web.servlet.BaseServlet;
import java.io.IOException;
import java.util.List;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "StudentDemandesServlet", urlPatterns = {"/student/demandes"})
public class StudentDemandesServlet extends BaseServlet {

    @Inject
    private DemandeService demandeService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        List<Demande> demandes = demandeService.listByEtudiant(user.getId());
        request.setAttribute("demandes", demandes);
        exposeFlash(request);
        forward(request, response, "/WEB-INF/views/student/demandes.jsp");
    }
}

