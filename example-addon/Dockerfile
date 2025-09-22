ARG BUILD_FROM=ghcr.io/hassio-addons/base:16.3.2
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install packages
RUN apk add --no-cache \
    python3=3.12.3-r1 \
    py3-pip=24.0-r2

# Copy application files
COPY rootfs /
RUN chmod a+x /etc/services.d/*/run

# Create simple Python app
RUN echo '#!/usr/bin/env python3
import http.server
import socketserver
import os

PORT = 8080
Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Example addon serving at port {PORT}")
    httpd.serve_forever()
' > /usr/local/bin/example-app.py && chmod +x /usr/local/bin/example-app.py

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="ddcash" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="N1K0 Home Assistant Add-ons" \
    org.opencontainers.image.authors="ddcash" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/ddcash/n1k0-addons" \
    org.opencontainers.image.source="https://github.com/ddcash/n1k0-addons/tree/main/example-addon" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}