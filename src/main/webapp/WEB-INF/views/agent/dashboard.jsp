<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard agent - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="container">
    <div class="panel">
        <h1>Tableau de bord agent</h1>
        <jsp:include page="/WEB-INF/views/common/flash.jsp"/>
        <div class="stats-grid">
            <div class="stat-card">
                <span class="stat-label">Demandes traitees</span>
                <strong class="stat-value">${dashboard.totalDemandesTraitees}</strong>
            </div>
            <div class="stat-card">
                <span class="stat-label">Validees par vous</span>
                <strong class="stat-value">${dashboard.demandesValideesParAgent}</strong>
            </div>
            <div class="stat-card">
                <span class="stat-label">Refusees par vous</span>
                <strong class="stat-value">${dashboard.demandesRefuseesParAgent}</strong>
            </div>
            <div class="stat-card">
                <span class="stat-label">En cours chez vous</span>
                <strong class="stat-value">${dashboard.demandesEnCours}</strong>
            </div>
        </div>
    </div>

    <div class="panel">
        <h2>Dernieres demandes concernees</h2>
        <c:choose>
            <c:when test="${empty dashboard.dernieresDemandes}">
                <div class="empty-state">Aucune demande affectee pour le moment.</div>
            </c:when>
            <c:otherwise>
                <table class="table">
                    <thead>
                    <tr>
                        <th>Code</th>
                        <th>Etudiant</th>
                        <th>Etat</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="demande" items="${dashboard.dernieresDemandes}">
                        <tr>
                            <td>${demande.code}</td>
                            <td>${demande.etudiant.nomComplet}</td>
                            <td>${demande.etat.libelle}</td>
                            <td>
                                <a class="btn btn-secondary"
                                   href="${pageContext.request.contextPath}/agent/demande/detail?id=${demande.id}">
                                    Voir
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
