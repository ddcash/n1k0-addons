# Example Home Assistant Add-on

A simple example add-on template for Home Assistant development.

## About

This add-on serves as a basic template demonstrating how to create a Home Assistant add-on with:
- Configuration options
- Web interface via ingress
- Simple Python application
- Proper file structure

## Installation

1. Add this repository to Home Assistant
2. Install the "Example Add-on Template"
3. Configure the add-on options
4. Start the add-on
5. Click "OPEN WEB UI" to see the web interface

## Configuration

```yaml
message: "Hello World"
log_level: info
```

### Option: `message`
The message to display in the web interface.

### Option: `log_level`
The logging level for the add-on.

## Usage

After starting the add-on, use the "OPEN WEB UI" button to access the simple web interface that displays your configured message.

## Development

This add-on is meant as a template for developing your own add-ons. Key files:

- `config.yaml` - Add-on configuration and schema
- `Dockerfile` - Container build instructions
- `rootfs/etc/services.d/example/run` - Main application startup script

## Support

This is an example add-on for development purposes.