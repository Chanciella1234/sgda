package com.sgda.web.util;

import jakarta.servlet.http.HttpServletRequest;

public final class ServletUtils {

    private ServletUtils() {
    }

    public static String param(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? null : value.trim();
    }

    public static Long paramAsLong(HttpServletRequest request, String name) {
        String value = param(request, name);
        if (value == null || value.isEmpty()) {
            return null;
        }
        return Long.parseLong(value);
    }

    public static String joinPath(String contextPath, String path) {
        if (contextPath == null) {
            contextPath = "";
        }
        return contextPath + (path.startsWith("/") ? path : "/" + path);
    }
}

