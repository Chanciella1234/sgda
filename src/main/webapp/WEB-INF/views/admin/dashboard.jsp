<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="pageSection"><fmt:message key="section.admin"/></c:set>
<c:set var="pageTitle"><fmt:message key="admin.dashboard.page_title"/></c:set>
<c:set var="pageSubtitle"><fmt:message key="admin.dashboard.page_subtitle"/></c:set>
<c:set var="activeMenu" value="dashboard"/>
<c:set var="nbAdmins" value="0"/>
<c:set var="nbAgents" value="0"/>
<c:set var="nbEtudiants" value="0"/>
<c:forEach var="roleStat" items="${dashboard.utilisateursParRole}">
    <c:if test="${roleStat.roleCode == 'ADMIN'}">
        <c:set var="nbAdmins" value="${roleStat.total}"/>
    </c:if>
    <c:if test="${roleStat.roleCode == 'AGENT'}">
        <c:set var="nbAgents" value="${roleStat.total}"/>
    </c:if>
    <c:if test="${roleStat.roleCode == 'ETUDIANT'}">
        <c:set var="nbEtudiants" value="${roleStat.total}"/>
    </c:if>
</c:forEach>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="admin.dashboard.html_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<section class="dashboard-row cols-6">
    <article class="kpi-card kpi-violet">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#128101;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label"><fmt:message key="admin.dashboard.kpi.total_users"/></span>
            <strong class="kpi-value">${dashboard.totalUtilisateurs}</strong>
            <span class="kpi-trend"><fmt:message key="admin.dashboard.kpi.total_users.trend"/></span>
        </div>
    </article>

    <article class="kpi-card kpi-primary">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#128196;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label"><fmt:message key="admin.dashboard.kpi.total_demandes"/></span>
            <strong class="kpi-value">${dashboard.totalDemandes}</strong>
            <span class="kpi-trend"><fmt:message key="admin.dashboard.kpi.total_demandes.trend"/></span>
        </div>
    </article>

    <article class="kpi-card kpi-warning">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#9716;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label"><fmt:message key="admin.dashboard.kpi.en_attente"/></span>
            <strong class="kpi-value">${dashboard.demandesEnAttente}</strong>
            <span class="kpi-trend"><fmt:message key="admin.dashboard.kpi.en_attente.trend"/></span>
        </div>
    </article>

    <article class="kpi-card kpi-success">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#10003;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label"><fmt:message key="admin.dashboard.kpi.validees"/></span>
            <strong class="kpi-value">${dashboard.demandesValidees}</strong>
            <span class="kpi-trend"><fmt:message key="admin.dashboard.kpi.validees.trend"/></span>
        </div>
    </article>

    <article class="kpi-card kpi-danger">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#10005;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label"><fmt:message key="admin.dashboard.kpi.refusees"/></span>
            <strong class="kpi-value">${dashboard.demandesRefusees}</strong>
            <span class="kpi-trend"><fmt:message key="admin.dashboard.kpi.refusees.trend"/></span>
        </div>
    </article>

    <article class="kpi-card kpi-neutral">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#128230;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label"><fmt:message key="admin.dashboard.kpi.archivees"/></span>
            <strong class="kpi-value">${dashboard.demandesArchivees}</strong>
            <span class="kpi-trend"><fmt:message key="admin.dashboard.kpi.archivees.trend"/></span>
        </div>
    </article>
</section>

