// Created: 10:32 28-Oct-2026
// Visor ampliado de los diagramas del proyecto.

(function () {
  "use strict";

  var items = Array.prototype.slice.call(document.querySelectorAll("[data-lightbox]"));
  var lb = document.getElementById("lightbox");
  if (!items.length || !lb) return;

  var img = lb.querySelector("img");
  var cap = lb.querySelector("figcaption");
  var cerrarBtn = lb.querySelector(".lb-close");
  var indice = 0;
  var ultimoFoco = null;

  function pintar() {
    var item = items[indice];
    img.src = item.getAttribute("data-src");
    img.alt = item.getAttribute("data-alt") || "";
    cap.textContent = item.getAttribute("data-cap") || "";
  }
  function abrir(i, origen) {
    indice = i;
    ultimoFoco = origen || null;
    pintar();
    lb.hidden = false;
    document.body.classList.add("nav-open");
    cerrarBtn.focus();
  }
  function cerrar() {
    lb.hidden = true;
    document.body.classList.remove("nav-open");
    if (ultimoFoco) ultimoFoco.focus();
  }
  function mover(paso) {
    indice = (indice + paso + items.length) % items.length;
    pintar();
  }

  items.forEach(function (item, i) {
    item.addEventListener("click", function () { abrir(i, item); });
  });
  cerrarBtn.addEventListener("click", cerrar);
  lb.querySelector(".lb-prev").addEventListener("click", function () { mover(-1); });
  lb.querySelector(".lb-next").addEventListener("click", function () { mover(1); });
  lb.addEventListener("click", function (e) { if (e.target === lb) cerrar(); });
  document.addEventListener("keydown", function (e) {
    if (lb.hidden) return;
    if (e.key === "Escape") cerrar();
    if (e.key === "ArrowLeft") mover(-1);
    if (e.key === "ArrowRight") mover(1);
  });
})();
