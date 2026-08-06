<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="pageSection"><fmt:message key="section.agent"/></c:set>
<c:set var="pageTitle"><fmt:message key="agent.dashboard.page_title"/></c:set>
<c:set var="pageSubtitle"><fmt:message key="agent.dashboard.page_subtitle"/></c:set>
<c:set var="activeMenu" value="dashboard"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="agent.dashboard.html_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<section class="dashboard-row cols-4">
    <article class="kpi-card kpi-warning">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#9716;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label"><fmt:message key="agent.dashboard.kpi.a_traiter"/></span>
            <strong class="kpi-value">${dashboard.demandesATraiter}</strong>
            <span class="kpi-trend"><fmt:message key="agent.dashboard.kpi.a_traiter.trend"/></span>
        </div>
    </article>

    <article class="kpi-card kpi-primary">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#128450;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label"><fmt:message key="agent.dashboard.kpi.en_cours"/></span>
            <strong class="kpi-value">${dashboard.demandesEnCours}</strong>
            <span class="kpi-trend">${dashboard.totalDemandesTraitees} <fmt:message key="agent.dashboard.kpi.en_cours.trend"/></span>
        </div>
    </article>

    <article class="kpi-card kpi-success">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#10003;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label"><fmt:message key="agent.dashboard.kpi.validees"/></span>
            <strong class="kpi-value">${dashboard.demandesValideesParAgent}</strong>
            <span class="kpi-trend"><fmt:message key="agent.dashboard.kpi.validees.trend"/></span>
        </div>
    </article>

    <article class="kpi-card kpi-danger">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#10005;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label"><fmt:message key="agent.dashboard.kpi.refusees"/></span>
            <strong class="kpi-value">${dashboard.demandesRefuseesParAgent}</strong>
            <span class="kpi-trend"><fmt:message key="agent.dashboard.kpi.refusees.trend"/></span>
        </div>
    </article>
</section>

<section class="chart-two-column">
    <article class="content-card">
        <div class="content-card-header">
            <div>
                <h2 class="content-card-title"><fmt:message key="agent.dashboard.chart.traitees"/></h2>
                <p class="content-card-subtitle"><fmt:message key="agent.dashboard.chart.traitees.subtitle"/></p>
            </div>
            <div class="chart-toolbar">
                <div class="toggle-group" id="agentRangeToggle">
                    <button type="button" class="toggle-button" data-range="3m"><fmt:message key="agent.dashboard.chart.period.3mois"/></button>
                    <button type="button" class="toggle-button is-active" data-range="6m"><fmt:message key="agent.dashboard.chart.period.6mois"/></button>
                    <button type="button" class="toggle-button" data-range="year"><fmt:message key="agent.dashboard.chart.period.annee"/></button>
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
                <h2 class="content-card-title"><fmt:message key="agent.dashboard.chart.portefeuille"/></h2>
                <p class="content-card-subtitle"><fmt:message key="agent.dashboard.chart.portefeuille.subtitle"/></p>
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
                        <span><fmt:message key="agent.dashboard.chart.total"/></span>
                    </div>
                </div>
                <div class="legend-list">
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-attente"></span><fmt:message key="agent.dashboard.chart.en_attente"/></div>
                        <span>${dashboard.demandesEnCours} <fmt:message key="agent.dashboard.chart.demandes"/></span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-validee"></span><fmt:message key="agent.dashboard.chart.validees"/></div>
                        <span>${dashboard.demandesValideesParAgent} <fmt:message key="agent.dashboard.chart.demandes"/></span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-refusee"></span><fmt:message key="agent.dashboard.chart.refusees"/></div>
                        <span>${dashboard.demandesRefuseesParAgent} <fmt:message key="agent.dashboard.chart.demandes"/></span>
                    </div>
                </div>
            </div>
        </div>
    </article>
</section>

