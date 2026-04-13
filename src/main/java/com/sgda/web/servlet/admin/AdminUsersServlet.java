package com.sgda.web.servlet.admin;

import com.sgda.domain.Role;
import com.sgda.domain.Utilisateur;
import com.sgda.service.UtilisateurService;
import com.sgda.web.servlet.BaseServlet;
import com.sgda.web.util.ServletUtils;
import java.io.IOException;
import java.util.List;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminUsersServlet", urlPatterns = {"/admin/users"})
public class AdminUsersServlet extends BaseServlet {

    @Inject
    private UtilisateurService utilisateurService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Utilisateur> utilisateurs = utilisateurService.listAllUsers();
        List<Role> roles = utilisateurService.listRolesActifs();
        request.setAttribute("utilisateurs", utilisateurs);
        request.setAttribute("roles", roles);

        Long editId = ServletUtils.paramAsLong(request, "id");
        if (editId != null) {
            Utilisateur utilisateur = utilisateurService.findUserForEdition(editId);
            request.setAttribute("editUser", utilisateur);
        }
        exposeFlash(request);
        forward(request, response, "/WEB-INF/views/admin/users.jsp");
    }
}

