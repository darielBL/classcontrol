# Puerto
port ENV.fetch("PORT", 3001)

# Entorno
environment ENV.fetch("RAILS_ENV", "production")

# Threads básicos
threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# Sin workers para Koyeb
workers 0

