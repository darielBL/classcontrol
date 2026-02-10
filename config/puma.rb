# Desactiva workers para Koyeb (funciona mejor)
workers 0

# Configura threads
threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# Puerto para Koyeb
port ENV.fetch("PORT", 3001)

# Entorno
environment ENV.fetch("RAILS_ENV", "production")

# Bind específico para Koyeb
bind "tcp://0.0.0.0:#{ENV.fetch('PORT', 3001)}"

# Worker timeout para evitar reinicios prematuros
worker_timeout 3600

# No usar preload_app! en Koyeb con workers 0
# plugin :tmp_restart  # Opcional