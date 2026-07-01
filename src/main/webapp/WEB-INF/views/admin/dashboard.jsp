<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="pageSection" value="Administration"/>
<c:set var="pageTitle" value="Dashboard administration"/>
<c:set var="pageSubtitle" value="Pilotage global des utilisateurs, des demandes et du workflow academique."/>
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
    <title>Dashboard admin - SGDA</title>
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
            <span class="kpi-label">Total utilisateurs</span>
            <strong class="kpi-value">${dashboard.totalUtilisateurs}</strong>
            <span class="kpi-trend">${nbAdmins} admins, ${nbAgents} agents, ${nbEtudiants} etudiants</span>
        </div>
    </article>

    <article class="kpi-card kpi-primary">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#128196;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label">Total demandes</span>
            <strong class="kpi-value">${dashboard.totalDemandes}</strong>
            <span class="kpi-trend">Toutes les demandes visibles par l administration</span>
        </div>
    </article>

    <article class="kpi-card kpi-warning">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#9716;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label">Demandes en attente</span>
            <strong class="kpi-value">${dashboard.demandesEnAttente}</strong>
            <span class="kpi-trend">${dashboard.demandesSoumises} soumises en file d attente</span>
        </div>
    </article>

    <article class="kpi-card kpi-success">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#10003;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label">Demandes validees</span>
            <strong class="kpi-value">${dashboard.demandesValidees}</strong>
            <span class="kpi-trend">Dossiers clotures favorablement</span>
        </div>
    </article>

    <article class="kpi-card kpi-danger">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#10005;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label">Demandes refusees</span>
            <strong class="kpi-value">${dashboard.demandesRefusees}</strong>
            <span class="kpi-trend">Verifier les motifs et la recurrenece</span>
        </div>
    </article>

    <article class="kpi-card kpi-neutral">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#128230;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label">Demandes archivees</span>
            <strong class="kpi-value">${dashboard.demandesArchivees}</strong>
            <span class="kpi-trend">Historique administratif consolide</span>
        </div>
    </article>
</section>

<section class="chart-two-column">
    <article class="content-card">
        <div class="content-card-header">
            <div>
                <h2 class="content-card-title">Repartition des utilisateurs par role</h2>
                <p class="content-card-subtitle">Distribution actuelle des acces dans la plateforme.</p>
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
                <h2 class="content-card-title">Repartition des demandes par etat</h2>
                <p class="content-card-subtitle">Lecture instantanee du portefeuille des demandes.</p>
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
                        <span>Total</span>
                    </div>
                </div>
                <div class="legend-list">
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-brouillon"></span>Brouillon</div>
                        <span>${dashboard.demandesBrouillon} demandes</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-soumise"></span>Soumise</div>
                        <span>${dashboard.demandesSoumises} demandes</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-attente"></span>En attente</div>
                        <span>${dashboard.demandesEnAttente} demandes</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-validee"></span>Validee</div>
                        <span>${dashboard.demandesValidees} demandes</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-refusee"></span>Refusee</div>
                        <span>${dashboard.demandesRefusees} demandes</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-item-left"><span class="status-swatch status-archivee"></span>Archivee</div>
                        <span>${dashboard.demandesArchivees} demandes</span>
                    </div>
                </div>
            </div>
        </div>
    </article>
</section>

