<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="error.page_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<div class="login-shell">
    <div class="error-card panel">
        <div class="panel-header">
            <div class="panel-title-group">
                <p class="panel-note"><fmt:message key="error.title"/></p>
                <h1 class="panel-title"><fmt:message key="error.heading"/></h1>
            </div>
        </div>
        <div class="panel-body">
            <p class="page-subtitle"><fmt:message key="error.message"/></p>
            <c:set var="errorMessage" value="${requestScope['jakarta.servlet.error.message']}"/>
            <c:set var="errorException" value="${requestScope['jakarta.servlet.error.exception']}"/>
            <c:set var="errorUri" value="${requestScope['jakarta.servlet.error.request_uri']}"/>
            <c:if test="${not empty errorUri}">
                <p><strong>URI :</strong> ${errorUri}</p>
            </c:if>
            <c:if test="${not empty errorException}">
                <div class="alert alert-error">
                    <strong><fmt:message key="error.technical"/></strong>
                    ${errorException.class.simpleName}
                    <c:if test="${not empty errorException.message}">
                        - ${errorException.message}
                    </c:if>
                </div>
            </c:if>
            <c:if test="${empty errorException and not empty errorMessage}">
                <div class="alert alert-error">
                    <strong><fmt:message key="error.technical"/></strong> ${errorMessage}
                </div>
            </c:if>
            <div class="actions">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/login"><fmt:message key="error.back"/></a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
