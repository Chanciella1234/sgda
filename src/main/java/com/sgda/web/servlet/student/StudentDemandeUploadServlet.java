package com.sgda.web.servlet.student;

import com.sgda.service.DemandeService;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.service.exception.BusinessException;
import com.sgda.web.servlet.BaseServlet;
import com.sgda.web.util.StoredFileInfo;
import com.sgda.web.util.ServletUtils;
import com.sgda.web.util.UploadUtils;
import java.io.IOException;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet(name = "StudentDemandeUploadServlet", urlPatterns = {"/student/demande/upload"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 10 * 1024 * 1024L, maxRequestSize = 12 * 1024 * 1024L)
public class StudentDemandeUploadServlet extends BaseServlet {

    @Inject
    private DemandeService demandeService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        AuthenticatedUser user = getAuthenticatedUser(request);
        Long demandeId = ServletUtils.paramAsLong(request, "demandeId");
        StoredFileInfo storedFileInfo = null;

        try {
            Part fichier = request.getPart("fichier");
            storedFileInfo = UploadUtils.storePart(getServletContext(), fichier);
            demandeService.ajouterPieceJointe(
                    demandeId,
                    user.getId(),
                    storedFileInfo.getOriginalFilename(),
                    storedFileInfo.getMimeType(),
                    storedFileInfo.getSize(),
                    storedFileInfo.getStoragePath(),
                    storedFileInfo.getSha256());
            setFlash(request, "success", "Piece jointe ajoutee.");
        } catch (BusinessException | IOException | ServletException ex) {
            if (storedFileInfo != null) {
                UploadUtils.deleteQuietly(storedFileInfo.getStoragePath());
            }
            setFlash(request, "error", ex.getMessage());
        }
        redirect(request, response, "/student/demande/detail?id=" + demandeId);
    }
}

