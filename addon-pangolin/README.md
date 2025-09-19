# Pangolin Reverse Proxy Home Assistant Addon

This addon provides a tunneled reverse proxy server with identity and access management capabilities for Home Assistant, based on the [Pangolin](https://github.com/fosrl/pangolin) project.

## Features

- **Home Assistant Integration**: Access Pangolin directly from within Home Assistant using ingress
- **Authentik SSO Integration**: Built-in support for Authentik identity provider with OAuth2/OIDC
- **Tunneled Reverse Proxy**: Securely expose your Home Assistant and other services without opening firewall ports
- **Identity and Access Management**: Centralized authentication with support for SSO, 2FA, and role-based access control
- **WireGuard Integration**: Uses WireGuard for secure tunneling
- **SSL Certificates**: Automated SSL certificate management via Let's Encrypt
- **Load Balancing**: Built-in load balancing capabilities
- **Web Interface**: Modern dashboard for managing your tunnels and access control

## Configuration

### Options

| Option | Default | Description |
|--------|---------|-------------|
| `port` | `3000` | Port for the Pangolin web interface |
| `database` | `sqlite` | Database type (sqlite or pg) |
| `log_level` | `info` | Log level (trace, debug, info, warn, error, fatal) |
| `admin_email` | `""` | Initial admin email (optional) |
| `admin_password` | `""` | Initial admin password (optional) |
| `authentik_enabled` | `false` | Enable Authentik SSO integration |
| `authentik_url` | `""` | Authentik instance URL (e.g., https://authentik.company) |
| `authentik_client_id` | `""` | OAuth2 Client ID from Authentik |
| `authentik_client_secret` | `""` | OAuth2 Client Secret from Authentik |
| `authentik_auto_provision` | `true` | Auto-create user accounts on first login |

### Basic Configuration

```yaml
port: 3000
database: sqlite
log_level: info
admin_email: admin@example.com
admin_password: your-secure-password
```

### Configuration with Authentik SSO

```yaml
port: 3000
database: sqlite
log_level: info
authentik_enabled: true
authentik_url: "https://authentik.yourdomain.com"
authentik_client_id: "your-client-id"
authentik_client_secret: "your-client-secret"
authentik_auto_provision: true
```

## Usage

1. **Install the addon** from the Home Assistant addon store
2. **Configure** the addon using the options above
3. **Start** the addon
4. **Access** the web interface:
   - **Via Ingress**: Click on "Pangolin" in the Home Assistant sidebar (recommended)
   - **Direct Access**: Navigate to `http://homeassistant.local:PORT` (using your configured port)
5. **Complete setup** by creating your admin account (if not pre-configured)
6. **Configure tunnels** through the web interface

### Accessing the Interface

The addon supports Home Assistant's ingress feature, which means you can access Pangolin directly from within the Home Assistant interface. Once installed and started, you'll see a "Pangolin" option in your Home Assistant sidebar that provides seamless access to the web interface without needing to remember ports or URLs.

## Authentik SSO Setup

To integrate with Authentik for single sign-on:

### In Authentik:
1. **Create OAuth2/OIDC Provider**:
   - Go to Applications → Providers → Create
   - Select "OAuth2/OpenID Connect"
   - Set a descriptive name (e.g., "Pangolin")
   - Set Authorization flow to "default-authorization-flow"
   - Set Client type to "Confidential"
   - Note the generated Client ID and Client Secret
   - Set Redirect URIs temporarily to `https://temp.temp`

2. **Create Application**:
   - Go to Applications → Applications → Create
   - Set name (e.g., "Pangolin")
   - Select the provider created above
   - Set slug (e.g., "pangolin")

### In Pangolin (after addon is running):
1. **Access Pangolin** via the Home Assistant sidebar
2. **Login** with your admin credentials (if configured) or complete initial setup
3. **Go to Settings** → Identity Providers
4. **Add Provider** with:
   - Name: `authentik`
   - Client ID: From Authentik provider
   - Client Secret: From Authentik provider
   - Authorization URL: `https://your-authentik-domain/application/o/authorize/`
   - Token URL: `https://your-authentik-domain/application/o/token/`
   - Enable "Auto Provision Users" if desired

### Back in Authentik:
1. **Update Redirect URI** in the provider to the callback URL shown in Pangolin
   - Format: `https://your-pangolin-domain/auth/idp/{provider-id}/oidc/callback`
2. **Save** the provider configuration

**Note**: If you configure Authentik options in the addon configuration, the provider will be automatically configured on startup.

## Data Persistence

The addon stores its data in `/data` which is automatically mapped to a persistent volume. This includes:
- SQLite database (if using SQLite)
- Configuration files
- SSL certificates
- Log files

## Security Considerations

- Change default passwords immediately after setup
- Use strong passwords for admin accounts
- Configure proper firewall rules if needed
- Regularly update the addon to get security patches

## Support

For issues specific to this Home Assistant addon, please visit:
https://github.com/ddcash/n1k0-addons/issues

For general Pangolin support and documentation:
- Project: https://github.com/fosrl/pangolin
- Documentation: https://docs.digpangolin.com

## License

This addon is based on Pangolin, which is dual-licensed under AGPL-3 and a commercial license.
See the [Pangolin repository](https://github.com/fosrl/pangolin) for details.