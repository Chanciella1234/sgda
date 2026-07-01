package com.sgda.web.servlet.student;

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

@WebServlet(name = "StudentDemandeDeleteServlet", urlPatterns = {"/student/demande/delete"})
public class StudentDemandeDeleteServlet extends BaseServlet {

    @Inject
    private DemandeService demandeService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        Long demandeId = ServletUtils.paramAsLong(request, "id");

        try {
            demandeService.deleteDraft(demandeId, user.getId());
            setFlash(request, "success", "Brouillon supprime.");
        } catch (BusinessException ex) {
            setFlash(request, "error", ex.getMessage());
        }
        redirect(request, response, "/student/demandes");
    }
}

