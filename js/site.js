// Created: 10:32 28-Oct-2026
// Updated: 17:20 28-Oct-2026
// Navegación móvil, filtros de evidencias y año del pie.

(function () {
  "use strict";

  var doc = document;
  var header = doc.querySelector(".top");
  var toggle = doc.getElementById("navToggle");
  var nav = doc.getElementById("nav");

  /* Menú móvil */
  function cerrarMenu() {
    if (!nav || !toggle) return;
    nav.classList.remove("is-open");
    toggle.setAttribute("aria-expanded", "false");
    doc.body.classList.remove("nav-open");
  }
  if (toggle && nav) {
    toggle.addEventListener("click", function () {
      var abierto = nav.classList.toggle("is-open");
      toggle.setAttribute("aria-expanded", String(abierto));
      doc.body.classList.toggle("nav-open", abierto);
    });
    nav.addEventListener("click", function (e) {
      if (e.target.closest("a")) cerrarMenu();
    });
    doc.addEventListener("keydown", function (e) {
      if (e.key === "Escape" && nav.classList.contains("is-open")) {
        cerrarMenu();
        toggle.focus();
      }
    });
  }

  /* Cabecera compacta al bajar */
  function alScroll() {
    if (header) header.classList.toggle("is-scrolled", window.scrollY > 12);
  }
  alScroll();
  window.addEventListener("scroll", alScroll, { passive: true });

  /* Filtros del índice de evidencias */
  var filtros = Array.prototype.slice.call(doc.querySelectorAll("[data-filter]"));
  var tarjetas = Array.prototype.slice.call(doc.querySelectorAll("[data-cat]"));
  if (filtros.length && tarjetas.length) {
    filtros.forEach(function (btn) {
      btn.addEventListener("click", function () {
        var cat = btn.getAttribute("data-filter");
        filtros.forEach(function (b) {
          b.classList.toggle("is-active", b === btn);
          b.setAttribute("aria-pressed", String(b === btn));
        });
        tarjetas.forEach(function (c) {
          c.classList.toggle("is-hidden", !(cat === "all" || c.getAttribute("data-cat") === cat));
        });
        var contador = doc.getElementById("filterCount");
        if (contador) {
          var visibles = tarjetas.filter(function (c) { return !c.classList.contains("is-hidden"); }).length;
          contador.textContent = visibles + (visibles === 1 ? " evidencia" : " evidencias");
        }
      });
    });
  }

  /* Año del pie */
  var anio = doc.getElementById("year");
  if (anio) anio.textContent = new Date().getFullYear();
})();
