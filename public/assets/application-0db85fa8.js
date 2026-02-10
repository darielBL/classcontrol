// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// app/assets/javascripts/application.js
// import "@hotwired/turbo-rails";
// import "./controllers"
import "bootstrap"
import "@rails/ujs" // Asegúrate de que esto esté presente

import Rails from "@rails/ujs"
Rails.start()

// app/javascript/application.js
import "./controllers/session_controller"; // Importa tu controlador


console.log("JavaScript cargado");