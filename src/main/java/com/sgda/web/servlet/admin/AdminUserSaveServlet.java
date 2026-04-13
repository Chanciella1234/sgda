package com.sgda.web.servlet.admin;

import com.sgda.service.UtilisateurService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.service.exception.BusinessException;
import com.sgda.web.servlet.BaseServlet;
import com.sgda.web.util.ServletUtils;
import java.io.IOException;
import jakarta.inject.Inject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminUserSaveServlet", urlPatterns = {"/admin/user/save"})
public class AdminUserSaveServlet extends BaseServlet {

    @Inject
    private UtilisateurService utilisateurService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        AuthenticatedUser admin = getAuthenticatedUser(request);
        Long id = ServletUtils.paramAsLong(request, "id");
        Long roleId = ServletUtils.paramAsLong(request, "roleId");
        String username = ServletUtils.param(request, "username");
        String email = ServletUtils.param(request, "email");
        String password = ServletUtils.param(request, "password");
        String nom = ServletUtils.param(request, "nom");
        String prenom = ServletUtils.param(request, "prenom");
        boolean actif = "on".equalsIgnoreCase(ServletUtils.param(request, "actif"));

        try {
            if (id == null) {
                utilisateurService.createUser(admin.getId(), roleId, username, email, password, nom, prenom);
                setFlash(request, "success", "Utilisateur cree.");
            } else {
                utilisateurService.updateUser(admin.getId(), id, roleId, username, email, password, nom, prenom, actif);
                setFlash(request, "success", "Utilisateur mis a jour.");
            }
        } catch (BusinessException ex) {
            setFlash(request, "error", ex.getMessage());
        }
        redirect(request, response, "/admin/users");
    }
}

