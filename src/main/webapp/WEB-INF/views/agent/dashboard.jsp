<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="pageSection" value="Espace agent"/>
<c:set var="pageTitle" value="Dashboard agent"/>
<c:set var="pageSubtitle" value="Vue de pilotage pour les demandes a traiter, votre portefeuille en cours et vos decisions."/>
<c:set var="activeMenu" value="dashboard"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard agent - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="breadcrumbs">
    <span>SGDA</span>
    <span>/</span>
    <span>Agent</span>
    <span>/</span>
    <strong>Dashboard</strong>
</div>

<section class="dashboard-row cols-4">
    <article class="kpi-card kpi-warning">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#9716;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label">Demandes a traiter</span>
            <strong class="kpi-value">${dashboard.demandesATraiter}</strong>
            <span class="kpi-trend">Nouvelles demandes encore sans prise en charge</span>
        </div>
    </article>

    <article class="kpi-card kpi-primary">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#128450;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label">Demandes en cours</span>
            <strong class="kpi-value">${dashboard.demandesEnCours}</strong>
            <span class="kpi-trend">${dashboard.totalDemandesTraitees} traitees au total par vous</span>
        </div>
    </article>

    <article class="kpi-card kpi-success">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#10003;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label">Validees par moi</span>
            <strong class="kpi-value">${dashboard.demandesValideesParAgent}</strong>
            <span class="kpi-trend">Decisions favorables finalisees</span>
        </div>
    </article>

    <article class="kpi-card kpi-danger">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#10005;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label">Refusees par moi</span>
            <strong class="kpi-value">${dashboard.demandesRefuseesParAgent}</strong>
            <span class="kpi-trend">Refus avec motif enregistre</span>
        </div>
    </article>
</section>

<section class="chart-two-column">
    <article class="content-card">
        <div class="content-card-header">
            <div>
                <h2 class="content-card-title">Mes demandes traitees par mois</h2>
                <p class="content-card-subtitle">Comparatif mensuel entre validations et refus sur les six derniers mois.</p>
            </div>
            <div class="chart-toolbar">
                <div class="toggle-group" id="agentRangeToggle">
                    <button type="button" class="toggle-button" data-range="3m">3 derniers mois</button>
                    <button type="button" class="toggle-button is-active" data-range="6m">6 derniers mois</button>
                    <button type="button" class="toggle-button" data-range="year">Cette annee</button>
                </div>
                <span id="agentActivityFeedback" class="chart-feedback"></span>
            </div>
        </div>
        <div class="content-card-body">
            <div class="chart-shell">
                <canvas id="agentActivityChart"></canvas>
            </div>
        </div>
    </article>

    <article class="content-card">
        <div class="content-card-header">
            <div>
                <h2 class="content-card-title">Repartition de mon portefeuille</h2>
                <p class="content-card-subtitle">Etat de vos dossiers actuellement en cours ou deja decides.</p>
            </div>
        </div>
        <div class="content-card-body">
            <div class="doughnut-layout">
                <div class="doughnut-wrap">
                    <div class="chart-shell chart-doughnut">
                        <canvas id="agentPortfolioChart"></canvas>
                    </div>
                    <div class="doughnut-center">
                        <strong>${dashboard.demandesEnCours + dashboard.demandesValideesParAgent + dashboard.demandesRefuseesParAgent}</strong>
                        <span>Total suivi</span>
                    </div>
                </div>
                <div class="legend-list">
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-attente"></span>En attente</div>
                        <span>${dashboard.demandesEnCours} demandes</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-validee"></span>Validees</div>
                        <span>${dashboard.demandesValideesParAgent} demandes</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-refusee"></span>Refusees</div>
                        <span>${dashboard.demandesRefuseesParAgent} demandes</span>
                    </div>
                </div>
            </div>
        </div>
    </article>
</section>

