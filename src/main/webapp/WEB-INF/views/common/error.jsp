<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Erreur - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<div class="login-shell">
    <div class="error-card panel">
        <div class="panel-header">
            <div class="panel-title-group">
                <p class="panel-note">Erreur applicative</p>
                <h1 class="panel-title">Une erreur est survenue</h1>
            </div>
        </div>
        <div class="panel-body">
            <p class="page-subtitle">Le traitement de votre requete a echoue. Merci de reessayer ou de contacter l administrateur.</p>
            <c:set var="errorMessage" value="${requestScope['jakarta.servlet.error.message']}"/>
            <c:set var="errorException" value="${requestScope['jakarta.servlet.error.exception']}"/>
            <c:set var="errorUri" value="${requestScope['jakarta.servlet.error.request_uri']}"/>
            <c:if test="${not empty errorUri}">
                <p><strong>URI :</strong> ${errorUri}</p>
            </c:if>
            <c:if test="${not empty errorException}">
                <div class="alert alert-error">
                    <strong>Message technique :</strong>
                    ${errorException.class.simpleName}
                    <c:if test="${not empty errorException.message}">
                        - ${errorException.message}
                    </c:if>
                </div>
            </c:if>
            <c:if test="${empty errorException and not empty errorMessage}">
                <div class="alert alert-error">
                    <strong>Message technique :</strong> ${errorMessage}
                </div>
            </c:if>
            <div class="actions">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/login">Retour a la connexion</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
