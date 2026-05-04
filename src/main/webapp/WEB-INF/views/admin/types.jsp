<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageSection" value="Administration"/>
<c:set var="pageTitle" value="Gestion des types de demande"/>
<c:set var="pageSubtitle" value="Ajoute, modifie ou desactive les types de demandes disponibles pour les etudiants."/>
<c:set var="activeMenu" value="types"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Types de demande - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>

<div class="page-grid">
    <div class="panel">
        <div class="panel-header">
            <div class="panel-title-group">
                <h2 class="panel-title">${empty editType ? 'Nouveau type' : 'Modifier type'}</h2>
                <p class="panel-note">Configure les types de demandes proposes dans le portail etudiant.</p>
            </div>
        </div>
        <div class="panel-body">
            <div class="form-shell">
                <div class="form-highlight">
                    <h3 class="form-highlight-title">${empty editType ? 'Ajouter un type de demande' : 'Modifier un type existant'}</h3>
                    <p class="form-highlight-text">
                        Chaque type reste historise. On le desactive si necessaire, sans jamais supprimer la categorie de demande deja utilisee.
                    </p>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/admin/type/save">
                    <c:if test="${not empty editType}">
                        <input type="hidden" name="id" value="${editType.id}">
                    </c:if>
                    <div class="form-grid">
                        <div class="field-card half">
                            <div class="field-title">
                                <label for="code">Code</label>
                                <span class="field-help">Code technique unique, stable et reutilisable dans toute l application.</span>
                            </div>
                            <input id="code" name="code" type="text" value="${editType.code}" required>
                        </div>

                        <div class="field-card half">
                            <div class="field-title">
                                <label for="libelle">Libelle</label>
                                <span class="field-help">Libelle visible par l etudiant lors de la creation de sa demande.</span>
                            </div>
                            <input id="libelle" name="libelle" type="text" value="${editType.libelle}" required>
                        </div>

                        <div class="field-card full">
                            <div class="field-title">
                                <label for="description">Description</label>
                                <span class="field-help">Decris l usage de ce type pour aider les utilisateurs a bien choisir.</span>
                            </div>
                            <textarea id="description" name="description">${editType.description}</textarea>
                        </div>

                        <div class="field-card full">
                            <label class="checkbox-inline">
                                <input type="checkbox" name="actif" <c:if test="${empty editType || editType.actif}">checked</c:if>>
                                Actif
                            </label>
                            <span class="field-help">Un type inactif n apparait plus dans les formulaires etudiants, mais reste present pour l historique.</span>
                        </div>
                    </div>

                    <div class="form-actions-bar">
                        <span class="form-actions-note">Les types modifies sont immediatement pris en compte par le catalogue des demandes.</span>
                        <div class="actions">
                            <button class="btn btn-primary" type="submit">Enregistrer</button>
                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/types">Nouveau</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="panel">
        <div class="panel-header">
            <div class="panel-title-group">
                <h2 class="panel-title">Liste des types</h2>
                <p class="panel-note">Mets a jour les libelles et active ou desactive un type sans le supprimer.</p>
            </div>
        </div>
        <div class="panel-body">
            <table class="table">
                <thead>
                <tr>
                    <th>Code</th>
                    <th>Libelle</th>
                    <th>Actif</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="type" items="${types}">
                    <tr>
                        <td class="code-text">${type.code}</td>
                        <td>${type.libelle}</td>
                        <td>${type.actif ? 'Oui' : 'Non'}</td>
                        <td>
                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/types?id=${type.id}">
                                Modifier
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
