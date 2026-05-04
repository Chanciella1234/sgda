<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageSection" value="Administration"/>
<c:set var="pageTitle" value="Gestion des utilisateurs"/>
<c:set var="pageSubtitle" value="Cree, modifie ou desactive les comptes selon les roles du systeme."/>
<c:set var="activeMenu" value="users"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Utilisateurs - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>

<div class="page-grid">
    <div class="panel">
        <div class="panel-header">
            <div class="panel-title-group">
                <h2 class="panel-title">${empty editUser ? 'Nouvel utilisateur' : 'Modifier utilisateur'}</h2>
                <p class="panel-note">Renseigne les informations du compte et son role d acces.</p>
            </div>
        </div>
        <div class="panel-body">
            <div class="form-shell">
                <div class="form-highlight">
                    <h3 class="form-highlight-title">${empty editUser ? 'Creer un compte utilisateur' : 'Mettre a jour un compte'}</h3>
                    <p class="form-highlight-text">
                        Definis le role, l identite et les acces de l utilisateur. Le mot de passe peut etre laisse vide lors d une modification pour conserver l actuel.
                    </p>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/admin/user/save">
                    <c:if test="${not empty editUser}">
                        <input type="hidden" name="id" value="${editUser.id}">
                    </c:if>
                    <div class="form-grid">
                        <div class="field-card full">
                            <div class="field-title">
                                <label for="roleId">Role</label>
                                <span class="field-help">Choisis le niveau d acces accorde a cet utilisateur dans le systeme.</span>
                            </div>
                            <select id="roleId" name="roleId" required>
                                <c:forEach var="role" items="${roles}">
                                    <option value="${role.id}" <c:if test="${not empty editUser && role.id == editUser.role.id}">selected</c:if>>
                                        ${role.libelle}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="field-card half">
                            <div class="field-title">
                                <label for="prenom">Prenom</label>
                                <span class="field-help">Prenom affiche dans les tableaux de bord et l historique.</span>
                            </div>
                            <input id="prenom" name="prenom" type="text" value="${editUser.prenom}" required>
                        </div>

                        <div class="field-card half">
                            <div class="field-title">
                                <label for="nom">Nom</label>
                                <span class="field-help">Nom de famille de l utilisateur.</span>
                            </div>
                            <input id="nom" name="nom" type="text" value="${editUser.nom}" required>
                        </div>

                        <div class="field-card half">
                            <div class="field-title">
                                <label for="username">Username</label>
                                <span class="field-help">Identifiant court utilise a la connexion.</span>
                            </div>
                            <input id="username" name="username" type="text" value="${editUser.username}" required>
                        </div>

                        <div class="field-card half">
                            <div class="field-title">
                                <label for="email">Email</label>
                                <span class="field-help">Adresse email acceptee egalement sur l ecran de connexion.</span>
                            </div>
                            <input id="email" name="email" type="email" value="${editUser.email}" required>
                        </div>

                        <div class="field-card full">
                            <div class="field-title">
                                <label for="password">Mot de passe ${empty editUser ? '' : '(laisser vide pour conserver)'}</label>
                                <span class="field-help">Utilise un mot de passe suffisamment robuste pour le premier acces.</span>
                            </div>
                            <input id="password" name="password" type="password">
                        </div>

                        <div class="field-card full">
                            <label class="checkbox-inline">
                                <input type="checkbox" name="actif" <c:if test="${empty editUser || editUser.actif}">checked</c:if>>
                                Compte actif
                            </label>
                            <span class="field-help">Un compte inactif ne pourra plus ouvrir de session, mais restera historise dans les donnees.</span>
                        </div>
                    </div>

                    <div class="form-actions-bar">
                        <span class="form-actions-note">Les changements prennent effet des l enregistrement du formulaire.</span>
                        <div class="actions">
                            <button class="btn btn-primary" type="submit">Enregistrer</button>
                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/users">Nouveau</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="panel">
        <div class="panel-header">
            <div class="panel-title-group">
                <h2 class="panel-title">Liste des utilisateurs</h2>
                <p class="panel-note">Edition rapide des comptes existants.</p>
            </div>
        </div>
        <div class="panel-body">
            <table class="table">
                <thead>
                <tr>
                    <th>Nom</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Actif</th>
                    <th>Actions</th>
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
