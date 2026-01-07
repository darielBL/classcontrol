# Pin npm packages by running ./bin/importmap

pin "application"
pin "application", preload: true

pin "jquery", to: "https://code.jquery.com/jquery-3.6.0.min.js"

pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"
pin "bootstrap-icons", to: "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css"

pin "@rails/ujs", to: "rails-ujs.js"

pin "@hotwired/turbo-rails", to: "turbo.min.js"
