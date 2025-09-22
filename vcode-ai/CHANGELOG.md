# Changelog

## [1.0.2] - 2025-09-22

### Fixed
- Simplified Docker build by moving VSCode extension installation to runtime
- Removed complex extension download process during build that was causing failures
- Extensions now install on first startup using code-server's built-in installer
- Improved build reliability and reduced build time

## [1.0.1] - 2025-09-22

### Fixed
- Removed package version pinning to fix Docker build failures
- Updated persistence to use `/addon_configs/local_vscode-claude/` instead of `/data/`
- Fixed outdated Debian package versions causing build errors

## [1.0.0] - 2025-09-22

### Added
- Initial release based on official Home Assistant VSCode addon
- Integrated Claude Code CLI for AI-powered development
- Pre-installed Claude Dev extension for inline AI assistance
- Persistent Claude Code CLI configuration in `/addon_configs/local_vscode-claude/claude-code/`
- Support for Anthropic API key configuration
- MCP server configuration persistence
- Enhanced extension set including:
  - Claude Dev extension
  - Python development support
  - Additional development tools

### Features
- Full Visual Studio Code experience in browser
- Claude Code CLI v1.x integration
- Code-server v4.103.2
- Home Assistant configuration syntax highlighting
- Material Design Icons intellisense
- ESPHome development support
- Persistent workspace and configuration storage
- Multi-architecture support (amd64/aarch64)

### Configuration
- API key support via `/addon_configs/local_vscode-claude/claude_api_key` or `/config/claude_api_key`
- Automatic environment setup for Claude Code CLI
- Persistent configuration directory mapping
- Secure integration with Home Assistant authentication