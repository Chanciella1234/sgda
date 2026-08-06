<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<fmt:message key="section.etudiant" var="pageSection"/>
<fmt:message key="student.dashboard.page_title" var="pageTitle"/>
<fmt:message key="student.dashboard.page_subtitle" var="pageSubtitle"/>
<c:set var="activeMenu" value="dashboard"/>
<c:set var="prenomUtilisateur" value="${fn:split(sessionScope.SGDA_AUTH_USER.fullName, ' ')[0]}"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="student.dashboard.html_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<section class="hero-card">
    <div class="hero-grid">
        <div>
            <div class="hero-kicker"><fmt:message key="student.dashboard.hero.kicker"/></div>
            <h2 class="hero-title"><fmt:message key="student.dashboard.hero.greeting"/> ${prenomUtilisateur} !</h2>
            <p class="hero-subtitle"><fmt:message key="student.dashboard.hero.subtitle"/></p>
            <div class="hero-actions">
                <a class="btn btn-white btn-lg" href="${pageContext.request.contextPath}/student/demande/new"><fmt:message key="student.dashboard.hero.btn_new"/></a>
                <a class="btn btn-contour btn-lg" href="${pageContext.request.contextPath}/student/demandes"><fmt:message key="student.dashboard.hero.btn_view"/></a>
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
            <span class="kpi-label"><fmt:message key="student.dashboard.kpi.mes_demandes"/></span>
            <strong class="kpi-value">${dashboard.totalDemandes}</strong>
            <span class="kpi-trend"><fmt:message key="student.dashboard.kpi.mes_demandes.trend"/></span>
        </div>
    </article>

    <article class="kpi-card kpi-warning">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#9716;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label"><fmt:message key="student.dashboard.kpi.en_cours"/></span>
            <strong class="kpi-value">${dashboard.demandesEnCours}</strong>
            <span class="kpi-trend"><fmt:message key="student.dashboard.kpi.en_cours.trend"/></span>
        </div>
    </article>

    <article class="kpi-card kpi-success">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#10003;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label"><fmt:message key="student.dashboard.kpi.validees"/></span>
            <strong class="kpi-value">${dashboard.demandesValidees}</strong>
            <span class="kpi-trend"><fmt:message key="student.dashboard.kpi.validees.trend"/></span>
        </div>
    </article>

    <article class="kpi-card kpi-neutral">
        <div class="kpi-top">
            <span class="kpi-icon" aria-hidden="true">&#9998;</span>
        </div>
        <div class="kpi-meta">
            <span class="kpi-label"><fmt:message key="student.dashboard.kpi.brouillons"/></span>
            <strong class="kpi-value">${dashboard.demandesBrouillons}</strong>
            <span class="kpi-trend"><fmt:message key="student.dashboard.kpi.brouillons.trend"/></span>
        </div>
    </article>
</section>

