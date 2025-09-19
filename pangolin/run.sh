#!/usr/bin/with-contenv bashio

# Get port configuration
PORT=$(bashio::config 'port')
LOG_LEVEL=$(bashio::config 'log_level')

# Set environment variables
export PORT=${PORT:-3000}
export LOG_LEVEL=${LOG_LEVEL:-info}
export NODE_ENV=production

# Handle ingress
if bashio::var.has_value "$(bashio::addon.ingress_entry)"; then
    export INGRESS_PATH="$(bashio::addon.ingress_entry)"
    bashio::log.info "Ingress enabled with path: $INGRESS_PATH"
else
    export INGRESS_PATH=""
fi

# Set data directory and database path
export DATA_DIR=/data
mkdir -p $DATA_DIR
export DATABASE_URL="file:$DATA_DIR/pangolin.db"

bashio::log.info "Starting Pangolin on port $PORT"
bashio::log.info "Log level: $LOG_LEVEL"
bashio::log.info "Database: $DATABASE_URL"

# Change to app directory
cd /app

# Try to run migrations, but don't fail if they don't work
bashio::log.info "Attempting to run database migrations..."
if ! node dist/migrations.mjs 2>/dev/null; then
    bashio::log.warning "Migration failed, but continuing startup..."
    bashio::log.info "Pangolin will create tables on first use"
fi

# Start Pangolin server directly
bashio::log.info "Starting Pangolin server..."
exec node --enable-source-maps dist/server.mjs