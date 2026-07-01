<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="pageSection" value="Mon espace"/>
<c:set var="pageTitle" value="Mon profil"/>
<c:set var="pageSubtitle" value="Consultez vos informations personnelles et les details de votre compte SGDA."/>
<c:set var="activeMenu" value="profil"/>
<c:set var="prenomUtilisateur" value="${fn:split(sessionScope.SGDA_AUTH_USER.fullName, ' ')[0]}"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon profil - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>


<section class="profile-layout">
    <article class="content-card profile-card">
        <div class="content-card-header">
            <div>
                <h2 class="content-card-title">Informations personnelles</h2>
                <p class="content-card-subtitle">Les donnees associees a votre compte.</p>
            </div>
        </div>
        <div class="content-card-body">
            <div class="profile-avatar-wrap">
                <div class="avatar avatar-${sessionScope.SGDA_AUTH_USER.roleCode} profile-avatar">
                    <c:choose>
                        <c:when test="${sessionScope.SGDA_AUTH_USER.roleCode == 'ADMIN'}">AD</c:when>
                        <c:when test="${sessionScope.SGDA_AUTH_USER.roleCode == 'AGENT'}">AG</c:when>
                        <c:otherwise>ET</c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <strong class="profile-name">${profil.prenom} ${profil.nom}</strong>
                    <span class="badge badge-role">${sessionScope.SGDA_AUTH_USER.roleLabel}</span>
                </div>
            </div>

            <div class="profile-grid">
                <div class="profile-field">
                    <span class="profile-label">Nom</span>
                    <span class="profile-value">${profil.nom}</span>
                </div>
                <div class="profile-field">
                    <span class="profile-label">Prenom</span>
                    <span class="profile-value">${profil.prenom}</span>
                </div>
                <div class="profile-field">
                    <span class="profile-label">Nom d'utilisateur</span>
                    <span class="profile-value">${profil.username}</span>
                </div>
                <div class="profile-field">
                    <span class="profile-label">Adresse email</span>
                    <span class="profile-value">${profil.email}</span>
                </div>
                <div class="profile-field">
                    <span class="profile-label">Role</span>
                    <span class="profile-value">${sessionScope.SGDA_AUTH_USER.roleLabel}</span>
                </div>
                <div class="profile-field">
                    <span class="profile-label">Compte actif</span>
                    <span class="profile-value">
                        <c:choose>
                            <c:when test="${profil.actif}">Oui</c:when>
                            <c:otherwise>Non</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="profile-field">
                    <span class="profile-label">Date de creation</span>
                    <span class="profile-value">${fn:substring(fn:replace(profil.creeLe, 'T', ' '), 0, 16)}</span>
                </div>
                <div class="profile-field">
                    <span class="profile-label">Derniere connexion</span>
                    <span class="profile-value">
                        <c:choose>
                            <c:when test="${empty profil.dernierLoginLe}">Jamais</c:when>
                            <c:otherwise>${fn:substring(fn:replace(profil.dernierLoginLe, 'T', ' '), 0, 16)}</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>
    </article>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
