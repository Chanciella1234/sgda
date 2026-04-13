<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Types de demande - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="container">
    <div class="page-grid">
        <div class="panel">
            <h2>${empty editType ? 'Nouveau type' : 'Modifier type'}</h2>
            <jsp:include page="/WEB-INF/views/common/flash.jsp"/>
            <form method="post" action="${pageContext.request.contextPath}/admin/type/save">
                <c:if test="${not empty editType}">
                    <input type="hidden" name="id" value="${editType.id}">
                </c:if>
                <div class="form-row">
                    <label for="code">Code</label>
                    <input id="code" name="code" type="text" value="${editType.code}" required>
                </div>
                <div class="form-row">
                    <label for="libelle">Libelle</label>
                    <input id="libelle" name="libelle" type="text" value="${editType.libelle}" required>
                </div>
                <div class="form-row">
                    <label for="description">Description</label>
                    <textarea id="description" name="description">${editType.description}</textarea>
                </div>
                <div class="form-row">
                    <label>
                        <input type="checkbox" name="actif"
                               <c:if test="${empty editType || editType.actif}">checked</c:if>>
                        Actif
                    </label>
                </div>
                <div class="actions">
                    <button class="btn btn-primary" type="submit">Enregistrer</button>
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/types">Nouveau</a>
                </div>
            </form>
        </div>
        <div class="panel">
            <h2>Liste des types</h2>
            <table class="table">
                <thead>
                <tr>
                    <th>Code</th>
                    <th>Libelle</th>
                    <th>Actif</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="type" items="${types}">
                    <tr>
                        <td>${type.code}</td>
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

