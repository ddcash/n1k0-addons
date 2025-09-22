# Home Assistant Add-on: VSCode with Claude Code AI

This add-on provides a browser-based Visual Studio Code experience with integrated Claude Code CLI for AI-powered development within your Home Assistant environment.

## Installation

Follow these steps to install the VSCode with Claude Code AI add-on:

1. Navigate to the Supervisor panel in your Home Assistant frontend
2. Click on the "Add-on Store" tab
3. Add this repository by clicking the menu (three dots) and selecting "Repositories"
4. Enter: `https://github.com/ddcash/n1k0-addons`
5. Find "VSCode with Claude Code AI" and click "Install"
6. Optionally, configure the add-on (see Configuration section)
7. Click "Start"

## Configuration

### Basic Configuration

The add-on can be used without any configuration, but you may want to customize certain aspects:

```yaml
packages:
  - git
  - nano
init_commands:
  - pip install homeassistant
config_path: ""
log_level: info
```

### Advanced Configuration

#### Installing Additional Packages

You can install additional Alpine Linux packages by adding them to the `packages` configuration:

```yaml
packages:
  - git
  - nano
  - htop
  - curl
```

#### Initialization Commands

Run custom commands when the add-on starts:

```yaml
init_commands:
  - pip install custom-package
  - npm install -g some-tool
  - echo "Add-on started" >> /config/startup.log
```

#### Custom Configuration Path

By default, VSCode configuration is stored in `/data/vscode`. You can customize this:

```yaml
config_path: "/config/my-vscode-config"
```

## Claude Code CLI Setup

### Getting an API Key

1. Visit [Anthropic Console](https://console.anthropic.com/)
2. Create an account or sign in
3. Navigate to API Keys section
4. Create a new API key
5. Copy the key for the next step

### Configuring the API Key

Create a file containing your Anthropic API key:

1. Using the File Editor add-on or any text editor, create a file at `/config/claude_api_key`
2. Paste your API key into this file (the file should contain only the API key)
3. Restart the VSCode add-on

The add-on will automatically detect this file and configure Claude Code CLI.

### Alternative API Key Configuration

You can also set the API key through the terminal within VSCode:

```bash
export ANTHROPIC_API_KEY="your-api-key-here"
```

Note: This method requires setting the key each time you start a new terminal session.

## Usage

### Accessing VSCode

1. Start the add-on
2. Click "OPEN WEB UI" button
3. VSCode will open in your browser

### Using Claude Code CLI

Once configured with an API key, you can use Claude Code CLI:

```bash
# Start an interactive session
claude-code

# Get help
claude-code --help

# Run a specific command
claude-code "Help me write a Python script to parse YAML"
```

### File Access

The following directories are automatically available in VSCode:

- `/config` - Your Home Assistant configuration directory
- `/addons` - Add-ons development directory
- `/share` - Shared files directory
- `/media` - Media files directory
- `/backup` - Backups (read-only)
- `/ssl` - SSL certificates (read-only)

### Development Workflow

1. **Home Assistant Configuration**: Edit your `configuration.yaml` and other config files
2. **Add-on Development**: Create and modify custom add-ons in the `/addons` directory
3. **Scripts and Automations**: Write Python scripts and automation scripts
4. **AI Assistance**: Use Claude Code CLI for code generation, debugging, and optimization

## Pre-installed Extensions

The add-on comes with extensions optimized for Home Assistant development:

- **Home Assistant Config Helper**: Syntax highlighting and validation
- **YAML**: Enhanced YAML editing with validation
- **Material Design Icons**: Intellisense for MDI icons
- **Claude Dev**: Additional AI coding assistance through the extension
- **Python**: Full Python development support
- **Prettier**: Code formatting for multiple languages
- **ESLint**: JavaScript/TypeScript linting
- **Error Lens**: Inline error display
- **Auto Rename Tag**: Automatic HTML tag renaming
- **Path Intellisense**: Autocomplete for file paths

## Terminal Usage

The integrated terminal provides full shell access with:

- **Claude Code CLI**: Available globally as `claude-code`
- **Python**: Python 3.12 with pip
- **Node.js**: Node.js 20.x with npm
- **Git**: Version control
- **Standard Linux tools**: curl, wget, nano, etc.

## Troubleshooting

### Add-on Won't Start

1. Check the add-on logs for error messages
2. Verify your configuration syntax
3. Ensure sufficient system resources are available

### Claude Code CLI Not Working

1. Verify your API key is correctly saved in `/config/claude_api_key`
2. Check that the file contains only the API key (no extra characters)
3. Restart the add-on after adding the API key
4. Check add-on logs for any API-related errors

### Performance Issues

1. Increase system resources if possible
2. Close unused browser tabs
3. Reduce the number of open files in VSCode
4. Consider using a more powerful device for development

### Extensions Not Loading

1. Restart the add-on
2. Check add-on logs for extension installation errors
3. Clear browser cache and reload VSCode

## Security Considerations

- **API Key Security**: Keep your Claude API key secure and never share it
- **File Access**: The add-on has read/write access to your Home Assistant configuration
- **Network Access**: The add-on requires internet access for Claude Code CLI functionality
- **Authentication**: Access is controlled through Home Assistant's authentication system

## Backup Recommendations

- **Configuration**: Regularly backup your `/config` directory
- **VSCode Settings**: Your VSCode configuration is stored in `/data/vscode`
- **API Keys**: Keep a secure backup of your API keys

## Updates

The add-on will notify you when updates are available. Always review the changelog before updating to understand what changes are included.

## Support

For support and issues:

1. Check the [GitHub Issues](https://github.com/ddcash/n1k0-addons/issues)
2. Review the add-on logs for error messages
3. Consult the Home Assistant Community Forum
4. Submit detailed bug reports with logs and configuration details