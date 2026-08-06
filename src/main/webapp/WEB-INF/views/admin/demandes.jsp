<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="pageSection"><fmt:message key="section.admin"/></c:set>
<c:set var="pageTitle"><fmt:message key="admin.demandes.page_title"/></c:set>
<c:set var="pageSubtitle"><fmt:message key="admin.demandes.page_subtitle"/></c:set>
<c:set var="activeMenu" value="demandes"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="admin.demandes.html_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
    <style>
        /* ── Filtres par statut ── */
        .status-filter-bar {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
            padding: 16px 20px 0;
        }
        .status-filter-label {
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .6px;
            color: var(--text-muted);
            margin-right: 4px;
        }
        .status-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 600;
            border: 2px solid transparent;
            cursor: pointer;
            transition: all .18s ease;
            background: var(--bg-page);
            color: var(--text-main);
            border-color: var(--border-color);
        }
        .status-chip:hover {
            transform: translateY(-1px);
            box-shadow: 0 3px 10px rgba(0,0,0,.12);
        }
        .status-chip.active-chip {
            color: #fff !important;
            border-color: transparent !important;
            box-shadow: 0 3px 10px rgba(0,0,0,.20);
        }
        .status-chip-dot {
            width: 8px; height: 8px;
            border-radius: 50%;
            flex-shrink: 0;
        }
        /* Couleurs par statut */
        .chip-ALL         { }
        .chip-ALL.active-chip  { background: #555; }
        .chip-BROUILLON.active-chip { background: #888780; }
        .chip-SOUMISE.active-chip   { background: #C98A3E; }
        .chip-EN_ATTENTE.active-chip{ background: #D84315; }
        .chip-VALIDEE.active-chip   { background: #4A5C2A; }
        .chip-REFUSEE.active-chip   { background: #BF360C; }
        .chip-ARCHIVEE.active-chip  { background: #7A4010; }

        .dot-ALL     { background: #888; }
        .dot-BROUILLON { background: #888780; }
        .dot-SOUMISE   { background: #C98A3E; }
        .dot-EN_ATTENTE{ background: #D84315; }
        .dot-VALIDEE   { background: #4A5C2A; }
        .dot-REFUSEE   { background: #BF360C; }
        .dot-ARCHIVEE  { background: #7A4010; }

        /* Compteur sur chaque chip */
        .chip-count {
            background: rgba(0,0,0,.12);
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
            padding: 1px 7px;
            min-width: 20px;
            text-align: center;
        }
        .active-chip .chip-count { background: rgba(255,255,255,.25); }

        /* Ligne masquée */
        .table tbody tr.hidden-row { display: none; }

        /* Séparateur sous les chips */
        .filter-divider {
            margin: 12px 20px 0;
            border: none;
            border-top: 1px solid var(--border-color);
        }

        /* Résumé visible */
        .filter-summary {
            padding: 10px 20px 0;
            font-size: 13px;
            color: var(--text-muted);
        }
        .filter-summary strong { color: var(--text-main); }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/flash.jsp"/>

<section class="content-card table-card">
    <div class="content-card-header">
        <div>
            <h2 class="content-card-title"><fmt:message key="admin.demandes.card.title"/></h2>
            <p class="content-card-subtitle"><fmt:message key="admin.demandes.card.subtitle"/></p>
        </div>
    </div>

    <%-- ── Barre de filtres par statut ── --%>
    <div class="status-filter-bar" id="statusFilterBar">
        <span class="status-filter-label"><fmt:message key="admin.demandes.filter_label"/></span>

        <button class="status-chip chip-ALL active-chip" data-filter="ALL" type="button">
            <span class="status-chip-dot dot-ALL"></span>
            <fmt:message key="admin.demandes.filter.all"/>
            <span class="chip-count" id="cnt-ALL">0</span>
        </button>

        <button class="status-chip chip-BROUILLON" data-filter="BROUILLON" type="button">
            <span class="status-chip-dot dot-BROUILLON"></span>
            <fmt:message key="admin.demandes.filter.brouillon"/>
            <span class="chip-count" id="cnt-BROUILLON">0</span>
        </button>

        <button class="status-chip chip-SOUMISE" data-filter="SOUMISE" type="button">
            <span class="status-chip-dot dot-SOUMISE"></span>
            <fmt:message key="admin.demandes.filter.soumise"/>
            <span class="chip-count" id="cnt-SOUMISE">0</span>
        </button>

        <button class="status-chip chip-EN_ATTENTE" data-filter="EN_ATTENTE" type="button">
            <span class="status-chip-dot dot-EN_ATTENTE"></span>
            <fmt:message key="admin.demandes.filter.en_attente"/>
            <span class="chip-count" id="cnt-EN_ATTENTE">0</span>
        </button>

        <button class="status-chip chip-VALIDEE" data-filter="VALIDEE" type="button">
            <span class="status-chip-dot dot-VALIDEE"></span>
            <fmt:message key="admin.demandes.filter.validee"/>
            <span class="chip-count" id="cnt-VALIDEE">0</span>
        </button>

        <button class="status-chip chip-REFUSEE" data-filter="REFUSEE" type="button">
            <span class="status-chip-dot dot-REFUSEE"></span>
            <fmt:message key="admin.demandes.filter.refusee"/>
            <span class="chip-count" id="cnt-REFUSEE">0</span>
        </button>

        <button class="status-chip chip-ARCHIVEE" data-filter="ARCHIVEE" type="button">
            <span class="status-chip-dot dot-ARCHIVEE"></span>
            <fmt:message key="admin.demandes.filter.archivee"/>
            <span class="chip-count" id="cnt-ARCHIVEE">0</span>
        </button>
    </div>

    <hr class="filter-divider"/>
    <p class="filter-summary" id="filterSummary">Affichage de <strong id="visibleCount">0</strong> demande(s)</p>

    <div class="content-card-body">
        <div class="table-scroller">
            <table class="table" id="supervisionTable">
                <thead>
                <tr>
                    <th><fmt:message key="admin.demandes.table.header.code"/></th>
                    <th><fmt:message key="admin.demandes.table.header.etudiant"/></th>
                    <th><fmt:message key="admin.demandes.table.header.type"/></th>
                    <th><fmt:message key="admin.demandes.table.header.etat"/></th>
                    <th><fmt:message key="admin.demandes.table.header.agent"/></th>
                    <th><fmt:message key="admin.demandes.table.header.actions"/></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="demande" items="${demandes}">
                    <tr data-etat="${demande.etat.code}">
                        <td class="code-text">${demande.code}</td>
                        <td>${demande.etudiant.nomComplet}</td>
                        <td>${demande.typeDemande.libelle}</td>
                        <td><span class="badge badge-${demande.etat.code}">${demande.etat.libelle}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${empty demande.agent}">-</c:when>
                                <c:otherwise>${demande.agent.nomComplet}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="actions">
                                <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/admin/demande/detail?id=${demande.id}"><fmt:message key="admin.demandes.table.consulter"/></a>
                                <c:if test="${demande.etat.code == 'VALIDEE' || demande.etat.code == 'REFUSEE'}">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/demande/archive">
                                        <input type="hidden" name="id" value="${demande.id}">
                                        <button class="btn btn-contour btn-sm" type="submit"
                                            data-confirm='<fmt:message key="admin.demandes.table.archive.confirm"><fmt:param value="${demande.code}"/></fmt:message>'
                                            data-confirm-title='<fmt:message key="admin.demandes.table.archive.title"/>'><fmt:message key="admin.demandes.table.archive"/></button>
                                    </form>
                                </c:if>
                                <c:if test="${demande.etat.code != 'VALIDEE' && demande.etat.code != 'REFUSEE'}">
                                    <span class="muted">—</span>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <%-- État vide --%>
            <div class="empty-state" id="emptyState" style="display:none;">
                <div class="empty-rich">
                    <div class="empty-illustration">🔍</div>
                    <div class="empty-title"><fmt:message key="admin.demandes.table.empty.title"/></div>
                    <div class="empty-text"><fmt:message key="admin.demandes.table.empty.text"/></div>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
(function () {
    'use strict';

    var table    = document.getElementById('supervisionTable');
    var filterBar= document.getElementById('statusFilterBar');
    var emptySt  = document.getElementById('emptyState');
    var visCount = document.getElementById('visibleCount');
    var rows     = table ? Array.from(table.querySelectorAll('tbody tr')) : [];

    /* ── 1. Compter par statut ── */
    var counts = { ALL: rows.length };
    rows.forEach(function (r) {
        var st = r.getAttribute('data-etat') || '';
        counts[st] = (counts[st] || 0) + 1;
    });
    Object.keys(counts).forEach(function (k) {
        var el = document.getElementById('cnt-' + k);
        if (el) el.textContent = counts[k];
    });

    /* ── 2. Mettre à jour le résumé ── */
    function updateSummary(n) {
        if (visCount) visCount.textContent = n;
    }
    updateSummary(rows.length);

    /* ── 3. Filtre au clic ── */
    if (filterBar) {
        filterBar.addEventListener('click', function (e) {
            var chip = e.target.closest('.status-chip');
            if (!chip) return;

            var filter = chip.getAttribute('data-filter');

            /* désactiver tous, activer le cliqué */
            filterBar.querySelectorAll('.status-chip').forEach(function (c) {
                c.classList.remove('active-chip');
            });
            chip.classList.add('active-chip');

            /* afficher / masquer les lignes */
            var visible = 0;
            rows.forEach(function (r) {
                var etat = r.getAttribute('data-etat') || '';
                var show = (filter === 'ALL' || etat === filter);
                r.classList.toggle('hidden-row', !show);
                if (show) visible++;
            });

            updateSummary(visible);

            /* état vide */
            if (emptySt) {
                emptySt.style.display = visible === 0 ? 'block' : 'none';
            }
        });
    }
})();
</script>
</body>
</html>
