package com.sgda.web.servlet.admin;

import com.sgda.domain.TypeDemande;
import com.sgda.service.TypeDemandeService;
import com.sgda.web.servlet.BaseServlet;
import com.sgda.web.util.ServletUtils;
import java.io.IOException;
import java.util.List;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminTypesServlet", urlPatterns = {"/admin/types"})
public class AdminTypesServlet extends BaseServlet {

    @Inject
    private TypeDemandeService typeDemandeService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<TypeDemande> types = typeDemandeService.listAllTypes();
        request.setAttribute("types", types);

        Long editId = ServletUtils.paramAsLong(request, "id");
        if (editId != null) {
            TypeDemande typeDemande = typeDemandeService.findById(editId);
            request.setAttribute("editType", typeDemande);
        }
        exposeFlash(request);
        forward(request, response, "/WEB-INF/views/admin/types.jsp");
    }
}

