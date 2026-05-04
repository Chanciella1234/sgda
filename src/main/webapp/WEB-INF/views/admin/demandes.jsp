<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageSection" value="Administration"/>
<c:set var="pageTitle" value="Supervision des demandes"/>
<c:set var="pageSubtitle" value="Surveille toutes les demandes du systeme et archive celles dont le traitement est termine."/>
<c:set var="activeMenu" value="demandes"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Supervision - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>

<div class="breadcrumbs">
    <span>SGDA</span>
    <span>/</span>
    <span>Administration</span>
    <span>/</span>
    <strong>Supervision</strong>
</div>

<section class="content-card table-card">
    <div class="content-card-header">
        <div>
            <h2 class="content-card-title">Supervision globale</h2>
            <p class="content-card-subtitle">Vue d ensemble de toutes les demandes, de leur etat et de l agent charge du traitement.</p>
        </div>
    </div>
    <div class="content-card-body">
        <div class="table-scroller">
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
                        <td class="code-text">${demande.code}</td>
                        <td>${demande.etudiant.nomComplet}</td>
                        <td>${demande.typeDemande.libelle}</td>
                        <td><span class="badge badge-${demande.etat.code}">${demande.etat.libelle}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${empty demande.agent}">-</c:when>
                                <c:otherwise>${demande.agent.nomComplet}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="actions">
                                <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/admin/demande/detail?id=${demande.id}">Consulter</a>
                                <c:if test="${demande.etat.code == 'VALIDEE' || demande.etat.code == 'REFUSEE'}">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/demande/archive">
                                        <input type="hidden" name="id" value="${demande.id}">
                                        <button class="btn btn-contour btn-sm" type="submit">Archiver</button>
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
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
