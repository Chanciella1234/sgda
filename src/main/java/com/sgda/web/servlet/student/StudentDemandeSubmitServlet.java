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

@WebServlet(name = "StudentDemandeSubmitServlet", urlPatterns = {"/student/demande/submit"})
public class StudentDemandeSubmitServlet extends BaseServlet {

    @Inject
    private DemandeService demandeService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        Long demandeId = ServletUtils.paramAsLong(request, "id");

        try {
            demandeService.soumettre(demandeId, user.getId());
            setFlash(request, "success", "Demande soumise a l administration.");
        } catch (BusinessException ex) {
            setFlash(request, "error", ex.getMessage());
        }
        redirect(request, response, "/student/demandes");
    }
}

