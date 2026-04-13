package com.sgda.web.servlet.admin;

import com.sgda.service.TypeDemandeService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.service.exception.BusinessException;
import com.sgda.web.servlet.BaseServlet;
import com.sgda.web.util.ServletUtils;
import java.io.IOException;
import jakarta.inject.Inject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminTypeSaveServlet", urlPatterns = {"/admin/type/save"})
public class AdminTypeSaveServlet extends BaseServlet {

    @Inject
    private TypeDemandeService typeDemandeService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        AuthenticatedUser admin = getAuthenticatedUser(request);
        Long id = ServletUtils.paramAsLong(request, "id");
        String code = ServletUtils.param(request, "code");
        String libelle = ServletUtils.param(request, "libelle");
        String description = ServletUtils.param(request, "description");
        boolean actif = "on".equalsIgnoreCase(ServletUtils.param(request, "actif"));

        try {
            if (id == null) {
                typeDemandeService.createType(admin.getId(), code, libelle, description);
                setFlash(request, "success", "Type de demande cree.");
            } else {
                typeDemandeService.updateType(admin.getId(), id, code, libelle, description, actif);
                setFlash(request, "success", "Type de demande mis a jour.");
            }
        } catch (BusinessException ex) {
            setFlash(request, "error", ex.getMessage());
        }
        redirect(request, response, "/admin/types");
    }
}

