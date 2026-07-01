<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="pageSection" value="Espace etudiant"/>
<c:set var="pageTitle" value="Dashboard etudiant"/>
<c:set var="pageSubtitle" value="Suivez vos brouillons, vos demandes en cours et l historique recent de votre espace SGDA."/>
<c:set var="activeMenu" value="dashboard"/>
<c:set var="prenomUtilisateur" value="${fn:split(sessionScope.SGDA_AUTH_USER.fullName, ' ')[0]}"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard etudiant - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<section class="hero-card">
    <div class="hero-grid">
        <div>
            <div class="hero-kicker">Espace personnel</div>
            <h2 class="hero-title">Bonjour, ${prenomUtilisateur} !</h2>
            <p class="hero-subtitle">Bienvenue sur votre espace de gestion des demandes. Nous y retrouvons vos brouillons, vos suivis en cours et toutes les actions utiles pour avancer rapidement.</p>
            <div class="hero-actions">
                <a class="btn btn-white btn-lg" href="${pageContext.request.contextPath}/student/demande/new">Nouvelle demande</a>
                <a class="btn btn-contour btn-lg" href="${pageContext.request.contextPath}/student/demandes">Voir mes demandes</a>
            </div>
        </div>
        <div class="hero-illustration" aria-hidden="true">
            <span class="hero-orb orb-1"></span>
            <span class="hero-orb orb-2"></span>
        </div>
    </div>
</section>

<section class="dashboard-row cols-4">
    <article class="kpi-card kpi-primary">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#128196;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label">Mes demandes</span>
            <strong class="kpi-value">${dashboard.totalDemandes}</strong>
            <span class="kpi-trend">Toutes vos demandes confondues</span>
        </div>
    </article>

    <article class="kpi-card kpi-warning">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#9716;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label">En cours</span>
            <strong class="kpi-value">${dashboard.demandesEnCours}</strong>
            <span class="kpi-trend">Demandes soumises ou en attente de traitement</span>
        </div>
    </article>

    <article class="kpi-card kpi-success">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#10003;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label">Validees</span>
            <strong class="kpi-value">${dashboard.demandesValidees}</strong>
            <span class="kpi-trend">Demandes acceptees par l administration</span>
        </div>
    </article>

    <article class="kpi-card kpi-neutral">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#9998;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label">Brouillons</span>
            <strong class="kpi-value">${dashboard.demandesBrouillons}</strong>
            <span class="kpi-trend">Demandes preparees mais non encore soumises</span>
        </div>
    </article>
</section>

<section class="chart-two-column">
    <article class="content-card">
        <div class="content-card-header">
            <div>
                <h2 class="content-card-title">Etat de mes demandes</h2>
                <p class="content-card-subtitle">Vue globale de votre portefeuille personnel par statut.</p>
            </div>
        </div>
        <div class="content-card-body">
            <c:choose>
                <c:when test="${dashboard.totalDemandes == 0}">
                    <div class="empty-rich">
                        <div class="empty-illustration">&#43;</div>
                        <h3 class="empty-title">Aucune demande pour le moment</h3>
                        <p class="empty-text">Nous pouvons commencer par creer votre premiere demande administrative depuis cet espace.</p>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/student/demande/new">Creer ma premiere demande</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="doughnut-layout">
                        <div class="doughnut-wrap">
                            <div class="chart-shell chart-doughnut">
                                <canvas id="studentStatusChart"></canvas>
                            </div>
                            <div class="doughnut-center">
                                <strong>${dashboard.totalDemandes}</strong>
                                <span>Total</span>
                            </div>
                        </div>
                        <div class="legend-list">
                            <div class="legend-item">
                                <div class="legend-item-left"><span class="status-swatch status-brouillon"></span>Brouillons</div>
                                <span>${dashboard.demandesBrouillons}</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-item-left"><span class="status-swatch status-attente"></span>En cours</div>
                                <span>${dashboard.demandesEnCours}</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-item-left"><span class="status-swatch status-validee"></span>Validees</div>
                                <span>${dashboard.demandesValidees}</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-item-left"><span class="status-swatch status-refusee"></span>Refusees</div>
                                <span>${dashboard.demandesRefusees}</span>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </article>

    <article class="content-card">
        <div class="content-card-header">
            <div>
                <h2 class="content-card-title">Historique recent</h2>
                <p class="content-card-subtitle">Vos cinq derniers dossiers avec leur etat le plus recent.</p>
            </div>
        </div>
        <div class="content-card-body">
            <c:choose>
                <c:when test="${empty dashboard.dernieresDemandes}">
                    <div class="empty-rich">
                        <div class="empty-illustration">&#8226;</div>
                        <h3 class="empty-title">Pas encore d historique</h3>
                        <p class="empty-text">Vos demandes recentes apparaitront ici des leur creation.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="timeline">
                        <c:forEach var="demande" items="${dashboard.dernieresDemandes}">
                            <c:set var="dateCreationText" value="${fn:substring(fn:replace(demande.dateCreation, 'T', ' '), 0, 16)}"/>
                            <c:set var="timelineStatusClass" value="status-brouillon"/>
                            <c:choose>
                                <c:when test="${demande.etat.code == 'SOUMISE'}">
                                    <c:set var="timelineStatusClass" value="status-soumise"/>
                                </c:when>
                                <c:when test="${demande.etat.code == 'EN_ATTENTE'}">
                                    <c:set var="timelineStatusClass" value="status-attente"/>
                                </c:when>
                                <c:when test="${demande.etat.code == 'VALIDEE'}">
                                    <c:set var="timelineStatusClass" value="status-validee"/>
                                </c:when>
                                <c:when test="${demande.etat.code == 'REFUSEE'}">
                                    <c:set var="timelineStatusClass" value="status-refusee"/>
                                </c:when>
                                <c:when test="${demande.etat.code == 'ARCHIVEE'}">
                                    <c:set var="timelineStatusClass" value="status-archivee"/>
                                </c:when>
                            </c:choose>
                            <div class="timeline-item">
                                <span class="timeline-dot ${timelineStatusClass}"></span>
                                <div class="timeline-content">
                                    <span class="timeline-date">${dateCreationText}</span>
                                    <strong>${demande.code}</strong>
                                    <span class="muted">${demande.typeDemande.libelle}</span>
                                </div>
                                <div class="actions">
                                    <span class="badge badge-${demande.etat.code}">${demande.etat.libelle}</span>
                                    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/student/demande/detail?id=${demande.id}">Voir</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </article>
