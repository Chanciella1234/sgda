<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageSection" value="Espace etudiant"/>
<c:set var="pageTitle" value="Mes demandes"/>
<c:set var="pageSubtitle" value="Consulte toutes tes demandes, leurs etats et les actions encore possibles sur les brouillons."/>
<c:set var="activeMenu" value="demandes"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mes demandes - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>

<section class="content-card table-card">
    <div class="content-card-header">
        <div>
            <h2 class="content-card-title">Historique de mes demandes</h2>
            <p class="content-card-subtitle">Visualisez vos dossiers et gerer uniquement ceux qui sont encore en brouillon.</p>
        </div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/student/demande/new">Nouvelle demande</a>
    </div>
    <div class="content-card-body">
        <c:choose>
            <c:when test="${empty demandes}">
                <div class="empty-rich">
                    <div class="empty-illustration">&#128196;</div>
                    <h3 class="empty-title">Aucune demande pour le moment</h3>
                    <p class="empty-text">Creez votre premiere demande pour commencer a suivre vos traitements administratifs.</p>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/student/demande/new">Nouvelle demande</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-scroller">
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
                                <td class="code-text">${demande.code}</td>
                                <td>${demande.typeDemande.libelle}</td>
                                <td>${demande.objet}</td>
                                <td>
                                    <span class="badge badge-${demande.etat.code}">${demande.etat.libelle}</span>
                                    <c:if test="${demande.etat.code == 'REFUSEE'}">
                                        <div class="muted">Motif: ${demande.motifRefus}</div>
                                    </c:if>
                                </td>
                                <td>
                                    <div class="actions">
                                        <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/student/demande/detail?id=${demande.id}">Consulter</a>
                                        <c:if test="${demande.etat.code == 'BROUILLON'}">
                                            <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/student/demande/edit?id=${demande.id}">Modifier</a>
                                            <form method="post" action="${pageContext.request.contextPath}/student/demande/submit">
                                                <input type="hidden" name="id" value="${demande.id}">
                                                <button class="btn btn-primary btn-sm" type="submit">Soumettre</button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/student/demande/delete"
                                                  data-confirm="Cette demande brouillon sera supprimee de votre espace et cette action ne pourra pas etre annulee."
                                                  data-confirm-title="Supprimer la demande"
                                                  data-confirm-confirm-label="Oui, supprimer"
                                                  data-confirm-cancel-label="Annuler"
                                                  data-confirm-variant="danger">
                                                <input type="hidden" name="id" value="${demande.id}">
                                                <button class="btn btn-danger btn-sm" type="submit">Supprimer</button>
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
