package com.sgda.web.util;

public class StoredFileInfo {

    private final String originalFilename;
    private final String mimeType;
    private final long size;
    private final String storagePath;
    private final String sha256;

    public StoredFileInfo(String originalFilename, String mimeType, long size, String storagePath, String sha256) {
        this.originalFilename = originalFilename;
        this.mimeType = mimeType;
        this.size = size;
        this.storagePath = storagePath;
        this.sha256 = sha256;
    }

    public String getOriginalFilename() {
        return originalFilename;
    }

    public String getMimeType() {
        return mimeType;
    }

    public long getSize() {
        return size;
    }

    public String getStoragePath() {
        return storagePath;
    }

    public String getSha256() {
        return sha256;
    }
}
