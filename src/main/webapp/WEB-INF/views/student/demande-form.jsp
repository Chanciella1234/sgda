<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Demande - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="container">
    <div class="panel">
        <h1>${empty demande and empty editId ? 'Nouvelle demande' : 'Modifier la demande'}</h1>
        <jsp:include page="/WEB-INF/views/common/flash.jsp"/>
        <form method="post" action="${pageContext.request.contextPath}/student/demande/save">
            <c:if test="${not empty demande || not empty editId}">
                <input type="hidden" name="id" value="${empty demande ? editId : demande.id}">
            </c:if>
            <div class="form-row">
                <label for="typeDemandeId">Type de demande</label>
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
            <div class="form-row">
                <label for="objet">Objet</label>
                <input id="objet" name="objet" type="text"
                       value="${not empty objet ? objet : demande.objet}" required>
            </div>
            <div class="form-row">
                <label for="description">Description</label>
                <textarea id="description" name="description">${not empty description ? description : demande.description}</textarea>
            </div>
            <div class="actions">
                <button class="btn btn-primary" type="submit">Enregistrer</button>
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/student/demandes">Retour</a>
            </div>
        </form>
    </div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>

