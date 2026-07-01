package com.sgda.service.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public final class PasswordUtils {

    private static final SecureRandom SECURE_RANDOM = new SecureRandom();
    private static final int ITERATIONS = 65536;
    private static final int SALT_LENGTH = 16;
    private static final int KEY_LENGTH = 256;
    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";

    private PasswordUtils() {
    }

    public static String hashPassword(String plainPassword) {
        byte[] salt = new byte[SALT_LENGTH];
        SECURE_RANDOM.nextBytes(salt);
        byte[] hash = pbkdf2(plainPassword.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
        return ITERATIONS + ":" + Base64.getEncoder().encodeToString(salt)
                + ":" + Base64.getEncoder().encodeToString(hash);
    }

    public static boolean verifyPassword(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null) {
            return false;
        }

        if (!isHashedFormat(storedHash)) {
            return plainPassword.equals(storedHash);
        }

        String[] parts = storedHash.split(":");
        if (parts.length != 3) {
            return false;
        }

        int iterations = Integer.parseInt(parts[0]);
        byte[] salt = Base64.getDecoder().decode(parts[1].getBytes(StandardCharsets.UTF_8));
        byte[] expected = Base64.getDecoder().decode(parts[2].getBytes(StandardCharsets.UTF_8));
        byte[] actual = pbkdf2(plainPassword.toCharArray(), salt, iterations, expected.length * 8);
        return MessageDigest.isEqual(expected, actual);
    }

    public static boolean needsRehash(String storedHash) {
        return storedHash != null && !isHashedFormat(storedHash);
    }

    private static boolean isHashedFormat(String storedHash) {
        return storedHash != null && storedHash.contains(":");
    }

    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations, int keyLength) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, keyLength);
            return SecretKeyFactory.getInstance(ALGORITHM).generateSecret(spec).getEncoded();
        } catch (Exception e) {
            throw new IllegalStateException("Impossible de securiser le mot de passe.", e);
        }
    }
}
