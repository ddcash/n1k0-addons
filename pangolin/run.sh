#!/usr/bin/with-contenv bashio

# Get port configuration
PORT=$(bashio::config 'port')
LOG_LEVEL=$(bashio::config 'log_level')

# Set environment variables for Pangolin
export PORT=${PORT:-3003}
export LOG_LEVEL=${LOG_LEVEL:-info}
export NODE_ENV=production
export ENVIRONMENT=prod

# Handle ingress configuration
if bashio::var.has_value "$(bashio::addon.ingress_entry)"; then
    export INGRESS_PATH="$(bashio::addon.ingress_entry)"
    export BASE_PATH="$INGRESS_PATH"
    export PUBLIC_URL="$INGRESS_PATH"
    bashio::log.info "Ingress enabled with path: $INGRESS_PATH"
    
    # Configure for ingress - bind to all interfaces
    export HOST="0.0.0.0"
    export HOSTNAME="0.0.0.0"
else
    export INGRESS_PATH=""
    export BASE_PATH=""
    export PUBLIC_URL=""
    export HOST="0.0.0.0"
    export HOSTNAME="0.0.0.0"
fi

# Set data directory and database path
export DATA_DIR=/data
mkdir -p $DATA_DIR
export DATABASE_URL="file:$DATA_DIR/pangolin.db"

bashio::log.info "Starting Pangolin on port $PORT"
bashio::log.info "Log level: $LOG_LEVEL"
bashio::log.info "Database: $DATABASE_URL"
bashio::log.info "Host binding: $HOST:$PORT"

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
bashio::log.info "Server will be available at http://$HOST:$PORT$BASE_PATH"

exec node --enable-source-maps dist/server.mjs