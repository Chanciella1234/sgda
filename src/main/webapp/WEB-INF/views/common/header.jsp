<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<div class="app-shell role-${sessionScope.SGDA_AUTH_USER.roleCode}">
    <div class="navbar">
        <div class="navbar-left">
            <button id="navToggle" class="nav-toggle" type="button" aria-label="Ouvrir le menu" aria-controls="appSidebar" aria-expanded="false">
                <span></span>
                <span></span>
                <span></span>
            </button>
            <div class="brand-stack">
                <span class="brand">SGDA</span>
                <span class="brand-meta">Systeme de Gestion des Demandes Academiques</span>
            </div>
        </div>

        <c:if test="${not empty sessionScope.SGDA_AUTH_USER}">
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
        </c:if>
    </div>

    <div class="layout">
        <aside id="appSidebar" class="sidebar sidebar-${sessionScope.SGDA_AUTH_USER.roleCode}">
            <div class="sidebar-top">
                <div class="sidebar-logo">
                    <span class="sidebar-logo-mark">SG</span>
                    <div class="sidebar-logo-copy">
                        <strong>SGDA</strong>
                        <span>Plateforme academique</span>
                    </div>
                </div>
                <nav class="sidebar-nav" aria-label="Navigation principale">
                    <span class="nav-section-label">Menu</span>
                    <c:choose>
                        <c:when test="${sessionScope.SGDA_AUTH_USER.roleCode == 'ETUDIANT'}">
                            <a class="nav-item${activeMenu == 'dashboard' ? ' active' : ''}" href="${pageContext.request.contextPath}/student/dashboard">
                                <span class="nav-dot"></span><span class="nav-icon icon-dashboard"></span><span class="nav-label" data-tooltip="Tableau de bord">Tableau de bord</span>
                            </a>

                            <a class="nav-item${activeMenu == 'demandes' ? ' active' : ''}" href="${pageContext.request.contextPath}/student/demandes">
                                <span class="nav-dot"></span><span class="nav-icon icon-demandes"></span><span class="nav-label" data-tooltip="Demandes en cours">Demandes en cours</span>
                            </a>
                            <a class="nav-item${activeMenu == 'new' ? ' active' : ''}" href="${pageContext.request.contextPath}/student/demande/new">
                                <span class="nav-dot"></span><span class="nav-icon icon-new"></span><span class="nav-label" data-tooltip="Créer une demande">Créer une demande</span>
                            </a>
                        </c:when>
                        <c:when test="${sessionScope.SGDA_AUTH_USER.roleCode == 'AGENT'}">
                            <a class="nav-item${activeMenu == 'dashboard' ? ' active' : ''}" href="${pageContext.request.contextPath}/agent/dashboard">
                                <span class="nav-dot"></span><span class="nav-icon icon-dashboard"></span><span class="nav-label" data-tooltip="Tableau de bord">Tableau de bord</span>
                            </a>
                            <a class="nav-item${activeMenu == 'demandes' ? ' active' : ''}" href="${pageContext.request.contextPath}/agent/demandes">
                                <span class="nav-dot"></span><span class="nav-icon icon-demandes"></span><span class="nav-label" data-tooltip="Demandes à prendre en charge">Demandes à prendre en charge</span>
                            </a>
                            <a class="nav-item${activeMenu == 'demandes-traitees' ? ' active' : ''}" href="${pageContext.request.contextPath}/agent/demandes-traitees">
                                <span class="nav-dot"></span><span class="nav-icon icon-traitees"></span><span class="nav-label" data-tooltip="Demandes prises en charge">Demandes prises en charge</span>
                            </a>
                        </c:when>
                        <c:when test="${sessionScope.SGDA_AUTH_USER.roleCode == 'ADMIN'}">
                            <a class="nav-item${activeMenu == 'dashboard' ? ' active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                                <span class="nav-dot"></span><span class="nav-icon icon-dashboard"></span><span class="nav-label" data-tooltip="Tableau de bord">Tableau de bord</span>
                            </a>
                            <a class="nav-item${activeMenu == 'demandes' ? ' active' : ''}" href="${pageContext.request.contextPath}/admin/demandes">
                                <span class="nav-dot"></span><span class="nav-icon icon-supervision"></span><span class="nav-label" data-tooltip="Tableau de supervision">Tableau de supervision</span>
                            </a>
                            <a class="nav-item${activeMenu == 'users' ? ' active' : ''}" href="${pageContext.request.contextPath}/admin/users">
                                <span class="nav-dot"></span><span class="nav-icon icon-users"></span><span class="nav-label" data-tooltip="Gestion des utilisateurs">Gestion des utilisateurs</span>
                            </a>
                            <a class="nav-item${activeMenu == 'types' ? ' active' : ''}" href="${pageContext.request.contextPath}/admin/types">
                                <span class="nav-dot"></span><span class="nav-icon icon-types"></span><span class="nav-label" data-tooltip="Gestion des types de demandes">Gestion des types de demandes</span>
                            </a>
                        </c:when>
                    </c:choose>

                    <span class="nav-section-label">Compte</span>
                    <c:set var="roleProfilUrl" value="profil"/>
                    <c:if test="${sessionScope.SGDA_AUTH_USER.roleCode == 'ETUDIANT'}"><c:set var="roleProfilUrl" value="student/profil"/></c:if>
                    <c:if test="${sessionScope.SGDA_AUTH_USER.roleCode == 'AGENT'}"><c:set var="roleProfilUrl" value="agent/profil"/></c:if>
                    <c:if test="${sessionScope.SGDA_AUTH_USER.roleCode == 'ADMIN'}"><c:set var="roleProfilUrl" value="admin/profil"/></c:if>
                    <a class="nav-item${activeMenu == 'profil' ? ' active' : ''}" href="${pageContext.request.contextPath}/${roleProfilUrl}">
                        <span class="nav-dot"></span><span class="nav-icon icon-profil"></span><span class="nav-label" data-tooltip="Mon profil">Mon profil</span>
                    </a>
                </nav>
            </div>

            <div class="sidebar-bottom">
                <a class="logout-btn" href="${pageContext.request.contextPath}/logout"
                    data-confirm="Votre session SGDA sera fermee immediatement."
                    data-confirm-title="Confirmer la deconnexion"
                    data-confirm-confirm-label="Se deconnecter"
                    data-confirm-cancel-label="Rester connecte"
                    data-confirm-variant="neutral">
                    <span class="logout-icon"></span>Deconnexion
                </a>
            </div>
        </aside>
        <button type="button" class="sidebar-overlay" data-sidebar-close aria-label="Fermer le menu"></button>
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
