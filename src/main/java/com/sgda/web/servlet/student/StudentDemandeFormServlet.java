package com.sgda.web.servlet.student;

import com.sgda.domain.Demande;
import com.sgda.domain.TypeDemande;
import com.sgda.service.DemandeService;
import com.sgda.service.TypeDemandeService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.web.servlet.BaseServlet;
import com.sgda.web.util.ServletUtils;
import java.io.IOException;
import java.util.List;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "StudentDemandeFormServlet", urlPatterns = {"/student/demande/new", "/student/demande/edit"})
public class StudentDemandeFormServlet extends BaseServlet {

    @Inject
    private DemandeService demandeService;

    @Inject
    private TypeDemandeService typeDemandeService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        List<TypeDemande> types = typeDemandeService.listActiveTypes();
        request.setAttribute("types", types);
        exposeFlash(request);

        if (request.getRequestURI().endsWith("/edit")) {
            Long demandeId = ServletUtils.paramAsLong(request, "id");
            if (demandeId != null) {
                Demande demande = demandeService.findDraftOwnedByStudent(demandeId, user.getId());
                request.setAttribute("demande", demande);
                request.setAttribute("editId", demande.getId());
            }
        }

        forward(request, response, "/WEB-INF/views/student/demande-form.jsp");
    }
}