<section class="chart-two-column">
    <article class="content-card">
        <div class="content-card-header">
            <div>
                <h2 class="content-card-title"><fmt:message key="admin.dashboard.chart.users"/></h2>
                <p class="content-card-subtitle"><fmt:message key="admin.dashboard.chart.users.subtitle"/></p>
            </div>
        </div>
        <div class="content-card-body">
            <div class="chart-shell">
                <canvas id="adminUsersChart"></canvas>
            </div>
        </div>
    </article>

    <article class="content-card">
        <div class="content-card-header">
            <div>
                <h2 class="content-card-title"><fmt:message key="admin.dashboard.chart.demandes"/></h2>
                <p class="content-card-subtitle"><fmt:message key="admin.dashboard.chart.demandes.subtitle"/></p>
            </div>
        </div>
        <div class="content-card-body">
            <div class="doughnut-layout">
                <div class="doughnut-wrap">
                    <div class="chart-shell chart-doughnut">
                        <canvas id="adminStatusChart"></canvas>
                    </div>
                    <div class="doughnut-center">
                        <strong>${dashboard.totalDemandes}</strong>
                        <span><fmt:message key="admin.dashboard.chart.total"/></span>
                    </div>
                </div>
                <div class="legend-list">
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-brouillon"></span><fmt:message key="admin.dashboard.chart.brouillon"/></div>
                        <span>${dashboard.demandesBrouillon} <fmt:message key="admin.dashboard.chart.demandes_label"/></span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-soumise"></span><fmt:message key="admin.dashboard.chart.soumise"/></div>
                        <span>${dashboard.demandesSoumises} <fmt:message key="admin.dashboard.chart.demandes_label"/></span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-attente"></span><fmt:message key="admin.dashboard.chart.en_attente"/></div>
                        <span>${dashboard.demandesEnAttente} <fmt:message key="admin.dashboard.chart.demandes_label"/></span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-validee"></span><fmt:message key="admin.dashboard.chart.validee"/></div>
                        <span>${dashboard.demandesValidees} <fmt:message key="admin.dashboard.chart.demandes_label"/></span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-refusee"></span><fmt:message key="admin.dashboard.chart.refusee"/></div>
                        <span>${dashboard.demandesRefusees} <fmt:message key="admin.dashboard.chart.demandes_label"/></span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-archivee"></span><fmt:message key="admin.dashboard.chart.archivee"/></div>
                        <span>${dashboard.demandesArchivees} <fmt:message key="admin.dashboard.chart.demandes_label"/></span>
                    </div>
                </div>
            </div>
        </div>
    </article>
</section>

<section class="content-card">
    <div class="content-card-header">
        <div>
            <h2 class="content-card-title"><fmt:message key="admin.dashboard.chart.evolution"/></h2>
            <p class="content-card-subtitle"><fmt:message key="admin.dashboard.chart.evolution.subtitle"/></p>
        </div>
        <div class="chart-toolbar">
            <div class="toggle-group" id="adminRangeToggle">
                <button type="button" class="toggle-button is-active" data-range="jour"><fmt:message key="admin.dashboard.chart.period.jour"/></button>
                <button type="button" class="toggle-button" data-range="semaine"><fmt:message key="admin.dashboard.chart.period.semaine"/></button>
                <button type="button" class="toggle-button" data-range="mois"><fmt:message key="admin.dashboard.chart.period.mois"/></button>
                <button type="button" class="toggle-button" data-range="annee"><fmt:message key="admin.dashboard.chart.period.annee"/></button>
            </div>
            <span id="adminTrendFeedback" class="chart-feedback"></span>
        </div>
    </div>
    <div class="content-card-body">
        <div class="chart-shell chart-line">
            <canvas id="adminTrendChart"></canvas>
        </div>
    </div>
</section>

