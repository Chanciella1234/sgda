<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Supervision - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="container">
    <div class="panel">
        <h1>Supervision des demandes</h1>
        <jsp:include page="/WEB-INF/views/common/flash.jsp"/>
        <table class="table">
            <thead>
            <tr>
                <th>Code</th>
                <th>Etudiant</th>
                <th>Type</th>
                <th>Etat</th>
                <th>Agent</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="demande" items="${demandes}">
                <tr>
                    <td>${demande.code}</td>
                    <td>${demande.etudiant.nomComplet}</td>
                    <td>${demande.typeDemande.libelle}</td>
                    <td><span class="badge">${demande.etat.libelle}</span></td>
                    <td>
                        <c:choose>
                            <c:when test="${empty demande.agent}">-</c:when>
                            <c:otherwise>${demande.agent.nomComplet}</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div class="actions">
                            <a class="btn btn-secondary"
                               href="${pageContext.request.contextPath}/admin/demande/detail?id=${demande.id}">
                                Consulter
                            </a>
                            <c:if test="${demande.etat.code == 'VALIDEE' || demande.etat.code == 'REFUSEE'}">
                                <form method="post" action="${pageContext.request.contextPath}/admin/demande/archive">
                                    <input type="hidden" name="id" value="${demande.id}">
                                    <button class="btn btn-secondary" type="submit">Archiver</button>
                                </form>
                            </c:if>
                            <c:if test="${demande.etat.code != 'VALIDEE' && demande.etat.code != 'REFUSEE'}">
                                <span class="muted">Aucune action</span>
                            </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>

