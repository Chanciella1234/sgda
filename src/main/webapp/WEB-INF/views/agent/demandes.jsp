<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageSection" value="Espace agent"/>
<c:set var="pageTitle" value="Demandes a traiter"/>
<c:set var="pageSubtitle" value="Prends en charge les nouvelles demandes soumises et traite celles qui sont deja en attente."/>
<c:set var="activeMenu" value="demandes"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Demandes a traiter - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>

<div class="breadcrumbs">
    <span>SGDA</span>
    <span>/</span>
    <span>Agent</span>
    <span>/</span>
    <strong>Demandes a traiter</strong>
</div>

<section class="content-card table-card">
    <div class="content-card-header">
        <div>
            <h2 class="content-card-title">File de traitement</h2>
            <p class="content-card-subtitle">Consultez les demandes soumises ou en attente et executez les actions autorisees.</p>
        </div>
    </div>
    <div class="content-card-body">
        <c:choose>
            <c:when test="${empty demandes}">
                <div class="empty-rich">
                    <div class="empty-illustration">&#128221;</div>
                    <h3 class="empty-title">Aucune demande en attente</h3>
                    <p class="empty-text">Les nouvelles demandes soumises apparaitront ici pour etre prises en charge.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-scroller">
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
                                <td class="code-text">${demande.code}</td>
                                <td>${demande.etudiant.nomComplet}</td>
                                <td>${demande.typeDemande.libelle}</td>
                                <td>
                                    <span class="badge badge-${demande.etat.code}">${demande.etat.libelle}</span>
                                    <c:if test="${not empty demande.agent}">
                                        <div class="muted">Agent: ${demande.agent.nomComplet}</div>
                                    </c:if>
                                </td>
                                <td>
                                    <div class="actions">
                                        <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/agent/demande/detail?id=${demande.id}">Consulter</a>
                                        <c:if test="${demande.etat.code == 'SOUMISE'}">
                                            <form method="post" action="${pageContext.request.contextPath}/agent/demande/take">
                                                <input type="hidden" name="id" value="${demande.id}">
                                                <button class="btn btn-warning btn-sm" type="submit">Prendre</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${demande.etat.code == 'EN_ATTENTE' && demande.agent.id == sessionScope.SGDA_AUTH_USER.id}">
                                            <form method="post" action="${pageContext.request.contextPath}/agent/demande/valider">
                                                <input type="hidden" name="id" value="${demande.id}">
                                                <button class="btn btn-primary btn-sm" type="submit">Valider</button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/agent/demande/refuser">
                                                <input type="hidden" name="id" value="${demande.id}">
                                                <input type="text" name="motif" placeholder="Motif de refus" required>
                                                <button class="btn btn-danger btn-sm" type="submit">Refuser</button>
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
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
