<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="/WEB-INF/views/common/i18n.jsp" %>
<!DOCTYPE html>
<html lang="${currentLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="landing.page_title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>

<!-- ═══════════════════════════════════════════════════════════
     LANDING PAGE — SGDA
═══════════════════════════════════════════════════════════ -->
<div class="landing-shell">

    <!-- Theme toggle -->
    <div class="theme-toggle-login" aria-hidden="false">
        <button id="landingThemeToggle" type="button" class="theme-toggle-btn" aria-label="<fmt:message key='login.darkmode.aria'/>">
            <span class="theme-toggle-icon" id="landingThemeToggleIcon">🌙</span>
        </button>
    </div>

    <!-- ── Navbar ──────────────────────────────────────────── -->
    <nav class="landing-nav">
        <div class="landing-nav-inner">
            <div class="landing-nav-brand">
                <div class="landing-nav-logo">
                    <span class="landing-nav-logo-icon">SG</span>
                </div>
                <div class="landing-nav-brand-text">
                    <strong>SGDA</strong>
                    <span><fmt:message key="app.brand.meta"/></span>
                </div>
            </div>
            <div class="landing-nav-actions">
                <button class="landing-lang-toggle" id="landingLangToggle" type="button">
                    <fmt:message key="landing.nav.lang"/>
                </button>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm landing-login-btn">
                    <fmt:message key="landing.nav.login"/>
                </a>
            </div>
        </div>
    </nav>

    <!-- ── Hero Section ────────────────────────────────────── -->
    <section class="landing-hero">
        <span class="landing-orb landing-orb-1" aria-hidden="true"></span>
        <span class="landing-orb landing-orb-2" aria-hidden="true"></span>
        <span class="landing-orb landing-orb-3" aria-hidden="true"></span>
        <span class="landing-orb landing-orb-4" aria-hidden="true"></span>

        <div class="landing-hero-inner">
            <div class="landing-hero-badge">
                <fmt:message key="landing.hero.badge"/>
            </div>
            <h1 class="landing-hero-title">
                <fmt:message key="landing.hero.title"/>
            </h1>
            <p class="landing-hero-subtitle">
                <fmt:message key="landing.hero.subtitle"/>
            </p>
            <div class="landing-hero-actions">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-lg landing-cta-primary">
                    <fmt:message key="landing.hero.cta"/>
                </a>
                <a href="#features" class="btn btn-contour btn-lg landing-cta-secondary">
                    <fmt:message key="landing.hero.cta_secondary"/>
                </a>
            </div>
            <div class="landing-hero-stats">
                <div class="landing-stat">
                    <span class="landing-stat-value">3</span>
                    <span class="landing-stat-label"><fmt:message key="landing.hero.stat.roles"/></span>
                </div>
                <div class="landing-stat-divider"></div>
                <div class="landing-stat">
                    <span class="landing-stat-value">6</span>
                    <span class="landing-stat-label"><fmt:message key="landing.hero.stat.etats"/></span>
                </div>
                <div class="landing-stat-divider"></div>
                <div class="landing-stat">
                    <span class="landing-stat-value">100%</span>
                    <span class="landing-stat-label"><fmt:message key="landing.hero.stat.tracabilite"/></span>
                </div>
            </div>
        </div>
    </section>

    <!-- ── Features Section ────────────────────────────────── -->
    <section class="landing-section" id="features">
        <div class="landing-section-inner">
            <div class="landing-section-header">
                <span class="landing-section-badge"><fmt:message key="landing.features.badge"/></span>
                <h2 class="landing-section-title"><fmt:message key="landing.features.title"/></h2>
                <p class="landing-section-subtitle"><fmt:message key="landing.features.subtitle"/></p>
            </div>

            <div class="landing-features-grid">
                <div class="landing-feature-card">
                    <div class="landing-feature-icon landing-feature-icon-workflow">
                        <span class="landing-feature-icon-inner">📋</span>
                    </div>
                    <h3 class="landing-feature-title"><fmt:message key="landing.feature.workflow.title"/></h3>
                    <p class="landing-feature-text"><fmt:message key="landing.feature.workflow.text"/></p>
                </div>

                <div class="landing-feature-card">
                    <div class="landing-feature-icon landing-feature-icon-trace">
                        <span class="landing-feature-icon-inner">🔍</span>
                    </div>
                    <h3 class="landing-feature-title"><fmt:message key="landing.feature.trace.title"/></h3>
                    <p class="landing-feature-text"><fmt:message key="landing.feature.trace.text"/></p>
                </div>

                <div class="landing-feature-card">
                    <div class="landing-feature-icon landing-feature-icon-roles">
                        <span class="landing-feature-icon-inner">👥</span>
                    </div>
                    <h3 class="landing-feature-title"><fmt:message key="landing.feature.roles.title"/></h3>
                    <p class="landing-feature-text"><fmt:message key="landing.feature.roles.text"/></p>
                </div>

                <div class="landing-feature-card">
                    <div class="landing-feature-icon landing-feature-icon-secure">
                        <span class="landing-feature-icon-inner">🔒</span>
                    </div>
                    <h3 class="landing-feature-title"><fmt:message key="landing.feature.secure.title"/></h3>
                    <p class="landing-feature-text"><fmt:message key="landing.feature.secure.text"/></p>
                </div>

                <div class="landing-feature-card">
                    <div class="landing-feature-icon landing-feature-icon-dashboard">
                        <span class="landing-feature-icon-inner">📊</span>
                    </div>
                    <h3 class="landing-feature-title"><fmt:message key="landing.feature.dashboard.title"/></h3>
                    <p class="landing-feature-text"><fmt:message key="landing.feature.dashboard.text"/></p>
                </div>

                <div class="landing-feature-card">
                    <div class="landing-feature-icon landing-feature-icon-bilingual">
                        <span class="landing-feature-icon-inner">🌐</span>
                    </div>
                    <h3 class="landing-feature-title"><fmt:message key="landing.feature.bilingual.title"/></h3>
                    <p class="landing-feature-text"><fmt:message key="landing.feature.bilingual.text"/></p>
                </div>
            </div>
        </div>
    </section>

    <!-- ── Workflow Section ────────────────────────────────── -->
    <section class="landing-section landing-section-dark">
        <div class="landing-section-inner">
            <div class="landing-section-header">
                <span class="landing-section-badge"><fmt:message key="landing.workflow.badge"/></span>
                <h2 class="landing-section-title landing-section-title-light"><fmt:message key="landing.workflow.title"/></h2>
                <p class="landing-section-subtitle landing-section-subtitle-light"><fmt:message key="landing.workflow.subtitle"/></p>
            </div>

            <div class="landing-workflow">
                <div class="landing-workflow-step">
                    <div class="landing-workflow-number">1</div>
                    <div class="landing-workflow-content">
                        <h3><fmt:message key="landing.workflow.step1.title"/></h3>
                        <p><fmt:message key="landing.workflow.step1.text"/></p>
                    </div>
                </div>
                <div class="landing-workflow-arrow">
                    <span class="landing-arrow-icon">→</span>
                </div>
                <div class="landing-workflow-step">
                    <div class="landing-workflow-number">2</div>
                    <div class="landing-workflow-content">
                        <h3><fmt:message key="landing.workflow.step2.title"/></h3>
                        <p><fmt:message key="landing.workflow.step2.text"/></p>
                    </div>
                </div>
                <div class="landing-workflow-arrow">
                    <span class="landing-arrow-icon">→</span>
                </div>
                <div class="landing-workflow-step">
                    <div class="landing-workflow-number">3</div>
                    <div class="landing-workflow-content">
                        <h3><fmt:message key="landing.workflow.step3.title"/></h3>
                        <p><fmt:message key="landing.workflow.step3.text"/></p>
                    </div>
                </div>
                <div class="landing-workflow-arrow">
                    <span class="landing-arrow-icon">→</span>
                </div>
                <div class="landing-workflow-step">
                    <div class="landing-workflow-number">4</div>
                    <div class="landing-workflow-content">
                        <h3><fmt:message key="landing.workflow.step4.title"/></h3>
                        <p><fmt:message key="landing.workflow.step4.text"/></p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ── Roles Section ───────────────────────────────────── -->
    <section class="landing-section">
        <div class="landing-section-inner">
            <div class="landing-section-header">
                <span class="landing-section-badge"><fmt:message key="landing.roles.badge"/></span>
                <h2 class="landing-section-title"><fmt:message key="landing.roles.title"/></h2>
                <p class="landing-section-subtitle"><fmt:message key="landing.roles.subtitle"/></p>
            </div>

            <div class="landing-roles-grid">
                <div class="landing-role-card">
                    <div class="landing-role-icon landing-role-student">🎓</div>
                    <h3 class="landing-role-title"><fmt:message key="landing.role.student.title"/></h3>
                    <p class="landing-role-text"><fmt:message key="landing.role.student.text"/></p>
                    <ul class="landing-role-list">
                        <li><fmt:message key="landing.role.student.point1"/></li>
                        <li><fmt:message key="landing.role.student.point2"/></li>
                        <li><fmt:message key="landing.role.student.point3"/></li>
                    </ul>
                </div>

                <div class="landing-role-card">
                    <div class="landing-role-icon landing-role-agent">⚙️</div>
                    <h3 class="landing-role-title"><fmt:message key="landing.role.agent.title"/></h3>
                    <p class="landing-role-text"><fmt:message key="landing.role.agent.text"/></p>
                    <ul class="landing-role-list">
                        <li><fmt:message key="landing.role.agent.point1"/></li>
                        <li><fmt:message key="landing.role.agent.point2"/></li>
                        <li><fmt:message key="landing.role.agent.point3"/></li>
                    </ul>
                </div>

                <div class="landing-role-card">
                    <div class="landing-role-icon landing-role-admin">🏛️</div>
                    <h3 class="landing-role-title"><fmt:message key="landing.role.admin.title"/></h3>
                    <p class="landing-role-text"><fmt:message key="landing.role.admin.text"/></p>
                    <ul class="landing-role-list">
                        <li><fmt:message key="landing.role.admin.point1"/></li>
                        <li><fmt:message key="landing.role.admin.point2"/></li>
                        <li><fmt:message key="landing.role.admin.point3"/></li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- ── CTA Section ─────────────────────────────────────── -->
    <section class="landing-section landing-cta-section">
        <div class="landing-section-inner landing-cta-inner">
            <span class="landing-orb landing-orb-cta-1" aria-hidden="true"></span>
            <span class="landing-orb landing-orb-cta-2" aria-hidden="true"></span>
            <h2 class="landing-cta-title"><fmt:message key="landing.cta.title"/></h2>
            <p class="landing-cta-text"><fmt:message key="landing.cta.text"/></p>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-white btn-lg landing-cta-btn">
                <fmt:message key="landing.cta.btn"/>
            </a>
        </div>
    </section>

    <!-- ── Footer ──────────────────────────────────────────── -->
    <footer class="landing-footer">
        <div class="landing-footer-inner">
            <div class="landing-footer-brand">
                <div class="landing-footer-logo">SG</div>
                <div class="landing-footer-brand-text">
                    <strong>SGDA</strong>
                    <span><fmt:message key="app.brand.meta"/></span>
                </div>
            </div>
            <div class="landing-footer-copy">
                <fmt:message key="landing.footer.copyright"/>
            </div>
        </div>
    </footer>