<section class="content-card table-card">
    <div class="content-card-header">
        <div>
            <h2 class="content-card-title"><fmt:message key="admin.dashboard.supervision.title"/></h2>
            <p class="content-card-subtitle"><fmt:message key="admin.dashboard.supervision.subtitle"/></p>
        </div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/demandes"><fmt:message key="admin.dashboard.supervision.btn"/></a>
    </div>
    <div class="content-card-body">
        <div class="filter-toolbar">
            <div class="filter-grid">
                <div class="filter-field">
                    <label for="adminEtatFilter"><fmt:message key="admin.dashboard.filter.etat"/></label>
                    <select id="adminEtatFilter">
                        <option value=""><fmt:message key="admin.dashboard.filter.etat.all"/></option>
                        <option value="BROUILLON"><fmt:message key="status.BROUILLON"/></option>
                        <option value="SOUMISE"><fmt:message key="status.SOUMISE"/></option>
                        <option value="EN_ATTENTE"><fmt:message key="status.EN_ATTENTE"/></option>
                        <option value="VALIDEE"><fmt:message key="status.VALIDEE"/></option>
                        <option value="REFUSEE"><fmt:message key="status.REFUSEE"/></option>
                        <option value="ARCHIVEE"><fmt:message key="status.ARCHIVEE"/></option>
                    </select>
                </div>
                <div class="filter-field">
                    <label for="adminTypeFilter"><fmt:message key="admin.dashboard.filter.type"/></label>
                    <select id="adminTypeFilter">
                        <option value=""><fmt:message key="admin.dashboard.filter.type.all"/></option>
                    </select>
                </div>
                <div class="filter-field">
                    <label for="adminDateFilter"><fmt:message key="admin.dashboard.filter.date"/></label>
                    <input id="adminDateFilter" type="date">
                </div>
                <div class="filter-actions">
                    <button type="button" class="btn btn-primary" id="adminApplyFilters"><fmt:message key="admin.dashboard.filter.btn"/></button>
                    <button type="button" class="btn btn-contour" id="adminResetFilters"><fmt:message key="admin.dashboard.filter.reset"/></button>
                </div>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty demandes}">
                <div class="empty-rich">
                    <div class="empty-illustration">&#128196;</div>
                    <h3 class="empty-title"><fmt:message key="admin.dashboard.table.empty.title"/></h3>
                    <p class="empty-text"><fmt:message key="admin.dashboard.table.empty.text"/></p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-scroller">
                    <table class="table">
                        <thead>
                        <tr>
                            <th><fmt:message key="admin.dashboard.table.header.code"/></th>
                            <th><fmt:message key="admin.dashboard.table.header.etudiant"/></th>
                            <th><fmt:message key="admin.dashboard.table.header.type"/></th>
                            <th><fmt:message key="admin.dashboard.table.header.date_soumission"/></th>
                            <th><fmt:message key="admin.dashboard.table.header.agent"/></th>
                            <th><fmt:message key="admin.dashboard.table.header.etat"/></th>
                            <th><fmt:message key="admin.dashboard.table.header.actions"/></th>
                        </tr>
                        </thead>
                        <tbody id="adminDemandesBody">
                        <c:forEach var="demande" items="${demandes}">
                            <c:set var="dateSoumissionText" value="${empty demande.dateSoumission ? '' : fn:substring(fn:replace(demande.dateSoumission, 'T', ' '), 0, 16)}"/>
                            <c:set var="dateSoumissionValue" value="${empty demande.dateSoumission ? '' : fn:substring(fn:replace(demande.dateSoumission, 'T', ' '), 0, 10)}"/>
                            <tr data-state="${demande.etat.code}"
                                data-type="${demande.typeDemande.libelle}"
                                data-date="${dateSoumissionValue}">
                                <td class="code-text">${demande.code}</td>
                                <td>${demande.etudiant.nomComplet}</td>
                                <td>${demande.typeDemande.libelle}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty dateSoumissionText}">-</c:when>
                                        <c:otherwise>${dateSoumissionText}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty demande.agent}">-</c:when>
                                        <c:otherwise>${demande.agent.nomComplet}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><span class="badge badge-${demande.etat.code}">${demande.etat.libelle}</span></td>
                                <td>
                                    <div class="actions">
                                        <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/admin/demande/detail?id=${demande.id}"><fmt:message key="admin.dashboard.table.voir"/></a>
                                        <c:if test="${demande.etat.code == 'VALIDEE' || demande.etat.code == 'REFUSEE'}">
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/demande/archive"
                                                  data-confirm='<fmt:message key="admin.dashboard.table.archive.confirm"><fmt:param value="${demande.code}"/></fmt:message>'
                                                  data-confirm-title='<fmt:message key="admin.dashboard.table.archive.title"/>'
                                                  data-confirm-confirm-label='<fmt:message key="admin.dashboard.table.archive.confirm_label"/>'
                                                  data-confirm-cancel-label='<fmt:message key="admin.dashboard.table.archive.cancel_label"/>'
                                                  data-confirm-variant="neutral">
                                                <input type="hidden" name="id" value="${demande.id}">
                                                <button class="btn btn-contour btn-sm" type="submit"><fmt:message key="admin.dashboard.table.archive"/></button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="table-pagination">
                    <span class="form-actions-note" id="adminPaginationSummary">0 demande visible</span>
                    <div class="pagination-controls">
                        <button type="button" class="page-chip" id="adminPrevPage"><fmt:message key="pagination.precedent"/></button>
                        <div id="adminPageNumbers" class="pagination-controls"></div>
                        <button type="button" class="page-chip" id="adminNextPage"><fmt:message key="pagination.suivant"/></button>
                    </div>
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
    var nbAdmins = Number('${nbAdmins}');
    var nbAgents = Number('${nbAgents}');
    var nbEtudiants = Number('${nbEtudiants}');
    var statusCounts = [
        Number('${dashboard.demandesBrouillon}'),
        Number('${dashboard.demandesSoumises}'),
        Number('${dashboard.demandesEnAttente}'),
        Number('${dashboard.demandesValidees}'),
        Number('${dashboard.demandesRefusees}'),
        Number('${dashboard.demandesArchivees}')
    ];

    var usersChartCanvas = document.getElementById('adminUsersChart');
    if (usersChartCanvas && typeof window.Chart !== 'undefined') {
        if (window.sgdaCharts.adminUsersChart) {
            window.sgdaCharts.adminUsersChart.destroy();
        }

        window.sgdaCharts.adminUsersChart = new Chart(usersChartCanvas, {
            type: 'bar',
            data: {
                labels: ['<fmt:message key="chart.administrateurs"/>', '<fmt:message key="chart.agents"/>', '<fmt:message key="chart.etudiants"/>'],
                datasets: [{
                    label: '<fmt:message key="chart.utilisateurs"/>',
                    data: [nbAdmins, nbAgents, nbEtudiants],
                    backgroundColor: ['rgba(201,138,62,.22)', 'rgba(74,92,42,.24)', 'rgba(26,46,15,.22)'],
                    borderColor: ['#C98A3E', '#4A5C2A', '#1A2E0F'],
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

    var statusChartCanvas = document.getElementById('adminStatusChart');
    if (statusChartCanvas && typeof window.Chart !== 'undefined') {
        if (window.sgdaCharts.adminStatusChart) {
            window.sgdaCharts.adminStatusChart.destroy();
        }

        window.sgdaCharts.adminStatusChart = new Chart(statusChartCanvas, {
            type: 'doughnut',
            data: {
                labels: ['<fmt:message key="admin.dashboard.chart.brouillon"/>', '<fmt:message key="admin.dashboard.chart.soumise"/>', '<fmt:message key="admin.dashboard.chart.en_attente"/>', '<fmt:message key="admin.dashboard.chart.validee"/>', '<fmt:message key="admin.dashboard.chart.refusee"/>', '<fmt:message key="admin.dashboard.chart.archivee"/>'],
                datasets: [{
                    data: statusCounts,
                    backgroundColor: ['#888780', '#C98A3E', '#D84315', '#4A5C2A', '#BF360C', '#7A4010'],
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

    function renderTrendChart(trendData) {
        var trendChartCanvas = document.getElementById('adminTrendChart');

        if (!trendChartCanvas || !trendData || typeof window.Chart === 'undefined') {
            return;
        }

        if (window.sgdaCharts.adminTrendChart) {
            window.sgdaCharts.adminTrendChart.destroy();
        }

        window.sgdaCharts.adminTrendChart = new Chart(trendChartCanvas, {
            type: 'line',
            data: {
                labels: trendData.labels,
                datasets: [{
                    label: '<fmt:message key="admin.dashboard.chart.soumises_label"/>',
                    data: trendData.soumises,
                    borderColor: '#C98A3E',
                    backgroundColor: 'rgba(201,138,62,0.10)',
                    fill: true,
                    tension: 0.35,
                    pointRadius: 5,
                    pointHoverRadius: 6,
                    pointBackgroundColor: '#ffffff',
                    pointBorderWidth: 2
                }, {
                    label: '<fmt:message key="admin.dashboard.chart.traitees_label"/>',
                    data: trendData.traitees,
                    borderColor: '#4A5C2A',
                    backgroundColor: 'rgba(74,92,42,0.10)',
                    fill: true,
                    tension: 0.35,
                    pointRadius: 5,
                    pointHoverRadius: 6,
                    pointBackgroundColor: '#ffffff',
                    pointBorderWidth: 2
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

    function loadTrendData(rangeKey) {
        var feedbackNode = document.getElementById('adminTrendFeedback');
        if (feedbackNode) {
            feedbackNode.textContent = '<fmt:message key="app.loading"/>';
        }

        return fetch('${pageContext.request.contextPath}/admin/dashboard/trend?range=' + encodeURIComponent(rangeKey), {
            headers: {
                'Accept': 'application/json'
            }
        })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error('<fmt:message key="admin.dashboard.error.chart"/>');
                }
                return response.json();
            })
            .then(function (payload) {
                renderTrendChart({
                    labels: payload.labels,
                    soumises: payload.primaryValues,
                    traitees: payload.secondaryValues
                });

                if (feedbackNode) {
                    feedbackNode.textContent = 'Periode active: ' + rangeKey + '.';
                }
            })
            .catch(function () {
                if (feedbackNode) {
                    feedbackNode.textContent = '<fmt:message key="admin.dashboard.error.update"/>';
                }

                if (window.showToast) {
                    window.showToast('<fmt:message key="admin.dashboard.error.stats"/>', 'error');
                }
            });
    }

    loadTrendData('jour');

    document.querySelectorAll('#adminRangeToggle .toggle-button').forEach(function (button) {
        button.addEventListener('click', function () {
            document.querySelectorAll('#adminRangeToggle .toggle-button').forEach(function (item) {
                item.classList.remove('is-active');
            });
            button.classList.add('is-active');
            loadTrendData(button.getAttribute('data-range'));
        });
    });

    var demandesBody = document.getElementById('adminDemandesBody');
    if (!demandesBody) {
        return;
    }

    var rows = Array.prototype.slice.call(demandesBody.querySelectorAll('tr'));
    var stateFilter = document.getElementById('adminEtatFilter');
    var typeFilter = document.getElementById('adminTypeFilter');
    var dateFilter = document.getElementById('adminDateFilter');
    var applyButton = document.getElementById('adminApplyFilters');
    var resetButton = document.getElementById('adminResetFilters');
    var prevButton = document.getElementById('adminPrevPage');
    var nextButton = document.getElementById('adminNextPage');
    var pageNumbers = document.getElementById('adminPageNumbers');
    var summary = document.getElementById('adminPaginationSummary');
    var pageSize = 6;
    var currentPage = 1;
    var filteredRows = rows.slice();

    Array.from(new Set(rows.map(function (row) {
        return row.getAttribute('data-type');
    }).filter(Boolean))).sort().forEach(function (typeLabel) {
        var option = document.createElement('option');
        option.value = typeLabel;
        option.textContent = typeLabel;
        typeFilter.appendChild(option);
    });

    function renderTable() {
        rows.forEach(function (row) {
            row.style.display = 'none';
        });

        var totalPages = Math.max(1, Math.ceil(filteredRows.length / pageSize));
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        var start = (currentPage - 1) * pageSize;
        var currentRows = filteredRows.slice(start, start + pageSize);
        currentRows.forEach(function (row) {
            row.style.display = '';
        });

        pageNumbers.innerHTML = '';
        for (var pageIndex = 1; pageIndex <= totalPages; pageIndex += 1) {
            var chip = document.createElement('button');
            chip.type = 'button';
            chip.className = 'page-chip' + (pageIndex === currentPage ? ' is-active' : '');
            chip.textContent = String(pageIndex);
            chip.addEventListener('click', (function (targetPage) {
                return function () {
                    currentPage = targetPage;
                    renderTable();
                };
            })(pageIndex));
            pageNumbers.appendChild(chip);
        }

        prevButton.disabled = currentPage === 1;
        nextButton.disabled = currentPage === totalPages;
        summary.textContent = filteredRows.length + ' demande(s) visible(s)';
    }

    function applyFilters() {
        var currentState = stateFilter.value;
        var currentType = typeFilter.value;
        var currentDate = dateFilter.value;

        filteredRows = rows.filter(function (row) {
            var matchesState = !currentState || row.getAttribute('data-state') === currentState;
            var matchesType = !currentType || row.getAttribute('data-type') === currentType;
            var matchesDate = !currentDate || row.getAttribute('data-date') === currentDate;
            return matchesState && matchesType && matchesDate;
        });

        currentPage = 1;
        renderTable();
    }

    applyButton.addEventListener('click', applyFilters);
    resetButton.addEventListener('click', function () {
        stateFilter.value = '';
        typeFilter.value = '';
        dateFilter.value = '';
        filteredRows = rows.slice();
        currentPage = 1;
        renderTable();
    });
    prevButton.addEventListener('click', function () {
        if (currentPage > 1) {
            currentPage -= 1;
            renderTable();
        }
    });
    nextButton.addEventListener('click', function () {
        var totalPages = Math.max(1, Math.ceil(filteredRows.length / pageSize));
        if (currentPage < totalPages) {
            currentPage += 1;
            renderTable();
        }
    });

    renderTable();

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
