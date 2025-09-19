#!/usr/bin/with-contenv bashio

# Get configuration from Home Assistant
PORT=$(bashio::config 'port')
DATABASE=$(bashio::config 'database')
LOG_LEVEL=$(bashio::config 'log_level')
ADMIN_EMAIL=$(bashio::config 'admin_email')
ADMIN_PASSWORD=$(bashio::config 'admin_password')

# Authentik configuration
AUTHENTIK_ENABLED=$(bashio::config 'authentik_enabled')
AUTHENTIK_URL=$(bashio::config 'authentik_url')
AUTHENTIK_CLIENT_ID=$(bashio::config 'authentik_client_id')
AUTHENTIK_CLIENT_SECRET=$(bashio::config 'authentik_client_secret')
AUTHENTIK_AUTO_PROVISION=$(bashio::config 'authentik_auto_provision')

# Set environment variables
export NODE_ENV=production
export ENVIRONMENT=prod
export DATABASE=${DATABASE:-sqlite}
export PORT=${PORT:-3000}
export LOG_LEVEL=${LOG_LEVEL:-info}

# Set Authentik environment variables if enabled
if [ "$AUTHENTIK_ENABLED" = "true" ] && [ -n "$AUTHENTIK_URL" ]; then
    export OAUTH_PROVIDER_NAME="authentik"
    export OAUTH_AUTHORIZATION_URL="${AUTHENTIK_URL}/application/o/authorize/"
    export OAUTH_TOKEN_URL="${AUTHENTIK_URL}/application/o/token/"
    export OAUTH_CLIENT_ID="$AUTHENTIK_CLIENT_ID"
    export OAUTH_CLIENT_SECRET="$AUTHENTIK_CLIENT_SECRET"
    export OAUTH_AUTO_PROVISION="$AUTHENTIK_AUTO_PROVISION"
    bashio::log.info "Authentik SSO enabled with URL: $AUTHENTIK_URL"
fi

# Ingress configuration
if bashio::var.has_value "$(bashio::addon.ingress_entry)"; then
    export INGRESS_PATH="$(bashio::addon.ingress_entry)"
    bashio::log.info "Ingress enabled with path: $INGRESS_PATH"
    export PUBLIC_URL="$INGRESS_PATH"
    # Update ingress port to match configured port
    export INGRESS_PORT="$PORT"
else
    export INGRESS_PATH=""
    export PUBLIC_URL=""
fi

# Set data directory
export DATA_DIR=/data
mkdir -p $DATA_DIR

# Set database path for SQLite
if [ "$DATABASE" = "sqlite" ]; then
    export DATABASE_URL="file:$DATA_DIR/pangolin.db"
else
    bashio::log.info "PostgreSQL database configuration not yet implemented"
fi

bashio::log.info "Starting Pangolin Reverse Proxy..."
bashio::log.info "Port: $PORT"
bashio::log.info "Database: $DATABASE"
bashio::log.info "Log Level: $LOG_LEVEL"
if [ -n "$INGRESS_PATH" ]; then
    bashio::log.info "Ingress Path: $INGRESS_PATH"
fi

# Run database migrations
bashio::log.info "Running database migrations..."
node dist/migrations.mjs

# Start the server
bashio::log.info "Starting Pangolin server..."
exec node --enable-source-maps dist/server.mjs