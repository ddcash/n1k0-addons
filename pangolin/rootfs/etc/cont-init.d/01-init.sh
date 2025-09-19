#!/usr/bin/with-contenv bashio
# ==============================================================================
# Initialize Pangolin addon
# ==============================================================================

bashio::log.info "Initializing Pangolin Reverse Proxy..."

# Create data directory
mkdir -p /data

# Set permissions
chown -R root:root /data

bashio::log.info "Pangolin initialization complete!"