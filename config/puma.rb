# Koyeb necesita workers 0
workers 0

# Threads configurados
threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# Puerto específico
port ENV.fetch("PORT", 3001)

# Entorno
environment ENV.fetch("RAILS_ENV", "production")

# Bind explícito
bind "tcp://0.0.0.0:#{ENV.fetch('PORT', 3001)}"

# Timeout más largo para Koyeb
worker_timeout 3600

# Sin preload_app (causa problemas en Koyeb)
# plugin :tmp_restart