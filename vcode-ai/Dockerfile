ARG BUILD_FROM=ghcr.io/hassio-addons/base:16.3.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Environment variables
ENV \
    LANG="C.UTF-8" \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_CMD_WAIT_FOR_SERVICES=1

# Install base packages
RUN \
    apk add --no-cache \
        brotli=1.1.0-r2 \
        git=2.45.2-r0 \
        nginx=1.26.2-r0 \
        openssh=9.7_p1-r4 \
        openssh-keygen=9.7_p1-r4 \
        python3=3.12.3-r1 \
        py3-pip=24.0-r2 \
        nodejs=20.15.1-r0 \
        npm=10.8.0-r0 \
        curl=8.9.0-r0 \
        wget=1.24.5-r0 \
        bash=5.2.26-r0 \
    && apk add --no-cache --virtual .build-dependencies \
        build-base=0.5-r3 \
        libffi-dev=3.4.6-r0 \
        openssl-dev=3.3.1-r3 \
        python3-dev=3.12.3-r1 \
    && pip3 install --no-cache-dir \
        pylint==3.2.6 \
        yamllint==1.35.1 \
    && apk del --no-cache --purge .build-dependencies

# Download and install code-server
ARG CODESERVER_VERSION="4.103.2"
ARG TARGETARCH
RUN \
    if [ "${TARGETARCH}" = "amd64" ]; then ARCH="x64"; fi \
    && if [ "${TARGETARCH}" = "arm64" ]; then ARCH="arm64"; fi \
    && curl -J -L -o /tmp/code-server.tar.gz \
        "https://github.com/coder/code-server/releases/download/v${CODESERVER_VERSION}/code-server-${CODESERVER_VERSION}-linux-${ARCH}.tar.gz" \
    && mkdir -p /usr/local/lib/code-server \
    && tar zxvf /tmp/code-server.tar.gz --strip 1 -C /usr/local/lib/code-server \
    && ln -s /usr/local/lib/code-server/bin/code-server /usr/local/bin/code-server \
    && rm -rf /tmp/code-server.tar.gz

# Install Claude Code CLI
RUN \
    npm install -g @anthropic-ai/claude-code@latest \
    && mkdir -p /root/.config

# Create volumes for persistent data
VOLUME ["/data"]

# Create vscode extensions list
COPY vscode.extensions /root/
RUN \
    mkdir -p /usr/local/lib/code-server/lib/vscode/extensions/ \
    && mkdir -p /root/.code-server/extensions \
    && UUID="$(cat /proc/sys/kernel/random/uuid)" \
    && while read -r ext; do \
        vendor="$(echo "${ext}" | cut -d'.' -f1)"; \
        slug="$(echo "${ext}" | cut -d'.' -f2-)"; \
        version="$(curl -s "https://marketplace.visualstudio.com/items?itemName=${ext}" | grep -oP 'AssetUri.*?".*?vsix' | head -1 | grep -oP '/[^/]+/[^/]+/' | grep -oP '[0-9]+\.[0-9]+\.[0-9]+')"; \
        echo "Installing ${ext} version ${version}..."; \
        curl -JL \
            -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" \
            -o "/tmp/${ext}-${version}.vsix" \
            "https://${vendor}.gallery.vsservices.visualstudio.com/_apis/public/gallery/publisher/${vendor}/extension/${slug}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"; \
        mkdir -p "/usr/local/lib/code-server/lib/vscode/extensions/${ext}-${version}"; \
        unzip -q "/tmp/${ext}-${version}.vsix" -d "/tmp/${ext}"; \
        mv "/tmp/${ext}/extension/"* "/usr/local/lib/code-server/lib/vscode/extensions/${ext}-${version}/"; \
        rm -rf "/tmp/${ext}" "/tmp/${ext}-${version}.vsix"; \
    done < /root/vscode.extensions

# Copy files for add-on
COPY rootfs /
RUN chmod a+x /etc/services.d/*/run /etc/services.d/*/finish

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
    org.opencontainers.image.source="https://github.com/ddcash/n1k0-addons/tree/main/vcode-ai" \
    org.opencontainers.image.documentation="https://github.com/ddcash/n1k0-addons/tree/main/vcode-ai/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}