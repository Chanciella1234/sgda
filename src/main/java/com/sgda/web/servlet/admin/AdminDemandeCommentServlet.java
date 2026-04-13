package com.sgda.web.servlet.admin;

import com.sgda.service.DemandeService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.service.exception.BusinessException;
import com.sgda.web.servlet.BaseServlet;
import com.sgda.web.util.ServletUtils;
import java.io.IOException;
import jakarta.inject.Inject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminDemandeCommentServlet", urlPatterns = {"/admin/demande/comment"})
public class AdminDemandeCommentServlet extends BaseServlet {

    @Inject
    private DemandeService demandeService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        Long demandeId = ServletUtils.paramAsLong(request, "demandeId");
        String contenu = ServletUtils.param(request, "contenu");

        try {
            demandeService.ajouterCommentaire(demandeId, user.getId(), contenu);
            setFlash(request, "success", "Commentaire ajoute.");
        } catch (BusinessException ex) {
            setFlash(request, "error", ex.getMessage());
        }
        redirect(request, response, "/admin/demande/detail?id=" + demandeId);
    }
}

