#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: VSCode with Claude Code AI
# Configures code-server
# ==============================================================================

bashio::log.info "Preparing code-server configuration..."

# Ensure data directory exists
if ! bashio::fs.directory_exists "/data/vscode"; then
    bashio::log.debug "Creating VSCode data directory"
    mkdir -p /data/vscode
fi

# Set up Claude Code CLI configuration directory
if ! bashio::fs.directory_exists "/data/claude-code"; then
    bashio::log.debug "Creating Claude Code CLI data directory"
    mkdir -p /data/claude-code
fi

# Ensure .config directory exists
mkdir -p /root/.config

# Create symbolic link for Claude Code CLI config
if ! bashio::fs.file_exists "/root/.config/claude-code"; then
    ln -sf /data/claude-code /root/.config/claude-code
fi

# Set up Claude Code CLI global configuration directory for MCP servers
if ! bashio::fs.directory_exists "/data/claude-code/mcp"; then
    bashio::log.debug "Creating Claude Code MCP configuration directory"
    mkdir -p /data/claude-code/mcp
fi

# Initialize Claude Code CLI configuration if it doesn't exist
CLAUDE_CONFIG_FILE="/data/claude-code/config.json"
if ! bashio::fs.file_exists "${CLAUDE_CONFIG_FILE}"; then
    bashio::log.info "Initializing Claude Code CLI configuration"
    cat > "${CLAUDE_CONFIG_FILE}" << 'EOF'
{
  "mcpServers": {}
}
EOF
fi

# Create Claude Code CLI MCP servers configuration directory
MCP_SERVERS_DIR="/data/claude-code/mcp-servers"
if ! bashio::fs.directory_exists "${MCP_SERVERS_DIR}"; then
    mkdir -p "${MCP_SERVERS_DIR}"
fi

# Set environment variables for Claude Code CLI persistence
export CLAUDE_CONFIG_DIR="/data/claude-code"
export CLAUDE_MCP_SERVERS_DIR="/data/claude-code/mcp-servers"

# Create workspace settings for Claude Code integration
VSCODE_SETTINGS_DIR="/data/vscode/User"
VSCODE_SETTINGS_FILE="${VSCODE_SETTINGS_DIR}/settings.json"

if ! bashio::fs.directory_exists "${VSCODE_SETTINGS_DIR}"; then
    mkdir -p "${VSCODE_SETTINGS_DIR}"
fi

# Create default settings with Claude Code configuration
if ! bashio::fs.file_exists "${VSCODE_SETTINGS_FILE}"; then
    bashio::log.info "Creating default VSCode settings with Claude Code integration"
    cat > "${VSCODE_SETTINGS_FILE}" << 'EOF'
{
    "workbench.colorTheme": "Default Dark+",
    "editor.fontSize": 14,
    "editor.tabSize": 2,
    "editor.insertSpaces": true,
    "files.autoSave": "afterDelay",
    "terminal.integrated.shell.linux": "/bin/bash",
    "extensions.autoUpdate": false,
    "update.mode": "none",
    "telemetry.enableTelemetry": false,
    "workbench.enableExperiments": false,
    "extensions.ignoreRecommendations": true,
    "claude-dev.apiKey": "",
    "claude-dev.modelName": "claude-3-5-sonnet-20241022"
}
EOF
fi

bashio::log.info "Code-server configuration completed"