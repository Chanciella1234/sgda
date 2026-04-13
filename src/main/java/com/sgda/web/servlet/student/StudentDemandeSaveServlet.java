package com.sgda.web.servlet.student;

import com.sgda.domain.Demande;
import com.sgda.service.DemandeService;
import com.sgda.service.TypeDemandeService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.service.exception.BusinessException;
import com.sgda.web.servlet.BaseServlet;
import com.sgda.web.util.ServletUtils;
import java.io.IOException;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "StudentDemandeSaveServlet", urlPatterns = {"/student/demande/save"})
public class StudentDemandeSaveServlet extends BaseServlet {

    @Inject
    private DemandeService demandeService;

    @Inject
    private TypeDemandeService typeDemandeService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        Long demandeId = ServletUtils.paramAsLong(request, "id");
        Long typeDemandeId = ServletUtils.paramAsLong(request, "typeDemandeId");
        String objet = ServletUtils.param(request, "objet");
        String description = ServletUtils.param(request, "description");

        try {
            if (demandeId == null) {
                Demande demande = demandeService.createDraft(user.getId(), typeDemandeId, objet, description);
                setFlash(request, "success", "Demande en brouillon creee : " + demande.getCode());
            } else {
                demandeService.updateDraft(demandeId, user.getId(), typeDemandeId, objet, description);
                setFlash(request, "success", "Brouillon mis a jour.");
            }
            redirect(request, response, "/student/demandes");
        } catch (BusinessException ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("objet", objet);
            request.setAttribute("description", description);
            request.setAttribute("typeDemandeId", typeDemandeId);
            request.setAttribute("types", typeDemandeService.listActiveTypes());
            request.setAttribute("editId", demandeId);
            forward(request, response, "/WEB-INF/views/student/demande-form.jsp");
        }
    }
}

