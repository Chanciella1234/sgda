// Water-inspired animations using GSAP
// This script adds micro‑interactions, scroll‑triggered fades, and ripple effects.
// It is loaded after GSAP (via CDN) and executed on page load.

window.initWaterAnimations = function () {
  // Check if GSAP is loaded
  if (typeof gsap === 'undefined') {
    console.warn('GSAP not loaded. Water animations disabled.');
    return;
  }

  // ----- Micro‑interactions (hover scaling) -----
  document.querySelectorAll('.water-hover').forEach(el => {
    el.addEventListener('mouseenter', () => {
      gsap.to(el, { scale: 1.05, duration: 0.3, ease: 'power2.out' });
    });
    el.addEventListener('mouseleave', () => {
      gsap.to(el, { scale: 1, duration: 0.3, ease: 'power2.out' });
    });
  });

  // ----- Scroll‑triggered fade‑in (using Intersection Observer for performance) -----
  if ('IntersectionObserver' in window) {
    const fadeObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          gsap.to(entry.target, {
            opacity: 1,
            y: 0,
            duration: 0.6,
            ease: 'power1.out'
          });
          fadeObserver.unobserve(entry.target);
        }
      });
    }, { threshold: 0.1 });

    document.querySelectorAll('.scroll-fade').forEach(el => {
      gsap.set(el, { opacity: 0, y: 20 });
      fadeObserver.observe(el);
    });
  } else {
    // Fallback for older browsers
    document.querySelectorAll('.scroll-fade').forEach(el => {
      gsap.set(el, { opacity: 1, y: 0 });
    });
  }

  // ----- Ripple effect on click -----
  document.querySelectorAll('.ripple').forEach(el => {
    el.addEventListener('click', e => {
      const rect = el.getBoundingClientRect();
      const ripple = document.createElement('span');
      const size = Math.max(rect.width, rect.height);
      ripple.style.width = ripple.style.height = `${size}px`;
      ripple.style.left = `${e.clientX - rect.left - size / 2}px`;
      ripple.style.top = `${e.clientY - rect.top - size / 2}px`;
      ripple.className = 'ripple-effect';
      el.appendChild(ripple);
      gsap.to(ripple, {
        scale: 2,
        opacity: 0,
        duration: 0.6,
        ease: 'power2.out',
        onComplete: () => ripple.remove(),
      });
    });
  });

  // ----- Tooltip animations -----
  document.querySelectorAll('[data-tooltip]').forEach(el => {
    let tooltip;
    el.addEventListener('mouseenter', () => {
      const text = el.getAttribute('data-tooltip');
      tooltip = document.createElement('div');
      tooltip.className = 'tooltip';
      tooltip.textContent = text;
      document.body.appendChild(tooltip);
      const rect = el.getBoundingClientRect();
      tooltip.style.position = 'absolute';
      tooltip.style.left = `${rect.left + rect.width / 2 - tooltip.offsetWidth / 2}px`;
      tooltip.style.top = `${rect.top - tooltip.offsetHeight - 8}px`;
      gsap.fromTo(tooltip, { opacity: 0, y: 5 }, { opacity: 1, y: 0, duration: 0.2, ease: 'power2.out' });
    });
    el.addEventListener('mouseleave', () => {
      if (tooltip) {
        gsap.to(tooltip, { opacity: 0, y: 5, duration: 0.2, ease: 'power2.in', onComplete: () => {
          tooltip.remove();
          tooltip = null;
        } });
      }
    });
  });

  // ----- Water float animation -----
  document.querySelectorAll('.water-float').forEach(el => {
    gsap.to(el, {
      y: -10,
      duration: 2,
      ease: 'sine.inOut',
      yoyo: true,
      repeat: -1
    });
  });
};

// Initialize when DOM is ready
if (document.readyState !== 'loading') {
  window.initWaterAnimations();
} else {
  document.addEventListener('DOMContentLoaded', window.initWaterAnimations);
}