<section class="content-card">
    <div class="content-card-header">
        <div>
            <h2 class="content-card-title"><fmt:message key="agent.dashboard.priorites.title"/></h2>
            <p class="content-card-subtitle"><fmt:message key="agent.dashboard.priorites.subtitle"/></p>
        </div>
        <a class="btn btn-contour" href="${pageContext.request.contextPath}/agent/demandes"><fmt:message key="agent.dashboard.priorites.btn"/></a>
    </div>
    <div class="content-card-body">
        <c:choose>
            <c:when test="${empty dashboard.demandesPrioritaires}">
                <div class="empty-rich">
                    <div class="empty-illustration">&#10003;</div>
                    <h3 class="empty-title"><fmt:message key="agent.dashboard.priorites.empty.title"/></h3>
                    <p class="empty-text"><fmt:message key="agent.dashboard.priorites.empty.text"/></p>
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
                                    <span class="badge priority-urgent badge-md" hidden><fmt:message key="agent.dashboard.priorites.urgent"/></span>
                                </div>
                            </div>
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/agent/demande/detail?id=${demande.id}"><fmt:message key="agent.dashboard.priorites.traiter"/></a>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/chart.umd.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    window.sgdaCharts = window.sgdaCharts || {};
    var colors = window.sgdaChartColors();

    var MSG_LOADING = '<fmt:message key="app.loading"/>';
    var MSG_CHART_VALIDEES = '<fmt:message key="agent.dashboard.chart.validees"/>';
    var MSG_CHART_REFUSEES = '<fmt:message key="agent.dashboard.chart.refusees"/>';
    var MSG_CHART_EN_ATTENTE = '<fmt:message key="agent.dashboard.chart.en_attente"/>';
    var MSG_CHART_PERIOD = '<fmt:message key="agent.dashboard.chart.period_label"/>';
    var MSG_ERROR_LOAD = '<fmt:message key="agent.dashboard.error.load"/>';
    var MSG_ERROR_UPDATE = '<fmt:message key="agent.dashboard.error.update"/>';
    var MSG_ERROR_STATS = '<fmt:message key="agent.dashboard.error.stats"/>';

    var totalValidated = Number('${dashboard.demandesValideesParAgent}');
    var totalRejected = Number('${dashboard.demandesRefuseesParAgent}');
    var totalInProgress = Number('${dashboard.demandesEnCours}');

    function renderActivityChart(payload) {
        var activityChartCanvas = document.getElementById('agentActivityChart');
        if (!activityChartCanvas || typeof window.Chart === 'undefined') {
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
                    label: payload.primaryLabel || MSG_CHART_VALIDEES,
                    data: payload.primaryValues,
                    backgroundColor: 'rgba(74,92,42,0.30)',
                    borderColor: '#4A5C2A',
                    borderWidth: 2,
                    borderRadius: 12
                }, {
                    label: payload.secondaryLabel || MSG_CHART_REFUSEES,
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
                        position: 'bottom',
                        labels: { color: colors.text }
                    }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: { color: colors.text }
                    },
                    y: {
                        beginAtZero: true,
                        grid: { color: colors.grid },
                        ticks: { color: colors.text }
                    }
                }
            }
        });
    }

    function loadAgentActivity(rangeKey) {
        var feedbackNode = document.getElementById('agentActivityFeedback');
        if (feedbackNode) {
            feedbackNode.textContent = MSG_LOADING;
        }

        fetch('${pageContext.request.contextPath}/agent/dashboard/activity?range=' + encodeURIComponent(rangeKey), {
            headers: {
                'Accept': 'application/json'
            }
        })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error(MSG_ERROR_LOAD);
                }
                return response.json();
            })
            .then(function (payload) {
                renderActivityChart(payload);
                if (feedbackNode) {
                    feedbackNode.textContent = MSG_CHART_PERIOD + ' ' + rangeKey + '.';
                }
            })
            .catch(function () {
                if (feedbackNode) {
                    feedbackNode.textContent = MSG_ERROR_UPDATE;
                }

                if (window.showToast) {
                    window.showToast(MSG_ERROR_STATS, 'error');
                }
            });
    }

    var portfolioChartCanvas = document.getElementById('agentPortfolioChart');
    if (portfolioChartCanvas && typeof window.Chart !== 'undefined') {
        if (window.sgdaCharts.agentPortfolioChart) {
            window.sgdaCharts.agentPortfolioChart.destroy();
        }

        window.sgdaCharts.agentPortfolioChart = new Chart(portfolioChartCanvas, {
            type: 'doughnut',
            data: {
                labels: [MSG_CHART_EN_ATTENTE, MSG_CHART_VALIDEES, MSG_CHART_REFUSEES],
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

    document.addEventListener('sgda:themechange', function () {
        var c = window.sgdaChartColors();
        Object.keys(window.sgdaCharts).forEach(function (key) {
            var chart = window.sgdaCharts[key];
            if (!chart || !chart.options) return;
            if (chart.options.plugins && chart.options.plugins.legend && chart.options.plugins.legend.labels) {
                chart.options.plugins.legend.labels.color = c.text;
            }
            if (chart.options.scales) {
                Object.keys(chart.options.scales).forEach(function (axis) {
                    if (chart.options.scales[axis].ticks) chart.options.scales[axis].ticks.color = c.text;
                    if (chart.options.scales[axis].grid) chart.options.scales[axis].grid.color = c.grid;
                });
            }
            chart.update();
        });
    });
});
</script>
</body>
</html>