</div>

<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
(function () {
    'use strict';

    // Theme toggle
    var toggle = document.getElementById('landingThemeToggle');
    if (toggle) {
        toggle.addEventListener('click', function () {
            var current = document.documentElement.getAttribute('data-theme') || 'light';
            var next = current === 'dark' ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', next);
            try { localStorage.setItem('sgda-theme', next); } catch(e) {}
            document.dispatchEvent(new CustomEvent('sgda:themechange', { detail: { theme: next } }));
            var icon = document.getElementById('landingThemeToggleIcon');
            if (icon) icon.textContent = next === 'dark' ? '🌙' : '☀️';
        });
    }

    // Sync icon on load
    (function syncIcon(){
        var theme = document.documentElement.getAttribute('data-theme') || 'light';
        var icon = document.getElementById('landingThemeToggleIcon');
        if (icon) icon.textContent = theme === 'dark' ? '🌙' : '☀️';
    })();

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(function(anchor) {
        anchor.addEventListener('click', function(e) {
            var target = document.querySelector(this.getAttribute('href'));
            if (target) {
                e.preventDefault();
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });

    // Intersection Observer for scroll animations
    var animatedElements = document.querySelectorAll('.landing-feature-card, .landing-workflow-step, .landing-role-card, .landing-section-header');
    if ('IntersectionObserver' in window) {
        var observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('landing-visible');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.15, rootMargin: '0px 0px -40px 0px' });

        animatedElements.forEach(function(el) {
            el.classList.add('landing-animatable');
            observer.observe(el);
        });
    }

    // Language toggle (redirect to switch locale)
    var langBtn = document.getElementById('landingLangToggle');
    if (langBtn) {
        langBtn.addEventListener('click', function() {
            var current = '${currentLang}';
            var next = current === 'fr' ? 'en' : 'fr';
            window.location.search = 'lang=' + next;
        });
    }
})();
</script>
</body>
</html>