<section class="chart-two-column">
    <article class="content-card">
        <div class="content-card-header">
            <div>
                <h2 class="content-card-title"><fmt:message key="student.dashboard.chart.title"/></h2>
                <p class="content-card-subtitle"><fmt:message key="student.dashboard.chart.subtitle"/></p>
            </div>
        </div>
        <div class="content-card-body">
            <c:choose>
                <c:when test="${dashboard.totalDemandes == 0}">
                    <div class="empty-rich">
                        <div class="empty-illustration">&#43;</div>
                        <h3 class="empty-title"><fmt:message key="student.dashboard.empty.title"/></h3>
                        <p class="empty-text"><fmt:message key="student.dashboard.empty.text"/></p>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/student/demande/new"><fmt:message key="student.dashboard.empty.btn"/></a>
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
                                <span><fmt:message key="student.dashboard.chart.total"/></span>
                            </div>
                        </div>
                        <div class="legend-list">
                            <div class="legend-item">
                                <div class="legend-item-left"><span class="status-swatch status-brouillon"></span><fmt:message key="student.dashboard.chart.brouillons"/></div>
                                <span>${dashboard.demandesBrouillons}</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-item-left"><span class="status-swatch status-attente"></span><fmt:message key="student.dashboard.chart.en_cours"/></div>
                                <span>${dashboard.demandesEnCours}</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-item-left"><span class="status-swatch status-validee"></span><fmt:message key="student.dashboard.chart.validees"/></div>
                                <span>${dashboard.demandesValidees}</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-item-left"><span class="status-swatch status-refusee"></span><fmt:message key="student.dashboard.chart.refusees"/></div>
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
                <h2 class="content-card-title"><fmt:message key="student.dashboard.recent.title"/></h2>
                <p class="content-card-subtitle"><fmt:message key="student.dashboard.recent.subtitle"/></p>
            </div>
        </div>
        <div class="content-card-body">
            <c:choose>
                <c:when test="${empty dashboard.dernieresDemandes}">
                    <div class="empty-rich">
                        <div class="empty-illustration">&#8226;</div>
                        <h3 class="empty-title"><fmt:message key="student.dashboard.recent.empty.title"/></h3>
                        <p class="empty-text"><fmt:message key="student.dashboard.recent.empty.text"/></p>
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
                                    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/student/demande/detail?id=${demande.id}"><fmt:message key="student.dashboard.recent.btn"/></a>
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
            <h2 class="content-card-title"><fmt:message key="student.dashboard.table.title"/></h2>
            <p class="content-card-subtitle"><fmt:message key="student.dashboard.table.subtitle"/></p>
        </div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/student/demande/new"><fmt:message key="student.dashboard.table.btn_new"/></a>
    </div>
    <div class="content-card-body">
        <c:choose>
            <c:when test="${empty demandes}">
                <div class="empty-rich">
                    <div class="empty-illustration">&#128196;</div>
                    <h3 class="empty-title"><fmt:message key="student.dashboard.table.empty.title"/></h3>
                    <p class="empty-text"><fmt:message key="student.dashboard.table.empty.text"/></p>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/student/demande/new"><fmt:message key="student.dashboard.hero.btn_new"/></a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-scroller">
                    <table class="table">
                        <thead>
                        <tr>
                            <th><fmt:message key="student.dashboard.table.header.code"/></th>
                            <th><fmt:message key="student.dashboard.table.header.type"/></th>
                            <th><fmt:message key="student.dashboard.table.header.date_creation"/></th>
                            <th><fmt:message key="student.dashboard.table.header.date_soumission"/></th>
                            <th><fmt:message key="student.dashboard.table.header.etat"/></th>
                            <th><fmt:message key="student.dashboard.table.header.actions"/></th>
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
                                                <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/student/demande/edit?id=${demande.id}"><fmt:message key="student.dashboard.table.edit"/></a>
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/student/demande/delete"
                                                      data-confirm='<fmt:message key="student.dashboard.table.delete.confirm"><fmt:param value="${demande.code}"/></fmt:message>'
                                                      data-confirm-title='<fmt:message key="student.dashboard.table.delete.title"/>'
                                                      data-confirm-confirm-label='<fmt:message key="student.dashboard.table.delete.confirm_label"/>'
                                                      data-confirm-cancel-label='<fmt:message key="student.dashboard.table.delete.cancel_label"/>'
                                                      data-confirm-variant="danger">
                                                    <input type="hidden" name="id" value="${demande.id}">
                                                    <button class="btn btn-danger btn-sm" type="submit"><fmt:message key="student.dashboard.table.delete"/></button>
                                                </form>
                                            </c:when>
                                            <c:when test="${demande.etat.code == 'SOUMISE' || demande.etat.code == 'EN_ATTENTE'}">
                                                <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/student/demande/detail?id=${demande.id}"><fmt:message key="student.dashboard.table.view"/></a>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/student/demande/detail?id=${demande.id}"><fmt:message key="student.dashboard.table.view"/></a>
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
<script src="${pageContext.request.contextPath}/assets/js/chart.umd.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    window.sgdaCharts = window.sgdaCharts || {};
    var colors = window.sgdaChartColors();

    var chartCanvas = document.getElementById('studentStatusChart');
    if (!chartCanvas || typeof window.Chart === 'undefined') {
        return;
    }

    if (window.sgdaCharts.studentStatusChart) {
        window.sgdaCharts.studentStatusChart.destroy();
    }

    window.sgdaCharts.studentStatusChart = new Chart(chartCanvas, {
        type: 'doughnut',
        data: {
            labels: ['<fmt:message key="student.dashboard.chart.brouillons"/>', '<fmt:message key="student.dashboard.chart.en_cours"/>', '<fmt:message key="student.dashboard.chart.validees"/>', '<fmt:message key="student.dashboard.chart.refusees"/>'],
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
