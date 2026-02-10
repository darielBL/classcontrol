// app/javascript/controllers/session_controller.js

document.addEventListener("DOMContentLoaded", () => {
    console.log("Session controller loaded.");
    const links = document.querySelectorAll('a[data-method="delete"]');
    links.forEach(link => {
        link.addEventListener("click", function(event) {
            event.preventDefault(); // Prevenir el comportamiento por defecto del enlace
            const href = this.getAttribute("href");
            fetch(href, {
                method: "DELETE",
                headers: {
                    "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content")
                },
            }).then(response => {
                if (response.ok) {
                    window.location.href = "/"; // Redirigir a la página principal o donde desees
                } else {
                    console.error("Error al cerrar sesión");
                }
            });
        });
    });
});
