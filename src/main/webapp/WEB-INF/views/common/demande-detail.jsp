<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:choose>
    <c:when test="${roleBasePath == '/student'}">
        <c:set var="pageSection" value="Espace etudiant"/>
        <c:set var="activeMenu" value="demandes"/>
    </c:when>
    <c:when test="${roleBasePath == '/agent'}">
        <c:set var="pageSection" value="Espace agent"/>
        <c:set var="activeMenu" value="${backPath == '/agent/demandes-traitees' ? 'demandes-traitees' : 'demandes'}"/>
    </c:when>
    <c:otherwise>
        <c:set var="pageSection" value="Administration"/>
        <c:set var="activeMenu" value="demandes"/>
    </c:otherwise>
</c:choose>
<c:set var="pageTitle" value="${demande.code}"/>
<c:set var="pageSubtitle" value="Consulte le detail complet de la demande et son historique de transition."/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Detail demande - SGDA</title>
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
                    <h2 class="panel-title">Informations generales</h2>
                    <p class="panel-note">Etat, type, etudiant et contenu principal de la demande.</p>
                </div>
            </div>
            <div class="panel-body">
                <table class="table meta-table">
                    <tbody>
                    <tr>
                        <td>Etat</td>
                        <td><span class="badge badge-${demande.etat.code}">${demande.etat.libelle}</span></td>
                    </tr>
                    <tr>
                        <td>Etudiant</td>
                        <td>${demande.etudiant.nomComplet}</td>
                    </tr>
                    <tr>
                        <td>Type</td>
                        <td>${demande.typeDemande.libelle}</td>
                    </tr>
                    <tr>
                        <td>Objet</td>
                        <td>${demande.objet}</td>
                    </tr>
                    <tr>
                        <td>Creee le</td>
                        <td>${demande.dateCreation}</td>
                    </tr>
                    <tr>
                        <td>Agent</td>
                        <td>
                            <c:choose>
                                <c:when test="${empty demande.agent}">Non affecte</c:when>
                                <c:otherwise>${demande.agent.nomComplet}</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <td>Description</td>
                        <td>
                            <c:choose>
                                <c:when test="${empty demande.description}"><span class="muted">Aucune description.</span></c:when>
                                <c:otherwise>${demande.description}</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <c:if test="${demande.etat.code == 'REFUSEE'}">
                        <tr>
                            <td>Motif de refus</td>
                            <td>${demande.motifRefus}</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                <div class="actions">
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}${backPath}">Retour</a>
                    <c:if test="${roleBasePath == '/student' && demande.etat.code == 'BROUILLON'}">
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/student/demande/edit?id=${demande.id}">Modifier</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <div>
        <div class="panel">
            <div class="panel-header">
                <div class="panel-title-group">
                    <h2 class="panel-title">Historique</h2>
                    <p class="panel-note">Toutes les transitions d etat enregistrees pour cette demande.</p>
                </div>
            </div>
            <div class="panel-body">
                <c:choose>
                    <c:when test="${empty demande.historiqueTransitions}">
                        <div class="empty-state">Aucune transition enregistree.</div>
                    </c:when>
                    <c:otherwise>
                        <table class="table">
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Acteur</th>
                                <th>Transition</th>
                                <th>Commentaire</th>
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
