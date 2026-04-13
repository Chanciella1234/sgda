<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mes demandes - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="container">
    <div class="panel">
        <h1>Mes demandes</h1>
        <jsp:include page="/WEB-INF/views/common/flash.jsp"/>
        <c:choose>
            <c:when test="${empty demandes}">
                <div class="empty-state">Aucune demande pour le moment.</div>
            </c:when>
            <c:otherwise>
                <table class="table">
                    <thead>
                    <tr>
                        <th>Code</th>
                        <th>Type</th>
                        <th>Objet</th>
                        <th>Etat</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="demande" items="${demandes}">
                        <tr>
                            <td>${demande.code}</td>
                            <td>${demande.typeDemande.libelle}</td>
                            <td>${demande.objet}</td>
                            <td>
                                <span class="badge">${demande.etat.libelle}</span>
                                <c:if test="${demande.etat.code == 'REFUSEE'}">
                                    <div class="muted">Motif: ${demande.motifRefus}</div>
                                </c:if>
                            </td>
                            <td>
                                <div class="actions">
                                    <a class="btn btn-secondary"
                                       href="${pageContext.request.contextPath}/student/demande/detail?id=${demande.id}">
                                        Consulter
                                    </a>
                                    <c:if test="${demande.etat.code == 'BROUILLON'}">
                                        <a class="btn btn-secondary"
                                           href="${pageContext.request.contextPath}/student/demande/edit?id=${demande.id}">
                                            Modifier
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/student/demande/submit">
                                            <input type="hidden" name="id" value="${demande.id}">
                                            <button class="btn btn-primary" type="submit">Soumettre</button>
                                        </form>
                                        <form method="post" action="${pageContext.request.contextPath}/student/demande/delete">
                                            <input type="hidden" name="id" value="${demande.id}">
                                            <button class="btn btn-danger" type="submit">Supprimer</button>
                                        </form>
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

