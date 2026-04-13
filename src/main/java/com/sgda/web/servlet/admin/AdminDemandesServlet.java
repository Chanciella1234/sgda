package com.sgda.web.servlet.admin;

import com.sgda.domain.Demande;
import com.sgda.service.DemandeService;
import com.sgda.web.servlet.BaseServlet;
import java.io.IOException;
import java.util.List;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminDemandesServlet", urlPatterns = {"/admin/demandes"})
public class AdminDemandesServlet extends BaseServlet {

    @Inject
    private DemandeService demandeService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Demande> demandes = demandeService.listAllDemandes();
        request.setAttribute("demandes", demandes);
        exposeFlash(request);
        forward(request, response, "/WEB-INF/views/admin/demandes.jsp");
    }
}

