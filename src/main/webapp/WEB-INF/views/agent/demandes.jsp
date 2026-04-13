<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Demandes a traiter - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="container">
    <div class="panel">
        <h1>Demandes a traiter</h1>
        <jsp:include page="/WEB-INF/views/common/flash.jsp"/>
        <c:choose>
            <c:when test="${empty demandes}">
                <div class="empty-state">Aucune demande en attente.</div>
            </c:when>
            <c:otherwise>
                <table class="table">
                    <thead>
                    <tr>
                        <th>Code</th>
                        <th>Etudiant</th>
                        <th>Type</th>
                        <th>Etat</th>
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
                                <c:if test="${not empty demande.agent}">
                                    <div class="muted">Agent: ${demande.agent.nomComplet}</div>
                                </c:if>
                            </td>
                            <td>
                                <div class="actions">
                                    <a class="btn btn-secondary"
                                       href="${pageContext.request.contextPath}/agent/demande/detail?id=${demande.id}">
                                        Consulter
                                    </a>
                                    <c:if test="${demande.etat.code == 'SOUMISE'}">
                                        <form method="post" action="${pageContext.request.contextPath}/agent/demande/take">
                                            <input type="hidden" name="id" value="${demande.id}">
                                            <button class="btn btn-warning" type="submit">Prendre</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${demande.etat.code == 'EN_ATTENTE' && demande.agent.id == sessionScope.SGDA_AUTH_USER.id}">
                                        <form method="post" action="${pageContext.request.contextPath}/agent/demande/valider">
                                            <input type="hidden" name="id" value="${demande.id}">
                                            <button class="btn btn-primary" type="submit">Valider</button>
                                        </form>
                                        <form method="post" action="${pageContext.request.contextPath}/agent/demande/refuser">
                                            <input type="hidden" name="id" value="${demande.id}">
                                            <input type="text" name="motif" placeholder="Motif de refus" required>
                                            <button class="btn btn-danger" type="submit">Refuser</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${demande.etat.code == 'EN_ATTENTE' && (demande.agent == null || demande.agent.id != sessionScope.SGDA_AUTH_USER.id)}">
                                        <span class="muted">Aucune action</span>
                                    </c:if>
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

