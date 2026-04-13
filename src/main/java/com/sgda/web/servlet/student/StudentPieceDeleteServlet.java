package com.sgda.web.servlet.student;

import com.sgda.service.DemandeService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.service.exception.BusinessException;
import com.sgda.web.servlet.BaseServlet;
import com.sgda.web.util.ServletUtils;
import com.sgda.web.util.UploadUtils;
import java.io.IOException;
import jakarta.inject.Inject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "StudentPieceDeleteServlet", urlPatterns = {"/student/piece/delete"})
public class StudentPieceDeleteServlet extends BaseServlet {

    @Inject
    private DemandeService demandeService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        Long pieceId = ServletUtils.paramAsLong(request, "id");
        Long demandeId = ServletUtils.paramAsLong(request, "demandeId");

        try {
            String storagePath = demandeService.supprimerPieceJointe(pieceId, user.getId());
            UploadUtils.deleteQuietly(storagePath);
            setFlash(request, "success", "Piece jointe supprimee.");
        } catch (BusinessException ex) {
            setFlash(request, "error", ex.getMessage());
        }
        redirect(request, response, "/student/demande/detail?id=" + demandeId);
    }
}

