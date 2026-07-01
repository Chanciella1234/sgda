package com.sgda.web.servlet.agent;

import com.sgda.domain.Demande;
import com.sgda.service.DemandeService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.web.servlet.BaseServlet;
import com.sgda.web.util.ServletUtils;
import java.io.IOException;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AgentDemandeDetailServlet", urlPatterns = {"/agent/demande/detail"})
public class AgentDemandeDetailServlet extends BaseServlet {

    @Inject
    private DemandeService demandeService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        Long demandeId = ServletUtils.paramAsLong(request, "id");
        Demande demande = demandeService.findDetailForUser(demandeId, user.getId());

        String source = ServletUtils.param(request, "source");
        String backPath = "traitees".equals(source) ? "/agent/demandes-traitees" : "/agent/demandes";
        request.setAttribute("demande", demande);
        request.setAttribute("roleBasePath", "/agent");
        request.setAttribute("backPath", backPath);
        exposeFlash(request);
        forward(request, response, "/WEB-INF/views/common/demande-detail.jsp");
    }
}

