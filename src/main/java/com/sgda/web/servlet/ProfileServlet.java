package com.sgda.web.servlet;

import com.sgda.domain.Utilisateur;
import com.sgda.service.UtilisateurService;
import com.sgda.service.dto.AuthenticatedUser;
import java.io.IOException;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/student/profil", "/agent/profil", "/admin/profil"})
public class ProfileServlet extends BaseServlet {

    @Inject
    private UtilisateurService utilisateurService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthenticatedUser authUser = getAuthenticatedUser(request);
        Utilisateur utilisateur = utilisateurService.findById(authUser.getId());
        request.setAttribute("profil", utilisateur);
        exposeFlash(request);
        forward(request, response, "/WEB-INF/views/common/profil.jsp");
    }
}
