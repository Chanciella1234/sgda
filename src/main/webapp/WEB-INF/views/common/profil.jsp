<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="pageSection"><fmt:message key="section.etudiant"/></c:set>
<c:set var="pageTitle"><fmt:message key="profil.title"/></c:set>
<c:set var="pageSubtitle"><fmt:message key="profil.subtitle"/></c:set>
<c:set var="activeMenu" value="profil"/>
<c:set var="prenomUtilisateur" value="${fn:split(sessionScope.SGDA_AUTH_USER.fullName, ' ')[0]}"/>
<c:set var="editMode" value="${param.edit == '1' || not empty param.error}"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="profil.page_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<section class="profile-layout">
    <article class="content-card profile-card">
        <div class="content-card-header">
            <div>
                <h2 class="content-card-title"><fmt:message key="profil.card.title"/></h2>
                <p class="content-card-subtitle"><fmt:message key="profil.card.subtitle"/></p>
            </div>
            <c:if test="${not editMode}">
                <a class="btn btn-contour btn-sm" href="?edit=1"><fmt:message key="profil.edit.btn"/></a>
            </c:if>
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

            <c:choose>
                <c:when test="${editMode}">
                    <form method="post" action="profil" class="profile-edit-form">
                        <div class="profile-grid">
                            <div class="profile-field">
                                <label class="profile-label" for="editNom"><fmt:message key="profil.label.nom"/></label>
                                <input type="text" id="editNom" name="nom" value="${not empty param.nom ? param.nom : profil.nom}" required>
                            </div>
                            <div class="profile-field">
                                <label class="profile-label" for="editPrenom"><fmt:message key="profil.label.prenom"/></label>
                                <input type="text" id="editPrenom" name="prenom" value="${not empty param.prenom ? param.prenom : profil.prenom}" required>
                            </div>
                            <div class="profile-field">
                                <label class="profile-label" for="editEmail"><fmt:message key="profil.label.email"/></label>
                                <input type="email" id="editEmail" name="email" value="${not empty param.email ? param.email : profil.email}" required>
                            </div>
                            <div class="profile-field">
                                <label class="profile-label" for="editUsername"><fmt:message key="profil.label.username"/></label>
                                <input type="text" id="editUsername" name="username" value="${not empty param.username ? param.username : profil.username}" required>
                            </div>
                            <div class="profile-field">
                                <label class="profile-label" for="editPassword"><fmt:message key="profil.label.password"/></label>
                                <input type="password" id="editPassword" name="password" placeholder="<fmt:message key="profil.label.password_placeholder"/>">
                            </div>
                            <div class="profile-field">
                                <label class="profile-label" for="editPasswordConfirm"><fmt:message key="profil.label.password_confirm"/></label>
                                <input type="password" id="editPasswordConfirm" name="passwordConfirm" placeholder="<fmt:message key="profil.label.password_confirm_placeholder"/>">
                            </div>
                        </div>
                        <div class="form-actions" style="margin-top: 20px;">
                            <a class="btn btn-contour" href="profil"><fmt:message key="profil.edit.cancel"/></a>
                            <button type="submit" class="btn btn-primary"><fmt:message key="profil.edit.save"/></button>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="profile-grid">
                        <div class="profile-field">
                            <span class="profile-label"><fmt:message key="profil.label.nom"/></span>
                            <span class="profile-value">${profil.nom}</span>
                        </div>
                        <div class="profile-field">
                            <span class="profile-label"><fmt:message key="profil.label.prenom"/></span>
                            <span class="profile-value">${profil.prenom}</span>
                        </div>
                        <div class="profile-field">
                            <span class="profile-label"><fmt:message key="profil.label.username"/></span>
                            <span class="profile-value">${profil.username}</span>
                        </div>
                        <div class="profile-field">
                            <span class="profile-label"><fmt:message key="profil.label.email"/></span>
                            <span class="profile-value">${profil.email}</span>
                        </div>
                        <div class="profile-field">
                            <span class="profile-label"><fmt:message key="profil.label.role"/></span>
                            <span class="profile-value">${sessionScope.SGDA_AUTH_USER.roleLabel}</span>
                        </div>
                        <div class="profile-field">
                            <span class="profile-label"><fmt:message key="profil.label.actif"/></span>
                            <span class="profile-value">
                                <c:choose>
                                    <c:when test="${profil.actif}"><fmt:message key="profil.value.oui"/></c:when>
                                    <c:otherwise><fmt:message key="profil.value.non"/></c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="profile-field">
                            <span class="profile-label"><fmt:message key="profil.label.date_creation"/></span>
                            <span class="profile-value">${fn:substring(fn:replace(profil.creeLe, 'T', ' '), 0, 16)}</span>
                        </div>
                        <div class="profile-field">
                            <span class="profile-label"><fmt:message key="profil.label.dernier_connexion"/></span>
                            <span class="profile-value">
                                <c:choose>
                                    <c:when test="${empty profil.dernierLoginLe}"><fmt:message key="profil.value.jamais"/></c:when>
                                    <c:otherwise>${fn:substring(fn:replace(profil.dernierLoginLe, 'T', ' '), 0, 16)}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </article>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
