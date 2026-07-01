<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="isEdit" value="${not empty demande or not empty editId}"/>
<c:set var="pageSection" value="Espace etudiant"/>
<c:set var="pageTitle" value="${isEdit ? 'Modifier une demande' : 'Nouvelle demande'}"/>
<c:set var="pageSubtitle" value="${isEdit ? 'Mets a jour ton brouillon avant sa soumission.' : 'Cree un nouveau dossier administratif a envoyer au service academique.'}"/>
<c:set var="activeMenu" value="${isEdit ? 'demandes' : 'new'}"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Demande - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>

<div class="panel">
    <div class="panel-header">
        <div class="panel-title-group">
            <h2 class="panel-title">${isEdit ? 'Edition du brouillon' : 'Creation d une demande'}</h2>
            <p class="panel-note">Renseigne soigneusement les informations avant l enregistrement.</p>
        </div>
    </div>
    <div class="panel-body">
        <div class="form-shell">
            <div class="form-highlight">
                <h3 class="form-highlight-title">${isEdit ? 'Mettre a jour le dossier' : 'Preparer une nouvelle demande'}</h3>
                <p class="form-highlight-text">
                    Choisis un type de demande, precise clairement l objet et ajoute une description utile pour faciliter le traitement administratif.
                </p>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/student/demande/save">
                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${empty demande ? editId : demande.id}">
                </c:if>
                <div class="form-grid">
                    <div class="field-card half">
                        <div class="field-title">
                            <label for="typeDemandeId">Type de demande</label>
                            <span class="field-help">Selectionne la categorie administrative correspondant a ton besoin.</span>
                        </div>
                        <select id="typeDemandeId" name="typeDemandeId" required>
                            <option value="">Selectionner</option>
                            <c:forEach var="type" items="${types}">
                                <option value="${type.id}"
                                        <c:if test="${type.id == (empty demande ? typeDemandeId : demande.typeDemande.id)}">selected</c:if>>
                                    ${type.libelle}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="field-card half">
                        <div class="field-title">
                            <label for="objet">Objet</label>
                            <span class="field-help">Resume la demande en une phrase claire et concise.</span>
                        </div>
                        <input id="objet" name="objet" type="text" value="${not empty objet ? objet : demande.objet}" required>
                    </div>

                    <div class="field-card full">
                        <div class="field-title">
                            <label for="description">Description</label>
                            <span class="field-help">Ajoute le contexte, les precisions utiles ou les informations complementaires pour l agent.</span>
                        </div>
                        <textarea id="description" name="description">${not empty description ? description : demande.description}</textarea>
                    </div>
                </div>

                <div class="form-actions-bar">
                    <span class="form-actions-note">Les informations enregistrees en brouillon pourront encore etre modifiees avant soumission.</span>
                    <div class="actions">
                        <button class="btn btn-primary" type="submit">Enregistrer</button>
                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/student/demandes">Retour</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
