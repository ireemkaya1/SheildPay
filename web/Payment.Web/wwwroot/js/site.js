// Please see documentation at https://learn.microsoft.com/aspnet/core/client-side/bundling-and-minification
// for details on configuring this project to bundle and minify static web assets.

// Write your JavaScript code.
/* Payment.Web/wwwroot/js/site.js */
(function () {
  // Nav linklerini JS engellese bile zorla yönlendir (capture phase).
  document.addEventListener(
    "click",
    function (e) {
      const a = e.target && e.target.closest && e.target.closest('a[data-force-nav="1"]');
      if (!a) return;
      e.preventDefault();
      e.stopPropagation();
      const href = a.getAttribute("href");
      if (href) window.location.assign(href);
    },
    true
  );

  // Navbar üstüne binen görünmez katmanı otomatik devre dışı bırak
  function ensureNavbarClickable() {
    const nav = document.getElementById("mainNavbar");
    if (!nav) return;

    // Bootstrap backdrop kalıntılarını temizle
    document.querySelectorAll(".modal-backdrop,.offcanvas-backdrop,.dropdown-backdrop")
      .forEach((el) => el.remove());
    document.body.classList.remove("modal-open");
    document.body.style.overflow = "auto";

    // Navbar üstünde başka bir eleman varsa pointer-events kapat
    const r = nav.getBoundingClientRect();
    const x = r.left + r.width / 2;
    const y = r.top + Math.min(r.height / 2, 20);
    const topEl = document.elementFromPoint(x, y);

    if (topEl && topEl !== nav && !nav.contains(topEl)) {
      try { topEl.style.pointerEvents = "none"; } catch (_) {}
    }
  }

  window.addEventListener("load", () => {
    ensureNavbarClickable();
    // İlk birkaç saniye sık kontrol et (overlay kalıntısı için)
    const t = setInterval(ensureNavbarClickable, 250);
    setTimeout(() => clearInterval(t), 5000);
  });
})();
