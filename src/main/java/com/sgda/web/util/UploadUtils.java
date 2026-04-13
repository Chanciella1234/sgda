package com.sgda.web.util;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.security.DigestInputStream;
import java.security.MessageDigest;
import java.util.UUID;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

public final class UploadUtils {

    private UploadUtils() {
    }

    public static StoredFileInfo storePart(ServletContext servletContext, Part part) throws IOException {
        if (part == null) {
            throw new IOException("Aucun fichier n a ete transmis.");
        }
        String submittedFilename = extractSubmittedFilename(part);
        if (submittedFilename == null || submittedFilename.isBlank() || part.getSize() <= 0) {
            throw new IOException("Aucun fichier valide n a ete fourni.");
        }

        Path root = resolveUploadRoot(servletContext);
        Files.createDirectories(root);

        String safeFilename = sanitizeFilename(submittedFilename);
        String storedFilename = UUID.randomUUID() + "_" + safeFilename;
        Path destination = root.resolve(storedFilename);

        MessageDigest digest;
        try {
            digest = MessageDigest.getInstance("SHA-256");
        } catch (Exception ex) {
            throw new IOException("Impossible de calculer l empreinte du fichier.", ex);
        }

        try (InputStream input = new DigestInputStream(part.getInputStream(), digest)) {
            Files.copy(input, destination, StandardCopyOption.REPLACE_EXISTING);
        }

        String sha256 = toHex(digest.digest());
        String contentType = part.getContentType();
        if (contentType == null || contentType.isBlank()) {
            contentType = "application/octet-stream";
        }

        return new StoredFileInfo(submittedFilename, contentType, part.getSize(), destination.toString(), sha256);
    }

    public static void deleteQuietly(String storagePath) {
        if (storagePath == null || storagePath.isBlank()) {
            return;
        }
        try {
            Files.deleteIfExists(Path.of(storagePath));
        } catch (IOException ignored) {
        }
    }

    private static Path resolveUploadRoot(ServletContext servletContext) {
        File tempDir = (File) servletContext.getAttribute("jakarta.servlet.context.tempdir");
        return tempDir.toPath().resolve("sgda-uploads");
    }

    private static String extractSubmittedFilename(Part part) {
        String submitted = part.getSubmittedFileName();
        if (submitted == null) {
            return null;
        }
        String normalized = submitted.replace("\\", "/");
        int lastSlash = normalized.lastIndexOf('/');
        return lastSlash >= 0 ? normalized.substring(lastSlash + 1) : normalized;
    }

    private static String sanitizeFilename(String filename) {
        return filename.replaceAll("[^a-zA-Z0-9._-]", "_");
    }

    private static String toHex(byte[] data) {
        StringBuilder builder = new StringBuilder(data.length * 2);
        for (byte value : data) {
            builder.append(String.format("%02x", value));
        }
        return builder.toString();
    }
}

