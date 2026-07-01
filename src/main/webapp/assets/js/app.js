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
  }
  function initTheme() {
    var saved;
    try { saved = localStorage.getItem('sgda-theme'); } catch(e) {}
    var preferred = saved || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
    applyTheme(preferred);
  }
  initTheme();

  /* ── Run after DOM ready ───────────────────────────────── */
  document.addEventListener('DOMContentLoaded', function () {

    /* Dark mode toggle button — inject into navbar */
    var navbar = document.querySelector('.navbar-right, .user-info');
    if (navbar) {
      var toggleBtn = document.createElement('button');
      toggleBtn.className = 'dark-toggle';
      toggleBtn.setAttribute('aria-label', 'Basculer le mode sombre');
      toggleBtn.title = 'Mode sombre / clair';
      toggleBtn.addEventListener('click', function () {
        var current = document.documentElement.getAttribute('data-theme');
        applyTheme(current === 'dark' ? 'light' : 'dark');
      });
      var navRight = document.querySelector('.navbar-right');
      if (!navRight) {
        navRight = document.createElement('div');
        navRight.className = 'navbar-right';
        var navbar2 = document.querySelector('.navbar');
        if (navbar2) navbar2.appendChild(navRight);
      }
      navRight.insertBefore(toggleBtn, navRight.firstChild);
    }

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
      var titles = { success: 'Succès', error: 'Erreur', warning: 'Attention', info: 'Info' };

      var toast = document.createElement('div');
      toast.className = 'toast toast-' + type;
      toast.innerHTML = [
        '<div class="toast-header">',
        '  <div class="toast-title-row">',
        '    <div class="toast-icon">' + (icons[type] || '!') + '</div>',
        '    <span class="toast-title">' + (titles[type] || 'Info') + '</span>',
        '  </div>',
        '  <button class="toast-close" aria-label="Fermer">×</button>',
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

    function openConfirm(opts) {
      if (!confirmModal) return;
      if (confirmTitle)   confirmTitle.textContent   = opts.title   || 'Confirmer';
      if (confirmMessage) confirmMessage.textContent = opts.message || 'Voulez-vous continuer ?';
      if (confirmAccept)  confirmAccept.textContent  = opts.confirmLabel || 'Confirmer';
      if (confirmCancel)  confirmCancel.textContent  = opts.cancelLabel  || 'Annuler';
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
          title:        trigger.getAttribute('data-confirm-title')        || 'Confirmer l\'action',
          message:      trigger.getAttribute('data-confirm')              || 'Voulez-vous continuer ?',
          confirmLabel: trigger.getAttribute('data-confirm-confirm-label')|| 'Confirmer',
          cancelLabel:  trigger.getAttribute('data-confirm-cancel-label') || 'Annuler',
          onConfirm: function () { window.location.href = trigger.href; }
        });
        return;
      }
      if (trigger.tagName === 'BUTTON' && trigger.type !== 'submit') return;
      e.preventDefault();
      var form = trigger.closest('form') || trigger;
      openConfirm({
        title:        trigger.getAttribute('data-confirm-title')         || 'Confirmer l\'action',
        message:      trigger.getAttribute('data-confirm')               || 'Voulez-vous continuer ?',
        confirmLabel: trigger.getAttribute('data-confirm-confirm-label') || 'Confirmer',
        cancelLabel:  trigger.getAttribute('data-confirm-cancel-label')  || 'Annuler',
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
