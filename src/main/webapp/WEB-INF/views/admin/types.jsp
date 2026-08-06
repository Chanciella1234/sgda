<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="pageSection"><fmt:message key="section.admin"/></c:set>
<c:set var="pageTitle"><fmt:message key="admin.types.page_title"/></c:set>
<c:set var="pageSubtitle"><fmt:message key="admin.types.page_subtitle"/></c:set>
<c:set var="activeMenu" value="types"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="admin.types.html_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>

<div class="page-grid">
    <div class="panel">
        <div class="panel-header">
            <div class="panel-title-group">
                <h2 class="panel-title"><c:choose><c:when test="${empty editType}"><fmt:message key="admin.types.panel.title_new"/></c:when><c:otherwise><fmt:message key="admin.types.panel.title_edit"/></c:otherwise></c:choose></h2>
                <p class="panel-note"><fmt:message key="admin.types.panel.note"/></p>
            </div>
        </div>
        <div class="panel-body">
            <div class="form-shell">
                <div class="form-highlight">
                    <h3 class="form-highlight-title"><c:choose><c:when test="${empty editType}"><fmt:message key="admin.types.highlight.title_new"/></c:when><c:otherwise><fmt:message key="admin.types.highlight.title_edit"/></c:otherwise></c:choose></h3>
                    <p class="form-highlight-text"><fmt:message key="admin.types.highlight.text"/></p>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/admin/type/save">
                    <c:if test="${not empty editType}">
                        <input type="hidden" name="id" value="${editType.id}">
                    </c:if>
                    <div class="form-grid">
                        <div class="field-card half">
                            <div class="field-title">
                                <label for="code"><fmt:message key="admin.types.field.code"/></label>
                                <span class="field-help"><fmt:message key="admin.types.field.code.help"/></span>
                            </div>
                            <input id="code" name="code" type="text" value="${editType.code}" required>
                        </div>

                        <div class="field-card half">
                            <div class="field-title">
                                <label for="libelle"><fmt:message key="admin.types.field.libelle"/></label>
                                <span class="field-help"><fmt:message key="admin.types.field.libelle.help"/></span>
                            </div>
                            <input id="libelle" name="libelle" type="text" value="${editType.libelle}" required>
                        </div>

                        <div class="field-card full">
                            <div class="field-title">
                                <label for="description"><fmt:message key="admin.types.field.description"/></label>
                                <span class="field-help"><fmt:message key="admin.types.field.description.help"/></span>
                            </div>
                            <textarea id="description" name="description">${editType.description}</textarea>
                        </div>

                        <div class="field-card full">
                            <label class="checkbox-inline">
                                <input type="checkbox" name="actif" <c:if test="${empty editType || editType.actif}">checked</c:if>>
<fmt:message key="admin.types.field.actif"/>
                                            </label>
                            <span class="field-help"><fmt:message key="admin.types.field.actif.help"/></span>
                        </div>
                    </div>

                    <div class="form-actions-bar">
                        <span class="form-actions-note"><fmt:message key="admin.types.form.note"/></span>
                        <div class="actions">
                            <button class="btn btn-primary" type="submit"><fmt:message key="admin.types.form.save"/></button>
                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/types"><fmt:message key="admin.types.form.new"/></a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="panel">
        <div class="panel-header">
            <div class="panel-title-group">
                <h2 class="panel-title"><fmt:message key="admin.types.list.title"/></h2>
                <p class="panel-note"><fmt:message key="admin.types.list.note"/></p>
            </div>
        </div>
        <div class="panel-body">
            <table class="table">
                <thead>
                <tr>
                    <th><fmt:message key="admin.types.table.header.code"/></th>
                    <th><fmt:message key="admin.types.table.header.libelle"/></th>
                    <th><fmt:message key="admin.types.table.header.actif"/></th>
                    <th><fmt:message key="admin.types.table.header.actions"/></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="type" items="${types}">
                    <tr>
                        <td class="code-text">${type.code}</td>
                        <td>${type.libelle}</td>
                        <td><c:choose><c:when test="${type.actif}"><fmt:message key="profil.value.oui"/></c:when><c:otherwise><fmt:message key="profil.value.non"/></c:otherwise></c:choose></td>
                        <td>
                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/types?id=${type.id}">
                                <fmt:message key="admin.types.table.modifier"/>
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
