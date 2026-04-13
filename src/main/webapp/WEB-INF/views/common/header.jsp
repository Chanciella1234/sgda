<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<div class="topbar">
    <div class="container">
        <span class="brand">SGDA</span>
        <c:if test="${not empty sessionScope.SGDA_AUTH_USER}">
            <span class="muted" style="margin-left: 1rem;">
                ${sessionScope.SGDA_AUTH_USER.fullName} - ${sessionScope.SGDA_AUTH_USER.roleLabel}
            </span>
        </c:if>
        <div style="margin-top: 0.5rem;">
            <c:choose>
                <c:when test="${sessionScope.SGDA_AUTH_USER.roleCode == 'ETUDIANT'}">
                    <a href="${pageContext.request.contextPath}/student/demandes">Mes demandes</a>
                    <a href="${pageContext.request.contextPath}/student/demande/new">Nouvelle demande</a>
                </c:when>
                <c:when test="${sessionScope.SGDA_AUTH_USER.roleCode == 'AGENT'}">
                    <a href="${pageContext.request.contextPath}/agent/demandes">Demandes a traiter</a>
                </c:when>
                <c:when test="${sessionScope.SGDA_AUTH_USER.roleCode == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin/demandes">Supervision</a>
                    <a href="${pageContext.request.contextPath}/admin/users">Utilisateurs</a>
                    <a href="${pageContext.request.contextPath}/admin/types">Types</a>
                </c:when>
            </c:choose>
            <c:if test="${not empty sessionScope.SGDA_AUTH_USER}">
                <a href="${pageContext.request.contextPath}/logout">Deconnexion</a>
            </c:if>
        </div>
    </div>
</div>

