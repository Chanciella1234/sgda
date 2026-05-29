/* ============================================================
   SGDA — water-animations.js
   Subtle ambient animations for visual polish
   ============================================================ */
(function () {
  'use strict';
  document.addEventListener('DOMContentLoaded', function () {
    /* Hero orbs float animation */
    var orbs = document.querySelectorAll('.hero-orb');
    orbs.forEach(function (orb, i) {
      orb.style.animation = 'orbFloat ' + (4 + i * 1.5) + 's ease-in-out ' + (i * 0.8) + 's infinite alternate';
    });
    if (!document.getElementById('sgda-water-style')) {
      var s = document.createElement('style');
      s.id = 'sgda-water-style';
      s.textContent = '@keyframes orbFloat{from{transform:translateY(0) scale(1)}to{transform:translateY(-12px) scale(1.05)}}';
      document.head.appendChild(s);
    }
  });
})();
