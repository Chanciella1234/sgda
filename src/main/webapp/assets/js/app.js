/* ============================================================
   SGDA — app.js
   Interactions: sidebar toggle, dark mode, toasts, confirm,
   ripple, table filters, animations
   ============================================================ */

(function () {
  'use strict';

  /* ── Dark mode ─────────────────────────────────────────── */
  function applyTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    try { localStorage.setItem('sgda-theme', theme); } catch(e) {}
    document.dispatchEvent(new CustomEvent('sgda:themechange', { detail: { theme: theme } }));
  }
  function initTheme() {
    var saved;
    try { saved = localStorage.getItem('sgda-theme'); } catch(e) {}
    var preferred = saved || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
    applyTheme(preferred);
  }
  initTheme();

  /* ── Chart.js dark-mode aware colors ──────────────────── */
  window.sgdaChartColors = function () {
    var dark = document.documentElement.getAttribute('data-theme') === 'dark';
    return {
      text:     dark ? '#F5EDD0' : '#1A2E0F',
      grid:     dark ? 'rgba(201,138,62,0.12)' : 'rgba(26,58,107,0.08)',
      tooltipBg: dark ? '#1A2E0F' : '#fff',
      tooltipText: dark ? '#F5EDD0' : '#1A2E0F',
      tooltipBorder: dark ? '#C98A3E' : '#1A2E0F'
    };
  };

  /* ── Run after DOM ready ───────────────────────────────── */
  document.addEventListener('DOMContentLoaded', function () {

    /* Dark mode toggle from settings only (no more separate navbar button) */
    var settingsDarkToggle = document.getElementById('settingsDarkMode');
    if (settingsDarkToggle) {
      settingsDarkToggle.addEventListener('change', function () {
        var theme = this.checked ? 'dark' : 'light';
        applyTheme(theme);
      });
    }

    /* ── Language helper ────────────────────────────────── */
    function setCookie(name, value, days) {
      var expires = '';
      if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = '; expires=' + date.toUTCString();
      }
      document.cookie = name + '=' + (value || '') + expires + '; path=/';
    }
    function syncLangUI(lang) {
      document.documentElement.setAttribute('data-lang', lang);
      try { localStorage.setItem('sgda-lang', lang); } catch(e) {}
      setCookie('sgda-lang', lang, 365);
      var btns = document.querySelectorAll('.lang-btn');
      btns.forEach(function (btn) {
        btn.classList.toggle('is-active', btn.getAttribute('data-lang') === lang);
      });
    }
    function applyLang(lang) {
      syncLangUI(lang);
      if (lang === 'en' || lang === 'fr') {
        window.location.reload();
      }
    }
    function initLang() {
      var saved;
      try { saved = localStorage.getItem('sgda-lang'); } catch(e) {}
      var lang = saved || 'fr';
      var hasCookie = document.cookie.split(';').some(function(c) {
        return c.trim().indexOf('sgda-lang=' + lang + '') === 0;
      });
      if (hasCookie) {
        syncLangUI(lang);
      } else {
        applyLang(lang);
      }
    }
    initLang();

    /* ── User dropdown ──────────────────────────────────── */
    var dropdown = document.querySelector('.user-dropdown');
    var trigger = document.querySelector('.user-dropdown-trigger');
    if (trigger && dropdown) {
      trigger.addEventListener('click', function (e) {
        e.stopPropagation();
        dropdown.classList.toggle('is-open');
        var expanded = dropdown.classList.contains('is-open');
        trigger.setAttribute('aria-expanded', expanded);
      });
      document.addEventListener('click', function (e) {
        if (!dropdown.contains(e.target)) {
          dropdown.classList.remove('is-open');
          trigger.setAttribute('aria-expanded', 'false');
        }
      });
      document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
          dropdown.classList.remove('is-open');
          trigger.setAttribute('aria-expanded', 'false');
        }
      });
    }

    /* ── Settings modal ─────────────────────────────────── */
    var settingsModal = document.getElementById('settingsModal');

    function openSettings() {
      if (!settingsModal) return;
      if (settingsDarkToggle) {
        settingsDarkToggle.checked = document.documentElement.getAttribute('data-theme') === 'dark';
      }
      var currentLang;
      try { currentLang = localStorage.getItem('sgda-lang') || 'fr'; } catch(e) { currentLang = 'fr'; }
      var btns = document.querySelectorAll('.lang-btn');
      btns.forEach(function (btn) {
        btn.classList.toggle('is-active', btn.getAttribute('data-lang') === currentLang);
      });
      settingsModal.hidden = false;
    }
    function closeSettings() {
      if (settingsModal) settingsModal.hidden = true;
    }

    /* Language buttons */
    document.addEventListener('click', function (e) {
      var langBtn = e.target.closest('.lang-btn');
      if (!langBtn) return;
      var lang = langBtn.getAttribute('data-lang');
      if (lang) applyLang(lang);
    });

    /* Open settings from dropdown */
    document.addEventListener('click', function (e) {
      var btn = e.target.closest('[data-open-settings]');
      if (btn) {
        e.preventDefault();
        if (dropdown) dropdown.classList.remove('is-open');
        if (trigger) trigger.setAttribute('aria-expanded', 'false');
        openSettings();
      }
    });

    /* Close settings */
    document.querySelectorAll('[data-settings-close]').forEach(function (el) {
      el.addEventListener('click', closeSettings);
    });

    /* ── Sidebar toggle ─────────────────────────────────── */
    var sidebar = document.getElementById('appSidebar');
    var navToggle = document.getElementById('navToggle');
    var overlay = document.querySelector('.sidebar-overlay');

    function openSidebar() {
      if (sidebar) sidebar.classList.add('is-open');
      if (overlay) overlay.style.display = 'block';
    }
    function closeSidebar() {
      if (sidebar) sidebar.classList.remove('is-open');
      if (overlay) overlay.style.display = 'none';
    }
    if (navToggle) {
      navToggle.addEventListener('click', function () {
        if (sidebar && sidebar.classList.contains('is-open')) {
          closeSidebar();
        } else {
          openSidebar();
        }
      });
    }
    if (overlay) {
      overlay.addEventListener('click', closeSidebar);
    }
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') closeSidebar();
    });

    /* ── Ripple on buttons ──────────────────────────────── */
    document.addEventListener('click', function (e) {
      var btn = e.target.closest('.btn');
      if (!btn) return;
      var ripple = document.createElement('span');
      var rect = btn.getBoundingClientRect();
      var size = Math.max(rect.width, rect.height) * 1.5;
      ripple.style.cssText = [
        'position:absolute',
        'border-radius:50%',
        'background:rgba(255,255,255,.25)',
        'pointer-events:none',
        'width:' + size + 'px',
        'height:' + size + 'px',
        'left:' + (e.clientX - rect.left - size / 2) + 'px',
        'top:'  + (e.clientY - rect.top  - size / 2) + 'px',
        'transform:scale(0)',
        'animation:rippleAnim .45s ease-out forwards'
      ].join(';');
      btn.appendChild(ripple);
      setTimeout(function () { ripple.remove(); }, 500);
    });
    /* Ripple keyframes (injected once) */
    if (!document.getElementById('sgda-ripple-style')) {
      var s = document.createElement('style');
      s.id = 'sgda-ripple-style';
      s.textContent = '@keyframes rippleAnim{to{transform:scale(1);opacity:0}}';
      document.head.appendChild(s);
    }

    /* ── Toast system ───────────────────────────────────── */
    var toastStack = document.getElementById('toastStack');

    window.showToast = function (message, type) {
      if (!toastStack) return;
      type = type || 'success';
      var icons = { success: '✓', error: '✕', warning: '!', info: 'i' };
      var titles = window.I18N ? window.I18N.toast.titles : { success: 'Success', error: 'Error', warning: 'Warning', info: 'Info' };

      var toast = document.createElement('div');
      toast.className = 'toast toast-' + type;
      toast.innerHTML = [
        '<div class="toast-header">',
        '  <div class="toast-title-row">',
        '    <div class="toast-icon">' + (icons[type] || '!') + '</div>',
        '    <span class="toast-title">' + (titles[type] || 'Info') + '</span>',
        '  </div>',
        '  <button class="toast-close" aria-label="' + (window.I18N ? window.I18N.toast.closeAria : 'Close') + '">×</button>',
        '</div>',
        '<div class="toast-body">' + message + '</div>',
        '<div class="toast-progress"></div>'
      ].join('');

      toastStack.appendChild(toast);

      /* Limit to 3 */
      var toasts = toastStack.querySelectorAll('.toast');
      if (toasts.length > 3) toasts[0].remove();

      function dismiss() {
        toast.classList.add('hiding');
        setTimeout(function () { toast.remove(); }, 350);
      }

      toast.querySelector('.toast-close').addEventListener('click', dismiss);
      setTimeout(dismiss, 30000);
    };

    /* Bootstrap toasts from data attributes */
    document.querySelectorAll('.toast-bootstrap').forEach(function (el) {
      window.showToast(el.getAttribute('data-toast-message'), el.getAttribute('data-toast-type'));
    });

    /* ── Confirm dialog ─────────────────────────────────── */
    var confirmModal   = document.getElementById('confirmModal');
    var confirmTitle   = document.getElementById('confirmTitle');
    var confirmMessage = document.getElementById('confirmMessage');
    var confirmAccept  = document.getElementById('confirmAccept');
    var confirmCancel  = document.getElementById('confirmCancel');
    var confirmBadge   = document.getElementById('confirmBadge');
    var pendingAction  = null;

    function getI18n(key, fallback) {
      return (window.I18N && window.I18N.confirm && window.I18N.confirm[key]) || fallback;
    }
    function openConfirm(opts) {
      if (!confirmModal) return;
      if (confirmTitle)   confirmTitle.textContent   = opts.title   || getI18n('title', 'Confirm');
      if (confirmMessage) confirmMessage.textContent = opts.message || getI18n('message', 'Do you want to continue?');
      if (confirmAccept)  confirmAccept.textContent  = opts.confirmLabel || getI18n('confirm', 'Confirm');
      if (confirmCancel)  confirmCancel.textContent  = opts.cancelLabel  || getI18n('cancel', 'Cancel');
      pendingAction = opts.onConfirm;
      confirmModal.hidden = false;
    }
    function closeConfirm() {
      if (confirmModal) confirmModal.hidden = true;
      pendingAction = null;
    }

    if (confirmAccept) {
      confirmAccept.addEventListener('click', function () {
        if (pendingAction) pendingAction();
        closeConfirm();
      });
    }
    if (confirmCancel) confirmCancel.addEventListener('click', closeConfirm);
    document.querySelectorAll('[data-confirm-close]').forEach(function (el) {
      el.addEventListener('click', closeConfirm);
    });

    /* Intercept links with data-confirm (logout, etc.) */
    document.addEventListener('click', function (e) {
      var trigger = e.target.closest('[data-confirm]');
      if (!trigger) return;
      if (trigger.tagName === 'A') {
        e.preventDefault();
        openConfirm({
          title:        trigger.getAttribute('data-confirm-title')        || getI18n('title', 'Confirm'),
          message:      trigger.getAttribute('data-confirm')              || getI18n('message', 'Do you want to continue?'),
          confirmLabel: trigger.getAttribute('data-confirm-confirm-label')|| getI18n('confirm', 'Confirm'),
          cancelLabel:  trigger.getAttribute('data-confirm-cancel-label') || getI18n('cancel', 'Cancel'),
          onConfirm: function () { window.location.href = trigger.href; }
        });
        return;
      }
      if (trigger.tagName === 'BUTTON' && trigger.type !== 'submit') return;
      e.preventDefault();
      var form = trigger.closest('form') || trigger;
      openConfirm({
        title:        trigger.getAttribute('data-confirm-title')         || getI18n('title', 'Confirm'),
        message:      trigger.getAttribute('data-confirm')               || getI18n('message', 'Do you want to continue?'),
        confirmLabel: trigger.getAttribute('data-confirm-confirm-label') || getI18n('confirm', 'Confirm'),
        cancelLabel:  trigger.getAttribute('data-confirm-cancel-label')  || getI18n('cancel', 'Cancel'),
        onConfirm: function () {
          if (trigger.tagName === 'BUTTON' && form && form.tagName === 'FORM') {
            form.submit();
          } else if (trigger.tagName === 'A') {
            window.location.href = trigger.href;
          }
        }
      });
    });

    /* ── Sidebar active state ────────────────────────────── */
    function updateActiveFromUrl() {
      var path = window.location.pathname;
      var bestMatch = null;
      var bestLen = 0;
      document.querySelectorAll('.sidebar .nav-item').forEach(function (el) {
        var href = el.getAttribute('href');
        if (href && path.indexOf(href) === 0 && href.length > bestLen) {
          bestLen = href.length;
          bestMatch = el;
        }
      });
      if (bestMatch) {
        document.querySelectorAll('.sidebar .nav-item').forEach(function (el) {
          el.classList.remove('active');
        });
        bestMatch.classList.add('active');
      }
    }
    updateActiveFromUrl();

    document.querySelectorAll('.sidebar .nav-item').forEach(function (item) {
      item.addEventListener('click', function () {
        document.querySelectorAll('.sidebar .nav-item').forEach(function (el) {
          el.classList.remove('active');
        });
        this.classList.add('active');
      });
    });

    /* ── Page dance animation on click ─────────────────── */
    document.addEventListener('click', function (e) {
      if (!e.target.closest('.btn, .nav-item, .kpi-card')) return;
      var cards = document.querySelectorAll('.kpi-card, .content-card, .hero-card');
      cards.forEach(function (card, i) {
        setTimeout(function () {
          card.style.transition = 'transform .35s cubic-bezier(.34,1.56,.64,1)';
          card.style.transform = 'translateY(6px)';
          setTimeout(function () {
            card.style.transform = 'translateY(0)';
            setTimeout(function () { card.style.transition = ''; }, 350);
          }, 120);
        }, i * 30);
      });
    });

  }); /* end DOMContentLoaded */

})();
