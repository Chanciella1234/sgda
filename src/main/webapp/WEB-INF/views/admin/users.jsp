<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="pageSection"><fmt:message key="section.admin"/></c:set>
<c:set var="pageTitle"><fmt:message key="admin.users.page_title"/></c:set>
<c:set var="pageSubtitle"><fmt:message key="admin.users.page_subtitle"/></c:set>
<c:set var="activeMenu" value="users"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="admin.users.html_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>

<div class="page-grid">
    <div class="panel">
        <div class="panel-header">
            <div class="panel-title-group">
                <h2 class="panel-title"><c:choose><c:when test="${empty editUser}"><fmt:message key="admin.users.panel.title_new"/></c:when><c:otherwise><fmt:message key="admin.users.panel.title_edit"/></c:otherwise></c:choose></h2>
                <p class="panel-note"><fmt:message key="admin.users.panel.note"/></p>
            </div>
        </div>
        <div class="panel-body">
            <div class="form-shell">
                <div class="form-highlight">
                    <h3 class="form-highlight-title"><c:choose><c:when test="${empty editUser}"><fmt:message key="admin.users.highlight.title_new"/></c:when><c:otherwise><fmt:message key="admin.users.highlight.title_edit"/></c:otherwise></c:choose></h3>
                    <p class="form-highlight-text"><fmt:message key="admin.users.highlight.text"/></p>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/admin/user/save">
                    <c:if test="${not empty editUser}">
                        <input type="hidden" name="id" value="${editUser.id}">
                    </c:if>
                    <div class="form-grid">
                        <div class="field-card full">
                            <div class="field-title">
                                <label for="roleId"><fmt:message key="admin.users.field.role"/></label>
                                <span class="field-help"><fmt:message key="admin.users.field.role.help"/></span>
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
                                <label for="prenom"><fmt:message key="admin.users.field.prenom"/></label>
                                <span class="field-help"><fmt:message key="admin.users.field.prenom.help"/></span>
                            </div>
                            <input id="prenom" name="prenom" type="text" value="${editUser.prenom}" required>
                        </div>

                        <div class="field-card half">
                            <div class="field-title">
                                <label for="nom"><fmt:message key="admin.users.field.nom"/></label>
                                <span class="field-help"><fmt:message key="admin.users.field.nom.help"/></span>
                            </div>
                            <input id="nom" name="nom" type="text" value="${editUser.nom}" required>
                        </div>

                        <div class="field-card half">
                            <div class="field-title">
                                <label for="username"><fmt:message key="admin.users.field.username"/></label>
                                <span class="field-help"><fmt:message key="admin.users.field.username.help"/></span>
                            </div>
                            <input id="username" name="username" type="text" value="${editUser.username}" required>
                        </div>

                        <div class="field-card half">
                            <div class="field-title">
                                <label for="email"><fmt:message key="admin.users.field.email"/></label>
                                <span class="field-help"><fmt:message key="admin.users.field.email.help"/></span>
                            </div>
                            <input id="email" name="email" type="email" value="${editUser.email}" required>
                        </div>

                        <div class="field-card full">
                            <div class="field-title">
                                <label for="password"><fmt:message key="admin.users.field.password"/> <c:if test="${not empty editUser}"><fmt:message key="admin.users.field.password.keep"/></c:if></label>
                                <span class="field-help"><fmt:message key="admin.users.field.password.help"/></span>
                            </div>
                            <input id="password" name="password" type="password">
                        </div>

                        <div class="field-card full">
                            <label class="checkbox-inline">
                                <input type="checkbox" name="actif" <c:if test="${empty editUser || editUser.actif}">checked</c:if>>
<fmt:message key="admin.users.field.actif"/>
                                            </label>
                            <span class="field-help"><fmt:message key="admin.users.field.actif.help"/></span>
                        </div>
                    </div>

                    <div class="form-actions-bar">
                        <span class="form-actions-note"><fmt:message key="admin.users.form.note"/></span>
                        <div class="actions">
                            <button class="btn btn-primary" type="submit"><fmt:message key="admin.users.form.save"/></button>
                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/users"><fmt:message key="admin.users.form.new"/></a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="panel">
        <div class="panel-header">
            <div class="panel-title-group">
                <h2 class="panel-title"><fmt:message key="admin.users.list.title"/></h2>
                <p class="panel-note"><fmt:message key="admin.users.list.note"/></p>
            </div>
        </div>
        <div class="panel-body">
            <table class="table">
                <thead>
                <tr>
                    <th><fmt:message key="admin.users.table.header.nom"/></th>
                    <th><fmt:message key="admin.users.table.header.username"/></th>
                    <th><fmt:message key="admin.users.table.header.role"/></th>
                    <th><fmt:message key="admin.users.table.header.actif"/></th>
                    <th><fmt:message key="admin.users.table.header.actions"/></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="user" items="${utilisateurs}">
                    <tr>
                        <td>${user.nomComplet}</td>
                        <td>${user.username}</td>
                        <td>${user.role.libelle}</td>
                        <td><c:choose><c:when test="${user.actif}"><fmt:message key="profil.value.oui"/></c:when><c:otherwise><fmt:message key="profil.value.non"/></c:otherwise></c:choose></td>
                        <td>
                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/users?id=${user.id}">
                                <fmt:message key="admin.users.table.modifier"/>
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
