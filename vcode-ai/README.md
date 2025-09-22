# Home Assistant Add-on: VSCode with Claude Code AI

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]

A Visual Studio Code experience with Claude Code CLI integration, accessible through your browser and optimized for Home Assistant development.

## About

This add-on provides a browser-based Visual Studio Code experience with the powerful Claude Code CLI integrated, allowing you to leverage AI-powered development directly within your Home Assistant environment.

### Features

- **Full VSCode Experience**: Complete Visual Studio Code interface accessible through your browser
- **Claude Code Integration**: AI-powered coding assistance with Claude Code CLI pre-installed
- **Home Assistant Optimized**: Pre-configured with Home Assistant, YAML, and MDI extensions
- **Secure Access**: Integrated with Home Assistant's authentication system
- **Persistent Configuration**: Your settings, workspaces, and Claude Code CLI configuration (including MCP servers) are preserved between restarts
- **Multi-Architecture Support**: Works on both amd64 and aarch64 systems

## Installation

1. Navigate to Supervisor → Add-on Store in your Home Assistant instance
2. Add this repository: `https://github.com/ddcash/n1k0-addons`
3. Install the "VSCode with Claude Code AI" add-on
4. Configure the add-on (see configuration section below)
5. Start the add-on

## Configuration

### Add-on Configuration

```yaml
packages:
  - example-package
init_commands:
  - echo "Hello World"
config_path: "/config/vscode"
log_level: info
```

### Option: `packages`

Additional Alpine packages to install. Use this to add any additional tools or dependencies you need.

### Option: `init_commands`

Commands to run during the start of the add-on. Use this to run any initialization scripts or commands.

### Option: `config_path`

Custom path for VSCode configuration. If not specified, uses `/data/vscode`.

### Option: `log_level`

The log level for the add-on. Options: `trace`, `debug`, `info`, `notice`, `warning`, `error`, `fatal`.

## Claude Code CLI Setup

To use Claude Code CLI features:

1. Obtain an Anthropic API key from https://console.anthropic.com/
2. Create a file containing your API key at one of these locations:
   - `/config/claude_api_key` (recommended)
   - `/data/claude-code/api_key` (persistent storage)
3. Restart the add-on
4. The Claude Code CLI will automatically be configured with your API key

### Persistent Configuration

All Claude Code CLI configuration, including MCP servers, is stored in `/data/claude-code/` and persists across addon restarts and system reboots. This includes:

- API key configuration
- MCP server configurations
- Claude Code CLI settings and preferences
- Custom configurations and profiles

## Usage

1. After starting the add-on, click "OPEN WEB UI" to access VSCode
2. Your Home Assistant configuration directory is automatically mounted and accessible
3. Use the integrated terminal to run Claude Code CLI commands:
   - `claude-code` - Start an interactive session
   - `claude-code --help` - View available commands
4. The Claude Dev extension is pre-installed for additional AI coding assistance

## Pre-installed Extensions

- **Home Assistant Extension**: Syntax highlighting and validation for Home Assistant configs
- **YAML Support**: Enhanced YAML editing capabilities
- **Material Design Icons**: Intellisense for MDI icons
- **Claude Dev**: AI-powered coding assistant
- **Python Support**: Full Python development environment
- **Prettier**: Code formatting
- **ESLint**: JavaScript/TypeScript linting
- **Error Lens**: Inline error highlighting

## Mapped Directories

The following directories are mapped into the VSCode environment:

- `/config` - Your Home Assistant configuration (read/write)
- `/addons` - Add-ons directory (read/write)
- `/backup` - Backup directory (read-only)
- `/share` - Share directory (read/write)
- `/ssl` - SSL directory (read-only)
- `/media` - Media directory (read/write)
- `/data` - Persistent addon data including Claude Code CLI configuration (read/write)

## Support

For issues and feature requests, please use the [GitHub repository][github].

## License

MIT License - see [LICENSE][license] for details.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[github]: https://github.com/ddcash/n1k0-addons/tree/main/vcode-ai
[license]: https://github.com/ddcash/n1k0-addons/blob/main/LICENSE