</section>

<section class="content-card table-card">
    <div class="content-card-header">
        <div>
            <h2 class="content-card-title">Mes demandes</h2>
            <p class="content-card-subtitle">Toutes vos demandes avec les actions disponibles selon leur etat.</p>
        </div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/student/demande/new">+ Nouvelle demande</a>
    </div>
    <div class="content-card-body">
        <c:choose>
            <c:when test="${empty demandes}">
                <div class="empty-rich">
                    <div class="empty-illustration">&#128196;</div>
                    <h3 class="empty-title">Aucune demande enregistree</h3>
                    <p class="empty-text">Creez votre premiere demande pour commencer a suivre vos traitements administratifs depuis SGDA.</p>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/student/demande/new">Nouvelle demande</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-scroller">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>Code</th>
                            <th>Type</th>
                            <th>Date creation</th>
                            <th>Date soumission</th>
                            <th>Etat</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="demande" items="${demandes}">
                            <c:set var="dateCreationText" value="${fn:substring(fn:replace(demande.dateCreation, 'T', ' '), 0, 16)}"/>
                            <c:set var="dateSoumissionText" value="${empty demande.dateSoumission ? '' : fn:substring(fn:replace(demande.dateSoumission, 'T', ' '), 0, 16)}"/>
                            <tr>
                                <td class="code-text">${demande.code}</td>
                                <td>${demande.typeDemande.libelle}</td>
                                <td>${dateCreationText}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty dateSoumissionText}">-</c:when>
                                        <c:otherwise>${dateSoumissionText}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><span class="badge badge-${demande.etat.code}">${demande.etat.libelle}</span></td>
                                <td>
                                    <div class="actions">
                                        <c:choose>
                                            <c:when test="${demande.etat.code == 'BROUILLON'}">
                                                <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/student/demande/edit?id=${demande.id}">Modifier</a>
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/student/demande/delete"
                                                      data-confirm="La demande ${demande.code} sera supprimee definitivement de votre espace."
                                                      data-confirm-title="Supprimer la demande"
                                                      data-confirm-confirm-label="Supprimer"
                                                      data-confirm-cancel-label="Annuler"
                                                      data-confirm-variant="danger">
                                                    <input type="hidden" name="id" value="${demande.id}">
                                                    <button class="btn btn-danger btn-sm" type="submit">Supprimer</button>
                                                </form>
                                            </c:when>
                                            <c:when test="${demande.etat.code == 'SOUMISE' || demande.etat.code == 'EN_ATTENTE'}">
                                                <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/student/demande/detail?id=${demande.id}">Voir detail</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/student/demande/detail?id=${demande.id}">Voir detail</a>
                                                <!-- <a class="btn btn-contour btn-sm" href="${pageContext.request.contextPath}/student/demande/new">Nouveau brouillon</a> -->
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    window.sgdaCharts = window.sgdaCharts || {};

    var chartCanvas = document.getElementById('studentStatusChart');
    if (!chartCanvas) {
        return;
    }

    if (window.sgdaCharts.studentStatusChart) {
        window.sgdaCharts.studentStatusChart.destroy();
    }

    window.sgdaCharts.studentStatusChart = new Chart(chartCanvas, {
        type: 'doughnut',
        data: {
            labels: ['Brouillons', 'En cours', 'Validees', 'Refusees'],
            datasets: [{
                data: [
                    Number('${dashboard.demandesBrouillons}'),
                    Number('${dashboard.demandesEnCours}'),
                    Number('${dashboard.demandesValidees}'),
                    Number('${dashboard.demandesRefusees}')
                ],
                backgroundColor: ['#888780', '#D84315', '#4A5C2A', '#BF360C'],
                borderWidth: 0,
                hoverOffset: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '65%',
            plugins: {
                legend: { display: false }
            }
        }
    });
});
</script>
</body>
</html>
