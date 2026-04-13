<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Detail demande - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="container">
    <jsp:include page="/WEB-INF/views/common/flash.jsp"/>
    <div class="page-grid">
        <div>
            <div class="panel">
                <h1>${demande.code}</h1>
                <table class="table meta-table">
                    <tbody>
                    <tr>
                        <td>Etat</td>
                        <td><span class="badge">${demande.etat.libelle}</span></td>
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
                    <c:if test="${roleBasePath == '/student' && canUpload}">
                        <a class="btn btn-warning" href="${pageContext.request.contextPath}/student/demande/edit?id=${demande.id}">Modifier</a>
                    </c:if>
                </div>
            </div>

            <div class="panel">
                <h2>Pieces jointes</h2>
                <c:choose>
                    <c:when test="${empty demande.piecesJointes}">
                        <div class="empty-state">Aucune piece jointe.</div>
                    </c:when>
                    <c:otherwise>
                        <table class="table">
                            <thead>
                            <tr>
                                <th>Fichier</th>
                                <th>Type MIME</th>
                                <th>Taille</th>
                                <th>Ajoutee le</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="piece" items="${demande.piecesJointes}">
                                <tr>
                                    <td>${piece.nomOriginal}</td>
                                    <td>${piece.mimeType}</td>
                                    <td>${piece.tailleOctets} octets</td>
                                    <td>${piece.creeLe}</td>
                                    <td>
                                        <div class="actions">
                                            <a class="btn btn-secondary"
                                               href="${pageContext.request.contextPath}/piece/download?id=${piece.id}">
                                                Telecharger
                                            </a>
                                            <c:if test="${canUpload}">
                                                <form method="post" action="${pageContext.request.contextPath}/student/piece/delete">
                                                    <input type="hidden" name="id" value="${piece.id}">
                                                    <input type="hidden" name="demandeId" value="${demande.id}">
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

                <c:if test="${canUpload}">
                    <form method="post" enctype="multipart/form-data"
                          action="${pageContext.request.contextPath}/student/demande/upload">
                        <input type="hidden" name="demandeId" value="${demande.id}">
                        <div class="form-row">
                            <label for="fichier">Ajouter un document</label>
                            <input id="fichier" name="fichier" type="file" required>
                        </div>
                        <button class="btn btn-primary" type="submit">Televerser</button>
                    </form>
                </c:if>
            </div>
        </div>

        <div>
            <div class="panel">
                <h2>Historique</h2>
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

