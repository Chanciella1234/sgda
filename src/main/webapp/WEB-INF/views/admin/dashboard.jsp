<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard admin - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="container">
    <div class="panel">
        <h1>Tableau de bord administrateur</h1>
        <jsp:include page="/WEB-INF/views/common/flash.jsp"/>
        <div class="stats-grid">
            <div class="stat-card">
                <span class="stat-label">Total demandes</span>
                <strong class="stat-value">${dashboard.totalDemandes}</strong>
            </div>
            <div class="stat-card">
                <span class="stat-label">En attente</span>
                <strong class="stat-value">${dashboard.demandesEnAttente}</strong>
            </div>
            <div class="stat-card">
                <span class="stat-label">Validees</span>
                <strong class="stat-value">${dashboard.demandesValidees}</strong>
            </div>
            <div class="stat-card">
                <span class="stat-label">Refusees</span>
                <strong class="stat-value">${dashboard.demandesRefusees}</strong>
            </div>
            <div class="stat-card">
                <span class="stat-label">Archivees</span>
                <strong class="stat-value">${dashboard.demandesArchivees}</strong>
            </div>
            <div class="stat-card">
                <span class="stat-label">Total utilisateurs</span>
                <strong class="stat-value">${dashboard.totalUtilisateurs}</strong>
            </div>
        </div>
    </div>

    <div class="page-grid">
        <div class="panel">
            <h2>Utilisateurs par role</h2>
            <table class="table">
                <thead>
                <tr>
                    <th>Role</th>
                    <th>Total</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${dashboard.utilisateursParRole}">
                    <tr>
                        <td>${item.roleLabel}</td>
                        <td>${item.total}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="panel">
            <h2>Dernieres demandes</h2>
            <c:choose>
                <c:when test="${empty dashboard.dernieresDemandes}">
                    <div class="empty-state">Aucune demande enregistree.</div>
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
                                       href="${pageContext.request.contextPath}/admin/demande/detail?id=${demande.id}">
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
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
