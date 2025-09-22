# Home Assistant Add-on: VSCode with Claude Code AI

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]

Visual Studio Code with Claude Code CLI and Gemini CLI integration for AI-powered development in Home Assistant.

## About

This add-on provides a browser-based Visual Studio Code experience with integrated Claude Code CLI and Gemini CLI, giving you powerful AI-powered development assistance from multiple providers directly within your Home Assistant environment.

### Features

- **Full VSCode Experience**: Complete Visual Studio Code interface accessible through your browser
- **Dual AI CLI Support**: Both Claude Code CLI and Gemini CLI pre-installed for comprehensive AI assistance
- **Claude Dev Extension**: Pre-installed extension for inline AI assistance
- **Home Assistant Optimized**: Pre-configured with Home Assistant, YAML, and MDI extensions
- **Persistent Configuration**: Both Claude Code CLI and Gemini CLI settings persist across restarts
- **Secure Access**: Integrated with Home Assistant's authentication system
- **Multi-Architecture Support**: Works on both amd64 and aarch64 systems

## Installation

1. Navigate to Supervisor → Add-on Store in your Home Assistant instance
2. Add this repository: `https://github.com/ddcash/n1k0-addons`
3. Install the "VSCode with Claude Code AI" add-on
4. Configure your Claude API key (see documentation)
5. Start the add-on

## AI CLI Setup

### Claude Code CLI

To use Claude Code CLI features:

1. Obtain an Anthropic API key from https://console.anthropic.com/
2. Create a file containing your API key at one of these locations:
   - `/addon_configs/local_vscode-claude/claude_api_key` (recommended for persistence)
   - `/config/claude_api_key` (alternative location)
3. Restart the add-on
4. Use `claude-code` command in the integrated terminal

### Gemini CLI

To use Gemini CLI features:

1. Obtain a Google AI API key from https://aistudio.google.com/app/apikey
2. Create a file containing your API key at one of these locations:
   - `/addon_configs/local_vscode-claude/gemini_api_key` (recommended for persistence)
   - `/config/gemini_api_key` (alternative location)
3. Restart the add-on
4. Use `gemini` command in the integrated terminal

## Pre-installed Extensions

- **Home Assistant Config Helper**: Syntax highlighting and validation
- **YAML**: Enhanced YAML editing capabilities
- **Material Design Icons**: Intellisense for MDI icons
- **Claude Dev**: AI-powered coding assistant extension
- **Python**: Full Python development support
- **ESPHome**: ESPHome development support
- **Prettier**: Code formatting
- **Error Lens**: Inline error display

## Usage

1. After starting the add-on, click "OPEN WEB UI" to access VSCode
2. Your Home Assistant configuration directory is automatically accessible
3. Use the integrated terminal to run Claude Code CLI (`claude-code`) or Gemini CLI (`gemini`) commands
4. Use the Claude Dev extension for inline AI assistance
5. All AI CLI configurations persist automatically

## Persistent Data

The following data persists across addon restarts:
- VSCode configuration and settings
- Installed extensions
- Claude Code CLI configuration (`/addon_configs/local_vscode-claude/claude-code/`)
- Gemini CLI configuration (`/addon_configs/local_vscode-claude/gemini-cli/`)
- MCP server configurations
- Workspace settings

## Extension Warnings

You may see warnings like "This extension is enabled in the Local Extension Host because it prefers to run there." This is normal for code-server (browser-based VSCode). These warnings are informational only and don't affect functionality. The extensions work correctly despite these messages.

## Support

For issues and feature requests, please use the [GitHub repository][github].

## License

MIT License - see [LICENSE][license] for details.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[github]: https://github.com/ddcash/n1k0-addons/tree/main/vcode-ai
[license]: https://github.com/ddcash/n1k0-addons/blob/main/LICENSE