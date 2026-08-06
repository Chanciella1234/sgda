<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="pageSection"><fmt:message key="section.agent"/></c:set>
<c:set var="pageTitle"><fmt:message key="agent.demandes.page_title"/></c:set>
<c:set var="pageSubtitle"><fmt:message key="agent.demandes.page_subtitle"/></c:set>
<c:set var="activeMenu" value="demandes"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="agent.demandes.html_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>
<section class="content-card table-card">
    <div class="content-card-header">
        <div>
            <h2 class="content-card-title"><fmt:message key="agent.demandes.card.title"/></h2>
            <p class="content-card-subtitle"><fmt:message key="agent.demandes.card.subtitle"/></p>
        </div>
    </div>
    <div class="content-card-body">
        <c:choose>
            <c:when test="${empty demandes}">
                <div class="empty-rich">
                    <div class="empty-illustration">&#128221;</div>
                    <h3 class="empty-title"><fmt:message key="agent.demandes.empty.title"/></h3>
                    <p class="empty-text"><fmt:message key="agent.demandes.empty.text"/></p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-scroller">
                    <table class="table">
                        <thead>
                        <tr>
                            <th><fmt:message key="agent.demandes.table.header.code"/></th>
                            <th><fmt:message key="agent.demandes.table.header.etudiant"/></th>
                            <th><fmt:message key="agent.demandes.table.header.type"/></th>
                            <th><fmt:message key="agent.demandes.table.header.etat"/></th>
                            <th><fmt:message key="agent.demandes.table.header.actions"/></th>
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
                                        <div class="muted"><fmt:message key="agent.demandes.table.agent_label"/> ${demande.agent.nomComplet}</div>
                                    </c:if>
                                </td>
                                <td>
                                    <div class="actions">
                                        <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/agent/demande/detail?id=${demande.id}"><fmt:message key="agent.demandes.table.consulter"/></a>
                                        <c:if test="${demande.etat.code == 'SOUMISE'}">
                                            <form method="post" action="${pageContext.request.contextPath}/agent/demande/take">
                                                <input type="hidden" name="id" value="${demande.id}">
                                                <button class="btn btn-warning btn-sm" type="submit"><fmt:message key="agent.demandes.table.prendre"/></button>
                                            </form>
                                        </c:if>
                                        <c:if test="${demande.etat.code == 'EN_ATTENTE' && demande.agent.id == sessionScope.SGDA_AUTH_USER.id}">
                                            <form method="post" action="${pageContext.request.contextPath}/agent/demande/valider">
                                                <input type="hidden" name="id" value="${demande.id}">
                                                <button class="btn btn-primary btn-sm" type="submit"><fmt:message key="agent.demandes.table.valider"/></button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/agent/demande/refuser">
                                                <input type="hidden" name="id" value="${demande.id}">
                                                <input type="text" name="motif" placeholder='<fmt:message key="agent.demandes.table.refuser.placeholder"/>' required>
                                                <button class="btn btn-danger btn-sm" type="submit"><fmt:message key="agent.demandes.table.refuser"/></button>
                                            </form>
                                        </c:if>
                                        <c:if test="${demande.etat.code == 'EN_ATTENTE' && (demande.agent == null || demande.agent.id != sessionScope.SGDA_AUTH_USER.id)}">
                                            <span class="muted"><fmt:message key="agent.demandes.table.rien"/></span>
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
