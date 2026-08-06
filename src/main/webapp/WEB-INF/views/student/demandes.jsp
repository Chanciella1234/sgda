<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<fmt:message key="section.etudiant" var="pageSection"/>
<fmt:message key="student.demandes.page_title" var="pageTitle"/>
<fmt:message key="student.demandes.page_subtitle" var="pageSubtitle"/>
<c:set var="activeMenu" value="demandes"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="student.demandes.html_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>

<section class="content-card table-card">
    <div class="content-card-header">
        <div>
            <h2 class="content-card-title"><fmt:message key="student.demandes.card.title"/></h2>
            <p class="content-card-subtitle"><fmt:message key="student.demandes.card.subtitle"/></p>
        </div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/student/demande/new"><fmt:message key="student.demandes.btn_new"/></a>
    </div>
    <div class="content-card-body">
        <c:choose>
            <c:when test="${empty demandes}">
                <div class="empty-rich">
                    <div class="empty-illustration">&#128196;</div>
                    <h3 class="empty-title"><fmt:message key="student.demandes.empty.title"/></h3>
                    <p class="empty-text"><fmt:message key="student.demandes.empty.text"/></p>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/student/demande/new"><fmt:message key="student.demandes.btn_new"/></a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-scroller">
                    <table class="table">
                        <thead>
                        <tr>
                            <th><fmt:message key="student.demandes.table.header.code"/></th>
                            <th><fmt:message key="student.demandes.table.header.type"/></th>
                            <th><fmt:message key="student.demandes.table.header.objet"/></th>
                            <th><fmt:message key="student.demandes.table.header.etat"/></th>
                            <th><fmt:message key="student.demandes.table.header.actions"/></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="demande" items="${demandes}">
                            <tr>
                                <td class="code-text">${demande.code}</td>
                                <td>${demande.typeDemande.libelle}</td>
                                <td>${demande.objet}</td>
                                <td>
                                    <span class="badge badge-${demande.etat.code}">${demande.etat.libelle}</span>
                                    <c:if test="${demande.etat.code == 'REFUSEE'}">
                                        <div class="muted"><fmt:message key="student.demandes.table.motif"/> ${demande.motifRefus}</div>
                                    </c:if>
                                </td>
                                <td>
                                    <div class="actions">
                                        <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/student/demande/detail?id=${demande.id}"><fmt:message key="student.demandes.table.consulter"/></a>
                                        <c:if test="${demande.etat.code == 'BROUILLON'}">
                                            <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/student/demande/edit?id=${demande.id}"><fmt:message key="student.demandes.table.modifier"/></a>
                                            <form method="post" action="${pageContext.request.contextPath}/student/demande/submit">
                                                <input type="hidden" name="id" value="${demande.id}">
                                                <button class="btn btn-primary btn-sm" type="submit"><fmt:message key="student.demandes.table.soumettre"/></button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/student/demande/delete"
                                                  data-confirm='<fmt:message key="student.demandes.table.delete.confirm"/>'
                                                  data-confirm-title='<fmt:message key="student.demandes.table.delete.title"/>'
                                                  data-confirm-confirm-label='<fmt:message key="student.demandes.table.delete.confirm_label"/>'
                                                  data-confirm-cancel-label='<fmt:message key="student.demandes.table.delete.cancel_label"/>'
                                                  data-confirm-variant="danger">
                                                <input type="hidden" name="id" value="${demande.id}">
                                                <button class="btn btn-danger btn-sm" type="submit"><fmt:message key="student.demandes.table.delete"/></button>
                                            </form>
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
