<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="isEdit" value="${not empty demande or not empty editId}"/>
<fmt:message key="section.etudiant" var="pageSection"/>
<c:choose>
    <c:when test="${isEdit}">
        <fmt:message key="student.form.page_title_edit" var="pageTitle"/>
        <fmt:message key="student.form.page_subtitle_edit" var="pageSubtitle"/>
    </c:when>
    <c:otherwise>
        <fmt:message key="student.form.page_title_new" var="pageTitle"/>
        <fmt:message key="student.form.page_subtitle_new" var="pageSubtitle"/>
    </c:otherwise>
</c:choose>
<c:set var="activeMenu" value="${isEdit ? 'demandes' : 'new'}"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="student.form.html_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>

<div class="panel">
    <div class="panel-header">
        <div class="panel-title-group">
            <h2 class="panel-title"><c:choose><c:when test="${isEdit}"><fmt:message key="student.form.panel.title_edit"/></c:when><c:otherwise><fmt:message key="student.form.panel.title_new"/></c:otherwise></c:choose></h2>
            <p class="panel-note"><fmt:message key="student.form.panel.note"/></p>
        </div>
    </div>
    <div class="panel-body">
        <div class="form-shell">
            <div class="form-highlight">
                <h3 class="form-highlight-title"><c:choose><c:when test="${isEdit}"><fmt:message key="student.form.highlight.title_edit"/></c:when><c:otherwise><fmt:message key="student.form.highlight.title_new"/></c:otherwise></c:choose></h3>
                <p class="form-highlight-text">
                    <fmt:message key="student.form.highlight.text"/>
                </p>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/student/demande/save">
                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${empty demande ? editId : demande.id}">
                </c:if>
                <div class="form-grid">
                    <div class="field-card half">
                        <div class="field-title">
                            <label for="typeDemandeId"><fmt:message key="student.form.label.type"/></label>
                            <span class="field-help"><fmt:message key="student.form.label.type.help"/></span>
                        </div>
                        <select id="typeDemandeId" name="typeDemandeId" required>
                            <option value=""><fmt:message key="student.form.label.type.select"/></option>
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
                            <label for="objet"><fmt:message key="student.form.label.objet"/></label>
                            <span class="field-help"><fmt:message key="student.form.label.objet.help"/></span>
                        </div>
                        <input id="objet" name="objet" type="text" value="${not empty objet ? objet : demande.objet}" required>
                    </div>

                    <div class="field-card full">
                        <div class="field-title">
                            <label for="description"><fmt:message key="student.form.label.description"/></label>
                            <span class="field-help"><fmt:message key="student.form.label.description.help"/></span>
                        </div>
                        <textarea id="description" name="description">${not empty description ? description : demande.description}</textarea>
                    </div>
                </div>

                <div class="form-actions-bar">
                    <span class="form-actions-note"><fmt:message key="student.form.note"/></span>
                    <div class="actions">
                        <button class="btn btn-primary" type="submit"><fmt:message key="student.form.btn.save"/></button>
                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/student/demandes"><fmt:message key="student.form.btn.back"/></a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
