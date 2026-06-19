<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<div class="login-shell auth-shell">
    <div class="theme-toggle-login" aria-hidden="false">
        <button id="loginThemeToggle" type="button" class="theme-toggle-btn" aria-label="Basculer le mode sombre">
            <span class="theme-toggle-icon" id="loginThemeToggleIcon">🌙</span>
        </button>
    </div>
    <div class="auth-layout">
        <section class="login-aside auth-hero" aria-label="Presentation SGDA">
            <span class="auth-hero-orb auth-hero-orb-a" aria-hidden="true"></span>
            <span class="auth-hero-orb auth-hero-orb-b" aria-hidden="true"></span>
            <span class="auth-hero-orb auth-hero-orb-c" aria-hidden="true"></span>

            <div class="auth-brand-row">
                <div class="auth-brand-copy">
                    <span class="auth-brand">SGDA</span>
                    <span class="auth-brand-subtitle">Systeme de gestion des demandes academiques</span>
                </div>
                <span class="auth-brand-badge">Institutionnel</span>
            </div>

            <div class="auth-hero-copy">
                <h1 class="auth-hero-title">WELCOME</h1>
                <div class="auth-hero-kicker">Votre espace academique centralise</div>
                <p class="auth-hero-text">
                    SGDA centralise les demandes academiques dans un environnement sobre, fiable et premium.
                    Chaque action, chaque transition et chaque decision reste lisible, tracee et maitrisee.
                </p>
            </div>

            <div class="auth-hero-points">
                <div class="auth-hero-point">
                    <strong>Workflow maitrise</strong>
                    Du brouillon a la decision finale, chaque etape reste suivie et historisee.
                </div>
                <div class="auth-hero-point">
                    <strong>Acces controles</strong>
                    Etudiants, agents et administrateurs disposent d un espace adapte a leurs responsabilites.
                </div>
            </div>

            <div class="auth-hero-footer">
                <span class="auth-hero-stat">3 roles</span>
                <span class="auth-hero-stat">1 flux unique</span>
                <span class="auth-hero-stat">Tracabilite continue</span>
            </div>
        </section>

        <section class="login-card auth-card">
            <div class="auth-card-inner">
                <div class="auth-card-top">
                    <div class="page-kicker">Connexion</div>
                    <h2 class="auth-title">Sign in</h2>
                    <p class="auth-subtitle">
                        Connectez-vous pour retrouver un environnement de travail clair, rapide et entierement adapte a votre role.
                    </p>
                </div>

                <jsp:include page="/WEB-INF/views/common/flash.jsp"/>

                <form class="login-form auth-form" method="post" action="${pageContext.request.contextPath}/login">
                    <div class="auth-field">
                        <label for="login">Nom d'utilisateur ou email</label>
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
                                placeholder="Nom d utilisateur"
                            >
                        </div>
                    </div>

                    <div class="auth-field">
                        <label for="password">Mot de passe</label>
                        <div class="auth-input-shell auth-input-shell-password">
                            <span class="auth-input-icon auth-input-icon-lock" aria-hidden="true"></span>
                            <input
                                id="password"
                                name="password"
                                type="password"
                                required
                                autocomplete="current-password"
                                placeholder="Mot de passe"
                            >
                            <button
                                class="auth-password-toggle"
                                type="button"
                                data-password-toggle
                                data-target="password"
                                data-hidden-label="SHOW"
                                data-visible-label="HIDE"
                                aria-controls="password"
                                aria-pressed="false"
                            >SHOW</button>
                        </div>
                    </div>

                    <!-- <div class="auth-meta-row">
                        <label class="auth-remember">
                            <input type="checkbox" name="rememberMe">
                            <span>Se souvenir de moi</span>
                        </label>
                        <a class="auth-forgot" href="#auth-support">Mot de passe oublie ?</a>
                    </div> -->

                    <button class="btn btn-primary auth-submit" type="submit">Se connecter</button>

                    <!-- <div class="auth-divider"><span>ou</span></div> -->

                    <!-- <a class="btn btn-contour auth-secondary" href="#auth-support">Connexion alternative</a>

                    <div class="auth-support" id="auth-support">
                        <strong>Besoin d aide ?</strong>
                        <span>
                            Contactez l administration SGDA pour ouvrir, reactiver ou reinitialiser votre acces.
                        </span>
                    </div>

                    <p class="auth-footer">
                        Pas encore de compte ? <a href="#auth-support">Demandez un acces</a>
                    </p> -->
                </form>
            </div>
        </section>
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
})();
var loginThemeToggle = document.getElementById('loginThemeToggle');


if (loginThemeToggle) {
    loginThemeToggle.addEventListener('click', function () {
        var current = document.documentElement.getAttribute('data-theme') || 'light';
        var next = current === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', next);
        try { localStorage.setItem('sgda-theme', next); } catch(e) {}
        var icon = document.getElementById('loginThemeToggleIcon');
        if (icon) icon.textContent = next === 'dark' ? '🌙' : '☀️';
    });

    (function syncIcon(){
        var theme = document.documentElement.getAttribute('data-theme') || 'light';
        var icon = document.getElementById('loginThemeToggleIcon');
        if (icon) icon.textContent = theme === 'dark' ? '🌙' : '☀️';
    })();
}
</script>

<script>
// Theme toggle initial state sync (login)
(function(){
  'use strict';
  var icon = document.getElementById('loginThemeToggleIcon');
  var theme = document.documentElement.getAttribute('data-theme') || 'light';
  if (icon) icon.textContent = theme === 'dark' ? '🌙' : '☀️';
})();
</script>
</body>
</html>
