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
<div class="login-shell">
    <div class="login-layout">
        <section class="login-aside">
            <div>
                <div class="login-kicker">Plateforme de gestion des demandes academiques</div>
                <h1 class="login-title">La plateforme institutionnelle qui structure chaque demande academique</h1>
                <p class="login-copy">
                    SGDA centralise les demandes academiques dans un environnement sobre, fiable et premium. Chaque action, chaque transition et chaque decision reste lisible, tracee et maitrisee.
                </p>
            </div>

            <div class="login-points">
                <div class="login-point">
                    <strong>Workflow institutionnel maitrise</strong>
                    Chaque demande suit un circuit clair du brouillon a la decision finale avec une tracabilite continue.
                </div>
                <div class="login-point">
                    <strong>Acces strictement controles</strong>
                    Les etudiants, agents et administrateurs disposent chacun d un espace adapte a leurs responsabilites.
                </div>
                <div class="login-point">
                    <strong>Execution professionnelle</strong>
                    Interface lisible, traitement fiable, supervision globale et pilotage en temps reel pour l universite.
                </div>
            </div>
        </section>

        <section class="login-card">
            <div>
                <div class="page-kicker">Connexion</div>
                <h2 class="page-title">Acceder a votre espace SGDA</h2>
                <p class="page-subtitle">Connectez-vous pour retrouver un environnement de travail clair, rapide et entierement adapte a votre role.</p>
            </div>

            <jsp:include page="/WEB-INF/views/common/flash.jsp"/>

            <form class="login-form" method="post" action="${pageContext.request.contextPath}/login">
                <div class="form-row">
                    <label for="login">Email ou username</label>
                    <input id="login" name="login" type="text" required>
                </div>
                <div class="form-row">
                    <label for="password">Mot de passe</label>
                    <input id="password" name="password" type="password" required>
                </div>
                <div class="login-actions">
                    <span class="muted">SGDA securise l acces et les actions selon votre role.</span>
                    <button class="btn btn-primary" type="submit">Se connecter</button>
                </div>
            </form>

            <div class="login-assurance">
                <div class="login-assurance-item">
                    <strong>Clarte operationnelle</strong>
                    <span>Un parcours simple pour soumettre, traiter et superviser sans confusion.</span>
                </div>
                <div class="login-assurance-item">
                    <strong>Trajectoire visible</strong>
                    <span>Chaque demande reste suivie avec un historique lisible et une responsabilite claire.</span>
                </div>
                <div class="login-assurance-item">
                    <strong>Experience premium</strong>
                    <span>Une interface universitaire moderne qui inspire confiance des la premiere impression.</span>
                </div>
            </div>
        </section>
    </div>
</div>
</body>
</html>
