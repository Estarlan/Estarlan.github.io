// Created: 23:26 12-Oct-2026
// Carga los .drawio del portafolio y los muestra con el visor oficial de diagrams.net.
// Uso en el HTML: <div class="modelo-body" data-drawio="../modelos/taller1/01_Ej1a_IMPORTADOR.drawio"></div>

(function () {
  "use strict";

  var VIEWER_URL = "https://viewer.diagrams.net/js/viewer-static.min.js";
  var CONFIG_BASE = {
    highlight: "#ec3013",
    nav: true,
    resize: true,
    lightbox: true,
    toolbar: "zoom layers lightbox",
    "toolbar-nohide": true
  };

  function mostrarError(el, ruta) {
    el.innerHTML =
      '<p class="loading">No se pudo cargar el modelo. ' +
      '<a href="' + ruta + '" download>Descargar el archivo .drawio</a> y abrirlo en app.diagrams.net.</p>';
  }

  function prepararModelo(el) {
    var ruta = el.getAttribute("data-drawio");
    return fetch(ruta)
      .then(function (r) {
        if (!r.ok) throw new Error("HTTP " + r.status);
        return r.text();
      })
      .then(function (xml) {
        var cfg = Object.assign({}, CONFIG_BASE, { xml: xml });
        var div = document.createElement("div");
        div.className = "mxgraph";
        div.style.maxWidth = "100%";
        div.setAttribute("data-mxgraph", JSON.stringify(cfg));
        el.innerHTML = "";
        el.appendChild(div);
        return true;
      })
      .catch(function (err) {
        console.warn("[modelos] " + ruta + ": " + err.message);
        mostrarError(el, ruta);
        return false;
      });
  }

  function cargarVisor() {
    var s = document.createElement("script");
    s.src = VIEWER_URL;
    s.async = true;
    s.onerror = function () {
      document.querySelectorAll(".mxgraph").forEach(function (d) {
        var cont = d.parentNode;
        mostrarError(cont, cont.getAttribute("data-drawio"));
      });
    };
    document.body.appendChild(s);
  }

  document.addEventListener("DOMContentLoaded", function () {
    var modelos = Array.prototype.slice.call(document.querySelectorAll("[data-drawio]"));
    if (!modelos.length) return;
    Promise.all(modelos.map(prepararModelo)).then(function (res) {
      if (res.some(Boolean)) cargarVisor();
    });
  });
})();
