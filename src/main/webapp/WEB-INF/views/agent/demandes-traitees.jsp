<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="pageSection"><fmt:message key="section.agent"/></c:set>
<c:set var="pageTitle"><fmt:message key="agent.traitees.page_title"/></c:set>
<c:set var="pageSubtitle"><fmt:message key="agent.traitees.page_subtitle"/></c:set>
<c:set var="activeMenu" value="demandes-traitees"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="agent.traitees.html_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>

<div class="panel">
    <div class="panel-header">
        <div class="panel-title-group">
            <h2 class="panel-title"><fmt:message key="agent.traitees.panel.title"/></h2>
            <p class="panel-note"><fmt:message key="agent.traitees.panel.note"/></p>
        </div>
    </div>
    <div class="panel-body">
        <c:choose>
            <c:when test="${empty demandes}">
                <div class="empty-state"><fmt:message key="agent.traitees.empty"/></div>
            </c:when>
            <c:otherwise>
                <table class="table">
                    <thead>
                    <tr>
                        <th><fmt:message key="agent.traitees.table.header.code"/></th>
                        <th><fmt:message key="agent.traitees.table.header.etudiant"/></th>
                        <th><fmt:message key="agent.traitees.table.header.type"/></th>
                        <th><fmt:message key="agent.traitees.table.header.etat_final"/></th>
                        <th><fmt:message key="agent.traitees.table.header.date_decision"/></th>
                        <th><fmt:message key="agent.traitees.table.header.actions"/></th>
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
                                    <div class="muted"><fmt:message key="agent.traitees.table.archive_label"/></div>
                                </c:if>
                            </td>
                            <td>${demande.dateDecision}</td>
                            <td>
                                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/agent/demande/detail?id=${demande.id}&source=traitees">
                                    <fmt:message key="agent.traitees.table.consulter"/>
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
