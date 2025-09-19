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

# Set data directory
export DATA_DIR=/data
mkdir -p $DATA_DIR

bashio::log.info "Starting Pangolin on port $PORT"
bashio::log.info "Log level: $LOG_LEVEL"

# Start Pangolin
cd /app
exec npm start