<section class="content-card">
    <div class="content-card-header">
        <div>
            <h2 class="content-card-title">Demandes prioritaires</h2>
            <p class="content-card-subtitle">Demandes soumises depuis plus de 48 heures, triees de la plus ancienne a la plus recente.</p>
        </div>
        <a class="btn btn-contour" href="${pageContext.request.contextPath}/agent/demandes">Voir toutes les demandes</a>
    </div>
    <div class="content-card-body">
        <c:choose>
            <c:when test="${empty dashboard.demandesPrioritaires}">
                <div class="empty-rich">
                    <div class="empty-illustration">&#10003;</div>
                    <h3 class="empty-title">Aucune priorite critique</h3>
                    <p class="empty-text">Aucune demande soumise depuis plus de 48 heures n attend actuellement une prise en charge.</p>
                </div>
            </c:when>
            <c:otherwise>
            <div class="priority-list">
                    <c:forEach var="demande" items="${dashboard.demandesPrioritaires}">
                        <c:set var="soumissionText" value="${fn:substring(fn:replace(demande.dateSoumission, 'T', ' '), 0, 16)}"/>
                        <div class="priority-item" data-soumission="${demande.dateSoumission}">
                            <div class="priority-main">
                                <span class="priority-code">${demande.code}</span>
                                <div class="priority-meta">
                                    <span>${demande.etudiant.nomComplet}</span>
                                    <span>&middot;</span>
                                    <span>${demande.typeDemande.libelle}</span>
                                    <span>&middot;</span>
                                    <span>${soumissionText}</span>
                                    <span class="badge badge-SOUMISE badge-md">${demande.etat.libelle}</span>
                                    <span class="badge priority-urgent badge-md" hidden>Urgent</span>
                                </div>
                            </div>
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/agent/demande/detail?id=${demande.id}">Traiter</a>
                        </div>
                    </c:forEach>
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

    var totalValidated = Number('${dashboard.demandesValideesParAgent}');
    var totalRejected = Number('${dashboard.demandesRefuseesParAgent}');
    var totalInProgress = Number('${dashboard.demandesEnCours}');

    function renderActivityChart(payload) {
        var activityChartCanvas = document.getElementById('agentActivityChart');
        if (!activityChartCanvas) {
            return;
        }

        if (window.sgdaCharts.agentActivityChart) {
            window.sgdaCharts.agentActivityChart.destroy();
        }

        window.sgdaCharts.agentActivityChart = new Chart(activityChartCanvas, {
            type: 'bar',
            data: {
                labels: payload.labels,
                datasets: [{
                    label: payload.primaryLabel || 'Validees',
                    data: payload.primaryValues,
                    backgroundColor: 'rgba(74,92,42,0.30)',
                    borderColor: '#4A5C2A',
                    borderWidth: 2,
                    borderRadius: 12
                }, {
                    label: payload.secondaryLabel || 'Refusees',
                    data: payload.secondaryValues,
                    backgroundColor: 'rgba(191,54,12,0.25)',
                    borderColor: '#BF360C',
                    borderWidth: 2,
                    borderRadius: 12
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                },
                scales: {
                    x: {
                        grid: { display: false }
                    },
                    y: {
                        beginAtZero: true,
                        grid: { color: 'rgba(26, 58, 107, 0.08)' }
                    }
                }
            }
        });
    }

    function loadAgentActivity(rangeKey) {
        var feedbackNode = document.getElementById('agentActivityFeedback');
        if (feedbackNode) {
            feedbackNode.textContent = 'Mise a jour en cours...';
        }

        fetch('${pageContext.request.contextPath}/agent/dashboard/activity?range=' + encodeURIComponent(rangeKey), {
            headers: {
                'Accept': 'application/json'
            }
        })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error('Impossible de charger les statistiques agent.');
                }
                return response.json();
            })
            .then(function (payload) {
                renderActivityChart(payload);
                if (feedbackNode) {
                    feedbackNode.textContent = 'Periode active: ' + rangeKey + '.';
                }
            })
            .catch(function () {
                if (feedbackNode) {
                    feedbackNode.textContent = 'La mise a jour du graphique a echoue.';
                }

                if (window.showToast) {
                    window.showToast('Impossible de recuperer les statistiques mensuelles de traitement.', 'error');
                }
            });
    }

    var portfolioChartCanvas = document.getElementById('agentPortfolioChart');
    if (portfolioChartCanvas) {
        if (window.sgdaCharts.agentPortfolioChart) {
            window.sgdaCharts.agentPortfolioChart.destroy();
        }

        window.sgdaCharts.agentPortfolioChart = new Chart(portfolioChartCanvas, {
            type: 'doughnut',
            data: {
                labels: ['En attente', 'Validees', 'Refusees'],
                datasets: [{
                    data: [totalInProgress, totalValidated, totalRejected],
                    backgroundColor: ['#D84315', '#4A5C2A', '#BF360C'],
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
    }

    loadAgentActivity('6m');

    document.querySelectorAll('#agentRangeToggle .toggle-button').forEach(function (button) {
        button.addEventListener('click', function () {
            document.querySelectorAll('#agentRangeToggle .toggle-button').forEach(function (item) {
                item.classList.remove('is-active');
            });
            button.classList.add('is-active');
            loadAgentActivity(button.getAttribute('data-range'));
        });
    });

    document.querySelectorAll('.priority-item').forEach(function (item) {
        var urgentBadge = item.querySelector('.priority-urgent');
        var soumissionValue = item.getAttribute('data-soumission');

        if (!urgentBadge || !soumissionValue) {
            return;
        }

        var ageInDays = (Date.now() - new Date(soumissionValue).getTime()) / (1000 * 60 * 60 * 24);
        if (ageInDays >= 5) {
            urgentBadge.hidden = false;
        }
    });
});
</script>
</body>
</html>
