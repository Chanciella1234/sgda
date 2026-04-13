package com.sgda.web.servlet;

import com.sgda.domain.PieceJointe;
import com.sgda.service.DemandeService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.service.exception.BusinessException;
import com.sgda.web.util.ServletUtils;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import jakarta.inject.Inject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "PieceDownloadServlet", urlPatterns = {"/piece/download"})
public class PieceDownloadServlet extends BaseServlet {

    @Inject
    private DemandeService demandeService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        if (user == null) {
            redirect(request, response, "/login");
            return;
        }

        Long pieceId = ServletUtils.paramAsLong(request, "id");
        if (pieceId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Piece jointe invalide.");
            return;
        }

        try {
            PieceJointe pieceJointe = demandeService.findPieceJointeForUser(pieceId, user.getId());
            Path path = Path.of(pieceJointe.getCheminStockage());
            if (!Files.exists(path)) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Fichier introuvable.");
                return;
            }

            response.setContentType(pieceJointe.getMimeType());
            response.setContentLengthLong(pieceJointe.getTailleOctets());
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"" + pieceJointe.getNomOriginal().replace("\"", "") + "\"");
            Files.copy(path, response.getOutputStream());
        } catch (BusinessException ex) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, ex.getMessage());
        }
    }
}

