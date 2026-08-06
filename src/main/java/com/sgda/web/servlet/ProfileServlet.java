package com.sgda.web.servlet;

import com.sgda.domain.Utilisateur;
import com.sgda.service.UtilisateurService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.service.exception.BusinessException;
import com.sgda.web.util.SessionKeys;
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthenticatedUser authUser = getAuthenticatedUser(request);

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String passwordConfirm = request.getParameter("passwordConfirm");

        try {
            if (password != null && !password.isEmpty()) {
                if (!password.equals(passwordConfirm)) {
                    throw new BusinessException("Les mots de passe ne correspondent pas.");
                }
            }
            utilisateurService.updateOwnProfile(authUser.getId(), nom, prenom, email, username, password);
            authUser.setFullName(prenom + " " + nom);
            authUser.setUsername(username);
            request.getSession().setAttribute(SessionKeys.AUTH_USER, authUser);
            setFlash(request, "success", "Vos informations ont ete mises a jour avec succes.");
            redirect(request, response, resolveBasePath(request) + "/profil");
        } catch (BusinessException e) {
            request.setAttribute("nom", nom);
            request.setAttribute("prenom", prenom);
            request.setAttribute("email", email);
            request.setAttribute("username", username);
            setFlash(request, "error", e.getMessage());
            redirect(request, response, resolveBasePath(request) + "/profil?edit=1");
        }
    }

    private String resolveBasePath(HttpServletRequest request) {
        String path = request.getServletPath();
        if (path.startsWith("/student")) return "/student";
        if (path.startsWith("/agent")) return "/agent";
        if (path.startsWith("/admin")) return "/admin";
        return "";
    }
}