<section class="content-card">
    <div class="content-card-header">
        <div>
            <h2 class="content-card-title">Evolution des demandes dans le temps</h2>
            <p class="content-card-subtitle">Visualisation des flux de soumission et de traitement sur plusieurs granularites.</p>
        </div>
        <div class="chart-toolbar">
            <div class="toggle-group" id="adminRangeToggle">
                <button type="button" class="toggle-button is-active" data-range="jour">Par jour</button>
                <button type="button" class="toggle-button" data-range="semaine">Par semaine</button>
                <button type="button" class="toggle-button" data-range="mois">Par mois</button>
                <button type="button" class="toggle-button" data-range="annee">Par annee</button>
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
            <h2 class="content-card-title">Supervision des demandes</h2>
            <p class="content-card-subtitle">Filtre, consulte et archive les demandes depuis un tableau unique.</p>
        </div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/demandes">Vue complete</a>
    </div>
    <div class="content-card-body">
        <div class="filter-toolbar">
            <div class="filter-grid">
                <div class="filter-field">
                    <label for="adminEtatFilter">Etat</label>
                    <select id="adminEtatFilter">
                        <option value="">Tous les etats</option>
                        <option value="BROUILLON">Brouillon</option>
                        <option value="SOUMISE">Soumise</option>
                        <option value="EN_ATTENTE">En attente</option>
                        <option value="VALIDEE">Validee</option>
                        <option value="REFUSEE">Refusee</option>
                        <option value="ARCHIVEE">Archivee</option>
                    </select>
                </div>
                <div class="filter-field">
                    <label for="adminTypeFilter">Type de demande</label>
                    <select id="adminTypeFilter">
                        <option value="">Tous les types</option>
                    </select>
                </div>
                <div class="filter-field">
                    <label for="adminDateFilter">Date de soumission</label>
                    <input id="adminDateFilter" type="date">
                </div>
                <div class="filter-actions">
                    <button type="button" class="btn btn-primary" id="adminApplyFilters">Filtrer</button>
                    <button type="button" class="btn btn-contour" id="adminResetFilters">Reinitialiser</button>
                </div>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty demandes}">
                <div class="empty-rich">
                    <div class="empty-illustration">&#128196;</div>
                    <h3 class="empty-title">Aucune demande a superviser</h3>
                    <p class="empty-text">Les demandes apparaitront ici des qu elles seront enregistrees dans SGDA.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-scroller">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>Code</th>
                            <th>Etudiant</th>
                            <th>Type</th>
                            <th>Date soumission</th>
                            <th>Agent</th>
                            <th>Etat</th>
                            <th>Actions</th>
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
                                        <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/admin/demande/detail?id=${demande.id}">Voir</a>
                                        <c:if test="${demande.etat.code == 'VALIDEE' || demande.etat.code == 'REFUSEE'}">
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/demande/archive"
                                                  data-confirm="La demande ${demande.code} sera archivee et restera disponible en consultation."
                                                  data-confirm-title="Archiver la demande"
                                                  data-confirm-confirm-label="Archiver"
                                                  data-confirm-cancel-label="Annuler"
                                                  data-confirm-variant="neutral">
                                                <input type="hidden" name="id" value="${demande.id}">
                                                <button class="btn btn-contour btn-sm" type="submit">Archiver</button>
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
                        <button type="button" class="page-chip" id="adminPrevPage">Prec.</button>
                        <div id="adminPageNumbers" class="pagination-controls"></div>
                        <button type="button" class="page-chip" id="adminNextPage">Suiv.</button>
                    </div>
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
    if (usersChartCanvas) {
        if (window.sgdaCharts.adminUsersChart) {
            window.sgdaCharts.adminUsersChart.destroy();
        }

        window.sgdaCharts.adminUsersChart = new Chart(usersChartCanvas, {
            type: 'bar',
            data: {
                labels: ['Administrateurs', 'Agents', 'Etudiants'],
                datasets: [{
                    label: 'Utilisateurs',
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

    var statusChartCanvas = document.getElementById('adminStatusChart');
    if (statusChartCanvas) {
        if (window.sgdaCharts.adminStatusChart) {
            window.sgdaCharts.adminStatusChart.destroy();
        }

        window.sgdaCharts.adminStatusChart = new Chart(statusChartCanvas, {
            type: 'doughnut',
            data: {
                labels: ['Brouillon', 'Soumise', 'En attente', 'Validee', 'Refusee', 'Archivee'],
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

        if (!trendChartCanvas || !trendData) {
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
                    label: 'Demandes soumises',
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
                    label: 'Demandes traitees',
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

    function loadTrendData(rangeKey) {
        var feedbackNode = document.getElementById('adminTrendFeedback');
        if (feedbackNode) {
            feedbackNode.textContent = 'Mise a jour en cours...';
        }

        return fetch('${pageContext.request.contextPath}/admin/dashboard/trend?range=' + encodeURIComponent(rangeKey), {
            headers: {
                'Accept': 'application/json'
            }
        })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error('Impossible de charger les donnees du graphique.');
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
                    feedbackNode.textContent = 'La mise a jour du graphique a echoue.';
                }

                if (window.showToast) {
                    window.showToast('Impossible de recuperer les statistiques d evolution pour le moment.', 'error');
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
});
</script>
</body>
</html>
