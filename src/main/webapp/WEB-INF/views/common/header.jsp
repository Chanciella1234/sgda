<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="i18n.jsp" %>
<div class="app-shell role-${sessionScope.SGDA_AUTH_USER.roleCode}">
    <div class="navbar">
        <div class="navbar-left">
            <button id="navToggle" class="nav-toggle" type="button" aria-label="<fmt:message key="app.navtoggle.aria"/>" aria-controls="appSidebar" aria-expanded="false">
                <span></span>
                <span></span>
                <span></span>
            </button>
            <div class="brand-stack">
                <span class="brand">SGDA</span>
                <span class="brand-meta"><fmt:message key="app.brand.meta"/></span>
            </div>
        </div>

        <c:if test="${not empty sessionScope.SGDA_AUTH_USER}">
            <c:set var="roleProfilUrl" value="profil"/>
            <c:if test="${sessionScope.SGDA_AUTH_USER.roleCode == 'ETUDIANT'}"><c:set var="roleProfilUrl" value="student/profil"/></c:if>
            <c:if test="${sessionScope.SGDA_AUTH_USER.roleCode == 'AGENT'}"><c:set var="roleProfilUrl" value="agent/profil"/></c:if>
            <c:if test="${sessionScope.SGDA_AUTH_USER.roleCode == 'ADMIN'}"><c:set var="roleProfilUrl" value="admin/profil"/></c:if>
            <div class="user-dropdown">
                <button class="user-dropdown-trigger" type="button" aria-haspopup="true" aria-expanded="false">
                    <div class="user-info">
                        <div class="avatar avatar-${sessionScope.SGDA_AUTH_USER.roleCode}">
                            <c:choose>
                                <c:when test="${sessionScope.SGDA_AUTH_USER.roleCode == 'ADMIN'}">AD</c:when>
                                <c:when test="${sessionScope.SGDA_AUTH_USER.roleCode == 'AGENT'}">AG</c:when>
                                <c:otherwise>ET</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="user-copy">
                            <div class="username">${sessionScope.SGDA_AUTH_USER.fullName}</div>
                            <div class="user-meta">
                                <span class="user-role">${sessionScope.SGDA_AUTH_USER.roleLabel}</span>
                                <span class="user-name-id">@${sessionScope.SGDA_AUTH_USER.username}</span>
                            </div>
                        </div>
                    </div>
                    <span class="dropdown-arrow"></span>
                </button>
                <div class="user-dropdown-menu" role="menu">
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/${roleProfilUrl}" role="menuitem">
                        <span class="dropdown-icon icon-profil"></span>
                        <span><fmt:message key="user.mon_profil"/></span>
                    </a>
                    <button class="dropdown-item" type="button" data-open-settings role="menuitem">
                        <span class="dropdown-icon icon-settings"></span>
                        <span><fmt:message key="user.parametres"/></span>
                    </button>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item dropdown-item-danger" href="${pageContext.request.contextPath}/logout"
                        data-confirm="<fmt:message key="user.confirm.message"/>"
                        data-confirm-title="<fmt:message key="user.confirm.title"/>"
                        data-confirm-confirm-label="<fmt:message key="user.confirm.confirm"/>"
                        data-confirm-cancel-label="<fmt:message key="user.confirm.cancel"/>"
                        data-confirm-variant="neutral" role="menuitem">
                        <span class="dropdown-icon icon-logout"></span>
                        <span><fmt:message key="user.deconnexion"/></span>
                    </a>
                </div>
            </div>
        </c:if>
    </div>

    <div class="layout">
        <aside id="appSidebar" class="sidebar sidebar-${sessionScope.SGDA_AUTH_USER.roleCode}">
            <div class="sidebar-top">
                <div class="sidebar-logo">
                    <span class="sidebar-logo-mark">SG</span>
                    <div class="sidebar-logo-copy">
                        <strong>SGDA</strong>
                        <span><fmt:message key="app.sidebar.logo.subtitle"/></span>
                    </div>
                </div>
                <nav class="sidebar-nav" aria-label="<fmt:message key="nav.menu"/>">
                    <span class="nav-section-label"><fmt:message key="nav.menu"/></span>
                    <c:choose>
                        <c:when test="${sessionScope.SGDA_AUTH_USER.roleCode == 'ETUDIANT'}">
                            <a class="nav-item${activeMenu == 'dashboard' ? ' active' : ''}" href="${pageContext.request.contextPath}/student/dashboard">
                                <span class="nav-dot"></span><span class="nav-icon icon-dashboard"></span><span class="nav-label" data-tooltip="<fmt:message key="nav.dashboard"/>"><fmt:message key="nav.dashboard"/></span>
                            </a>

                            <a class="nav-item${activeMenu == 'demandes' ? ' active' : ''}" href="${pageContext.request.contextPath}/student/demandes">
                                <span class="nav-dot"></span><span class="nav-icon icon-demandes"></span><span class="nav-label" data-tooltip="<fmt:message key="nav.demandes.en_cours"/>"><fmt:message key="nav.demandes.en_cours"/></span>
                            </a>
                            <a class="nav-item${activeMenu == 'new' ? ' active' : ''}" href="${pageContext.request.contextPath}/student/demande/new">
                                <span class="nav-dot"></span><span class="nav-icon icon-new"></span><span class="nav-label" data-tooltip="<fmt:message key="nav.creer_demande"/>"><fmt:message key="nav.creer_demande"/></span>
                            </a>
                        </c:when>
                        <c:when test="${sessionScope.SGDA_AUTH_USER.roleCode == 'AGENT'}">
                            <a class="nav-item${activeMenu == 'dashboard' ? ' active' : ''}" href="${pageContext.request.contextPath}/agent/dashboard">
                                <span class="nav-dot"></span><span class="nav-icon icon-dashboard"></span><span class="nav-label" data-tooltip="<fmt:message key="nav.dashboard"/>"><fmt:message key="nav.dashboard"/></span>
                            </a>
                            <a class="nav-item${activeMenu == 'demandes' ? ' active' : ''}" href="${pageContext.request.contextPath}/agent/demandes">
                                <span class="nav-dot"></span><span class="nav-icon icon-demandes"></span><span class="nav-label" data-tooltip="<fmt:message key="nav.demandes.prendre"/>"><fmt:message key="nav.demandes.prendre"/></span>
                            </a>
                            <a class="nav-item${activeMenu == 'demandes-traitees' ? ' active' : ''}" href="${pageContext.request.contextPath}/agent/demandes-traitees">
                                <span class="nav-dot"></span><span class="nav-icon icon-traitees"></span><span class="nav-label" data-tooltip="<fmt:message key="nav.demandes.prises"/>"><fmt:message key="nav.demandes.prises"/></span>
                            </a>
                        </c:when>
                        <c:when test="${sessionScope.SGDA_AUTH_USER.roleCode == 'ADMIN'}">
                            <a class="nav-item${activeMenu == 'dashboard' ? ' active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                                <span class="nav-dot"></span><span class="nav-icon icon-dashboard"></span><span class="nav-label" data-tooltip="<fmt:message key="nav.dashboard"/>"><fmt:message key="nav.dashboard"/></span>
                            </a>
                            <a class="nav-item${activeMenu == 'demandes' ? ' active' : ''}" href="${pageContext.request.contextPath}/admin/demandes">
                                <span class="nav-dot"></span><span class="nav-icon icon-supervision"></span><span class="nav-label" data-tooltip="<fmt:message key="nav.supervision"/>"><fmt:message key="nav.supervision"/></span>
                            </a>
                            <a class="nav-item${activeMenu == 'users' ? ' active' : ''}" href="${pageContext.request.contextPath}/admin/users">
                                <span class="nav-dot"></span><span class="nav-icon icon-users"></span><span class="nav-label" data-tooltip="<fmt:message key="nav.gestion_utilisateurs"/>"><fmt:message key="nav.gestion_utilisateurs"/></span>
                            </a>
                            <a class="nav-item${activeMenu == 'types' ? ' active' : ''}" href="${pageContext.request.contextPath}/admin/types">
                                <span class="nav-dot"></span><span class="nav-icon icon-types"></span><span class="nav-label" data-tooltip="<fmt:message key="nav.gestion_types"/>"><fmt:message key="nav.gestion_types"/></span>
                            </a>
                        </c:when>
                    </c:choose>
                </nav>
            </div>

            <div class="sidebar-bottom">
                <a class="logout-btn" href="${pageContext.request.contextPath}/logout"
                    data-confirm="<fmt:message key="user.confirm.message"/>"
                    data-confirm-title="<fmt:message key="user.confirm.title"/>"
                    data-confirm-confirm-label="<fmt:message key="user.confirm.confirm"/>"
                    data-confirm-cancel-label="<fmt:message key="user.confirm.cancel"/>"
                    data-confirm-variant="neutral">
                    <span class="logout-icon"></span><fmt:message key="user.deconnexion"/>
                </a>
            </div>
        </aside>
        <button type="button" class="sidebar-overlay" data-sidebar-close aria-label="<fmt:message key="app.sidebar.overlay.aria"/>"></button>
        <div class="main">
            <div class="main-inner">
                <c:if test="${not empty pageTitle}">
                    <div class="page-head">
                        <div class="page-head-main">
                            <div class="page-kicker">${empty pageSection ? sessionScope.SGDA_AUTH_USER.roleLabel : pageSection}</div>
                            <h1 class="page-title">${pageTitle}</h1>
                            <c:if test="${not empty pageSubtitle}">
                                <p class="page-subtitle">${pageSubtitle}</p>
                            </c:if>
                        </div>
                    </div>
                </c:if>