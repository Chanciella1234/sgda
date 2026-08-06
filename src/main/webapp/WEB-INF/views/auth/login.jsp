<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="/WEB-INF/views/common/i18n.jsp" %>
<!DOCTYPE html>
<html lang="${currentLang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="login.page_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<div class="login-shell-simple">

    <div class="theme-toggle-login" aria-hidden="false">
        <button id="loginThemeToggle" type="button" class="theme-toggle-btn" aria-label="<fmt:message key='login.darkmode.aria'/>">
            <span class="theme-toggle-icon" id="loginThemeToggleIcon">🌙</span>
        </button>
    </div>

    <div class="login-simple-card">

        <a href="${pageContext.request.contextPath}/" class="login-simple-back">
            <span class="login-simple-back-icon">←</span>
            <fmt:message key="login.back.home"/>
        </a>

        <div class="login-simple-brand">
            <div class="login-simple-logo">SG</div>
            <div class="login-simple-brand-text">
                <strong>SGDA</strong>
                <span><fmt:message key="app.brand.meta"/></span>
            </div>
        </div>

        <div class="login-simple-header">
            <h2 class="login-simple-title"><fmt:message key="login.card.title"/></h2>
            <p class="login-simple-subtitle"><fmt:message key="login.card.subtitle"/></p>
        </div>

        <jsp:include page="/WEB-INF/views/common/flash.jsp"/>

        <form class="login-form auth-form" method="post" action="${pageContext.request.contextPath}/login">
            <div class="auth-field">
                <label for="login"><fmt:message key="login.field.username"/></label>
                <div class="auth-input-shell auth-input-shell-user">
                    <span class="auth-input-icon auth-input-icon-user" aria-hidden="true"></span>
                    <input
                        id="login"
                        name="login"
                        type="text"
                        required
                        autocomplete="username"
                        autocapitalize="none"
                        spellcheck="false"
                        placeholder="<fmt:message key='login.field.username.placeholder'/>"
                    >
                </div>
            </div>

            <div class="auth-field">
                <label for="password"><fmt:message key="login.field.password"/></label>
                <div class="auth-input-shell auth-input-shell-password">
                    <span class="auth-input-icon auth-input-icon-lock" aria-hidden="true"></span>
                    <input
                        id="password"
                        name="password"
                        type="password"
                        required
                        autocomplete="current-password"
                        placeholder="<fmt:message key='login.field.password.placeholder'/>"
                    >
                    <button
                        class="auth-password-toggle"
                        type="button"
                        data-password-toggle
                        data-target="password"
                        data-hidden-label="<fmt:message key='login.password.show'/>"
                        data-visible-label="<fmt:message key='login.password.hide'/>"
                        aria-controls="password"
                        aria-pressed="false"
                    ><fmt:message key="login.password.show"/></button>
                </div>
            </div>

            <button class="btn btn-primary auth-submit" type="submit"><fmt:message key="login.btn.submit"/></button>
        </form>
    </div>

</div>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
(function () {
    'use strict';

    document.querySelectorAll('[data-password-toggle]').forEach(function (button) {
        var targetId = button.getAttribute('data-target');
        var input = targetId ? document.getElementById(targetId) : null;

        if (!input) {
            return;
        }

        var hiddenLabel = button.getAttribute('data-hidden-label') || 'SHOW';
        var visibleLabel = button.getAttribute('data-visible-label') || 'HIDE';

        function syncState() {
            var isVisible = input.type === 'text';
            button.textContent = isVisible ? visibleLabel : hiddenLabel;
            button.setAttribute('aria-pressed', isVisible ? 'true' : 'false');
        }

        button.addEventListener('click', function () {
            input.type = input.type === 'password' ? 'text' : 'password';
            syncState();
        });

        syncState();
    });

    var loginThemeToggle = document.getElementById('loginThemeToggle');
    if (loginThemeToggle) {
        loginThemeToggle.addEventListener('click', function () {
            var current = document.documentElement.getAttribute('data-theme') || 'light';
            var next = current === 'dark' ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', next);
            try { localStorage.setItem('sgda-theme', next); } catch(e) {}
            document.dispatchEvent(new CustomEvent('sgda:themechange', { detail: { theme: next } }));
            var icon = document.getElementById('loginThemeToggleIcon');
            if (icon) icon.textContent = next === 'dark' ? '🌙' : '☀️';
        });
    }

    (function syncIcon(){
        var icon = document.getElementById('loginThemeToggleIcon');
        var theme = document.documentElement.getAttribute('data-theme') || 'light';
        if (icon) icon.textContent = theme === 'dark' ? '🌙' : '☀️';
    })();
})();
</script>
</body>
</html>
