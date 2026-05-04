<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageSection" value="Espace agent"/>
<c:set var="pageTitle" value="Mes demandes traitees"/>
<c:set var="pageSubtitle" value="Retrouve toutes les demandes pour lesquelles tu as deja pris une decision."/>
<c:set var="activeMenu" value="demandes-traitees"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mes demandes traitees - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>

<div class="panel">
    <div class="panel-header">
        <div class="panel-title-group">
            <h2 class="panel-title">Historique de traitement</h2>
            <p class="panel-note">Demandes validees, refusees ou deja archivees apres votre decision.</p>
        </div>
    </div>
    <div class="panel-body">
        <c:choose>
            <c:when test="${empty demandes}">
                <div class="empty-state">Vous n avez encore traite aucune demande.</div>
            </c:when>
            <c:otherwise>
                <table class="table">
                    <thead>
                    <tr>
                        <th>Code</th>
                        <th>Etudiant</th>
                        <th>Type</th>
                        <th>Etat final</th>
                        <th>Date de decision</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="demande" items="${demandes}">
                        <tr>
                            <td class="code-text">${demande.code}</td>
                            <td>${demande.etudiant.nomComplet}</td>
                            <td>${demande.typeDemande.libelle}</td>
                            <td>
                                <span class="badge badge-${demande.etat.code}">${demande.etat.libelle}</span>
                                <c:if test="${demande.etat.code == 'ARCHIVEE'}">
                                    <div class="muted">Decision deja prise puis archivee</div>
                                </c:if>
                            </td>
                            <td>${demande.dateDecision}</td>
                            <td>
                                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/agent/demande/detail?id=${demande.id}&source=traitees">
                                    Consulter
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
