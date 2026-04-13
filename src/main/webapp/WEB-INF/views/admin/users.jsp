<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Utilisateurs - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="container">
    <div class="page-grid">
        <div class="panel">
            <h2>${empty editUser ? 'Nouvel utilisateur' : 'Modifier utilisateur'}</h2>
            <jsp:include page="/WEB-INF/views/common/flash.jsp"/>
            <form method="post" action="${pageContext.request.contextPath}/admin/user/save">
                <c:if test="${not empty editUser}">
                    <input type="hidden" name="id" value="${editUser.id}">
                </c:if>
                <div class="form-row">
                    <label for="roleId">Role</label>
                    <select id="roleId" name="roleId" required>
                        <c:forEach var="role" items="${roles}">
                            <option value="${role.id}"
                                    <c:if test="${not empty editUser && role.id == editUser.role.id}">selected</c:if>>
                                ${role.libelle}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-row inline">
                    <div>
                        <label for="prenom">Prenom</label>
                        <input id="prenom" name="prenom" type="text" value="${editUser.prenom}" required>
                    </div>
                    <div>
                        <label for="nom">Nom</label>
                        <input id="nom" name="nom" type="text" value="${editUser.nom}" required>
                    </div>
                </div>
                <div class="form-row inline">
                    <div>
                        <label for="username">Username</label>
                        <input id="username" name="username" type="text" value="${editUser.username}" required>
                    </div>
                    <div>
                        <label for="email">Email</label>
                        <input id="email" name="email" type="email" value="${editUser.email}" required>
                    </div>
                </div>
                <div class="form-row">
                    <label for="password">Mot de passe ${empty editUser ? '' : '(laisser vide pour conserver)'}</label>
                    <input id="password" name="password" type="password">
                </div>
                <div class="form-row">
                    <label>
                        <input type="checkbox" name="actif"
                               <c:if test="${empty editUser || editUser.actif}">checked</c:if>>
                        Compte actif
                    </label>
                </div>
                <div class="actions">
                    <button class="btn btn-primary" type="submit">Enregistrer</button>
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/users">Nouveau</a>
                </div>
            </form>
        </div>
        <div class="panel">
            <h2>Liste des utilisateurs</h2>
            <table class="table">
                <thead>
                <tr>
                    <th>Nom</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Actif</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="user" items="${utilisateurs}">
                    <tr>
                        <td>${user.nomComplet}</td>
                        <td>${user.username}</td>
                        <td>${user.role.libelle}</td>
                        <td>${user.actif ? 'Oui' : 'Non'}</td>
                        <td>
                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/users?id=${user.id}">
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

