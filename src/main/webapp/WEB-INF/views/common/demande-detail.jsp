<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:choose>
    <c:when test="${roleBasePath == '/student'}">
        <c:set var="pageSection"><fmt:message key="section.etudiant"/></c:set>
        <c:set var="activeMenu" value="demandes"/>
    </c:when>
    <c:when test="${roleBasePath == '/agent'}">
        <c:set var="pageSection"><fmt:message key="section.agent"/></c:set>
        <c:set var="activeMenu" value="${backPath == '/agent/demandes-traitees' ? 'demandes-traitees' : 'demandes'}"/>
    </c:when>
    <c:otherwise>
        <c:set var="pageSection"><fmt:message key="section.admin"/></c:set>
        <c:set var="activeMenu" value="demandes"/>
    </c:otherwise>
</c:choose>
<c:set var="pageTitle" value="${demande.code}"/>
<c:set var="pageSubtitle"><fmt:message key="detail.page_subtitle"/></c:set>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="detail.page_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>

<div class="page-grid">
    <div>
        <div class="panel">
            <div class="panel-header">
                <div class="panel-title-group">
                    <h2 class="panel-title"><fmt:message key="detail.info.title"/></h2>
                    <p class="panel-note"><fmt:message key="detail.info.note"/></p>
                </div>
            </div>
            <div class="panel-body">
                <table class="table meta-table">
                    <tbody>
                    <tr>
                        <td><fmt:message key="detail.label.etat"/></td>
                        <td><span class="badge badge-${demande.etat.code}">${demande.etat.libelle}</span></td>
                    </tr>
                    <tr>
                        <td><fmt:message key="detail.label.etudiant"/></td>
                        <td>${demande.etudiant.nomComplet}</td>
                    </tr>
                    <tr>
                        <td><fmt:message key="detail.label.type"/></td>
                        <td>${demande.typeDemande.libelle}</td>
                    </tr>
                    <tr>
                        <td><fmt:message key="detail.label.objet"/></td>
                        <td>${demande.objet}</td>
                    </tr>
                    <tr>
                        <td><fmt:message key="detail.label.creee_le"/></td>
                        <td>${demande.dateCreation}</td>
                    </tr>
                    <tr>
                        <td><fmt:message key="detail.label.agent"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${empty demande.agent}"><fmt:message key="detail.label.non_affecte"/></c:when>
                                <c:otherwise>${demande.agent.nomComplet}</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <td><fmt:message key="detail.label.description"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${empty demande.description}"><span class="muted"><fmt:message key="detail.label.rien"/></span></c:when>
                                <c:otherwise>${demande.description}</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <c:if test="${demande.etat.code == 'REFUSEE'}">
                        <tr>
                            <td><fmt:message key="detail.label.motif_refus"/></td>
                            <td>${demande.motifRefus}</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                <div class="actions">
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}${backPath}"><fmt:message key="detail.btn.retour"/></a>
                    <c:if test="${roleBasePath == '/student' && demande.etat.code == 'BROUILLON'}">
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/student/demande/edit?id=${demande.id}"><fmt:message key="detail.btn.modifier"/></a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <div>
        <div class="panel">
            <div class="panel-header">
                <div class="panel-title-group">
                    <h2 class="panel-title"><fmt:message key="detail.historique.title"/></h2>
                    <p class="panel-note"><fmt:message key="detail.historique.note"/></p>
                </div>
            </div>
            <div class="panel-body">
                <c:choose>
                    <c:when test="${empty demande.historiqueTransitions}">
                        <div class="empty-state"><fmt:message key="detail.historique.empty"/></div>
                    </c:when>
                    <c:otherwise>
                        <table class="table">
                            <thead>
                            <tr>
                                <th><fmt:message key="detail.table.date"/></th>
                                <th><fmt:message key="detail.table.acteur"/></th>
                                <th><fmt:message key="detail.table.transition"/></th>
                                <th><fmt:message key="detail.table.commentaire"/></th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${demande.historiqueTransitions}">
                                <tr>
                                    <td>${item.creeLe}</td>
                                    <td>${item.acteur.nomComplet}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty item.deEtat}">
                                                ${item.versEtat.libelle}
                                            </c:when>
                                            <c:otherwise>
                                                ${item.deEtat.libelle} -> ${item.versEtat.libelle}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${item.commentaire}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
