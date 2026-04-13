<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mes demandes traitees - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="container">
    <div class="panel">
        <h1>Mes demandes traitees</h1>
        <p class="muted">Retrouvez ici toutes les demandes sur lesquelles vous avez deja rendu une decision.</p>
        <jsp:include page="/WEB-INF/views/common/flash.jsp"/>
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
                            <td>${demande.code}</td>
                            <td>${demande.etudiant.nomComplet}</td>
                            <td>${demande.typeDemande.libelle}</td>
                            <td>
                                <span class="badge">${demande.etat.libelle}</span>
                                <c:if test="${demande.etat.code == 'ARCHIVEE'}">
                                    <div class="muted">Decision deja prise puis archivee</div>
                                </c:if>
                            </td>
                            <td>${demande.dateDecision}</td>
                            <td>
                                <div class="actions">
                                    <a class="btn btn-secondary"
                                       href="${pageContext.request.contextPath}/agent/demande/detail?id=${demande.id}&source=traitees">
                                        Consulter
                                    </a>
                                </div>
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
