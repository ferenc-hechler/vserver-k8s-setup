# Vaultwarden Quick Start Guide

## What is Vaultwarden?

Vaultwarden is a lightweight, self-hosted Bitwarden server implementation written in Rust. It's fully compatible with official Bitwarden clients (browser extensions, mobile apps, desktop apps) and provides:

- Password management
- Secure notes
- Credit card storage
- Identity information
- File attachments
- Two-factor authentication (2FA)
- Password generator
- Organization/team password sharing

## Quick Deployment

### 1. Prerequisites Check

Ensure your Kubernetes cluster has:
- ✓ nginx ingress controller
- ✓ cert-manager with Let's Encrypt
- ✓ openebs-hostpath storage class

### 2. Generate Admin Token

```bash
cd setup-scripts/66-vaultwarden
./generate-admin-token.sh
```

Save the generated token securely!

### 3. Update Configuration

Edit `66-vaultwarden/values.yaml`:
- Set `domain` to your actual domain
- Set `adminToken.value` with the token from step 2

Edit `66-vaultwarden/vaultwarden-ingress.yaml`:
- Update `host` entries with your domain

### 4. Deploy

```bash
cd setup-scripts
./66-vaultwarden.sh
```

### 5. Verify

```bash
kubectl get pods -n vaultwarden
kubectl get ingress -n vaultwarden
```

Wait for TLS certificate to be issued (~2 minutes).

### 6. Access

- Web Vault: `https://your-domain.com`
- Admin Panel: `https://your-domain.com/admin` (use token from step 2)

## Post-Deployment Configuration

### Disable Signups (Recommended)

After creating your accounts:

1. Via Admin Panel:
   - Go to `https://your-domain.com/admin`
   - Navigate to "General settings"
   - Disable "Allow new signups"

2. Or via values.yaml:
   - Set `config.signupsAllowed: false`
   - Run: `helm upgrade vaultwarden -n vaultwarden --values 66-vaultwarden/values.yaml gissilabs/vaultwarden`

### Configure Email (Optional)

Edit `values.yaml` and uncomment the SMTP section:

```yaml
smtp:
  host: "smtp.gmail.com"
  from: "vaultwarden@yourdomain.com"
  port: 587
  security: starttls
  username: "your-email@gmail.com"
  password: "your-app-password"
```

Then upgrade the deployment.

## Backup and Restore

### Automated Backup (Recommended)

Setup daily automated backups:

```bash
kubectl apply -f 66-vaultwarden/vaultwarden-backup-pvc.yaml
kubectl apply -f 66-vaultwarden/vaultwarden-backup-cronjob.yaml
```

Backups run daily at 2 AM and keep the last 7 days.

### Manual Backup

```bash
cd setup-scripts/66-vaultwarden
./backup-manual.sh
```

Backups are saved to `./backups/` directory.

### Restore

```bash
cd setup-scripts/66-vaultwarden
./restore.sh backups/vaultwarden-backup-YYYYMMDD-HHMMSS.tar.gz
```

## Using Vaultwarden

### Browser Extension

1. Install Bitwarden browser extension
2. Click settings (gear icon)
3. Set "Server URL" to your domain: `https://your-domain.com`
4. Create account or login

### Mobile App

1. Install Bitwarden app from app store
2. Tap settings before logging in
3. Set "Server URL" to your domain
4. Login with your credentials

### Desktop App

1. Download Bitwarden desktop app
2. Open settings
3. Set "Server URL" to your domain
4. Login with your credentials

## Common Commands

### Check Status
```bash
kubectl get all -n vaultwarden
kubectl logs -n vaultwarden -l app.kubernetes.io/name=vaultwarden -f
```

### Restart
```bash
kubectl rollout restart deployment -n vaultwarden vaultwarden
```

### Update
```bash
# Edit values.yaml and change image tag
helm upgrade vaultwarden -n vaultwarden --values 66-vaultwarden/values.yaml gissilabs/vaultwarden
```

### Uninstall
```bash
helm uninstall vaultwarden -n vaultwarden
kubectl delete namespace vaultwarden
# WARNING: This deletes all data!
```

## Security Best Practices

1. ✓ Use strong admin token (generated with openssl)
2. ✓ Disable signups after creating accounts
3. ✓ Enable HTTPS only (enforced by ingress)
4. ✓ Set up automated backups
5. ✓ Enable 2FA for all accounts
6. ✓ Keep Vaultwarden updated
7. ✓ Use strong master passwords
8. ✓ Regularly review admin panel for unauthorized access

## Troubleshooting

### Cannot access web interface
- Check ingress: `kubectl describe ingress -n vaultwarden`
- Check TLS certificate: `kubectl get certificate -n vaultwarden`
- Check DNS resolves to your server

### Admin panel not working
- Verify admin token is set correctly
- Check pod logs for authentication errors

### Clients cannot sync
- Check WebSocket is enabled (default)
- Verify ingress WebSocket annotations
- Check firewall allows HTTPS traffic

### Database locked errors
- Only one pod should run (default)
- Check if backup job is running: `kubectl get jobs -n vaultwarden`

## File Structure

```
setup-scripts/
├── 66-vaultwarden.sh                      # Main installation script
└── 66-vaultwarden/
    ├── README.md                          # Detailed documentation
    ├── QUICKSTART.md                      # This file
    ├── values.yaml                        # Helm values configuration
    ├── vaultwarden-ingress.yaml           # Ingress with TLS
    ├── vaultwarden-backup-pvc.yaml        # Backup storage
    ├── vaultwarden-backup-cronjob.yaml    # Automated backup job
    ├── generate-admin-token.sh            # Token generator
    ├── backup-manual.sh                   # Manual backup script
    └── restore.sh                         # Restore script
```

## Resources

- Vaultwarden: https://github.com/dani-garcia/vaultwarden
- Vaultwarden Wiki: https://github.com/dani-garcia/vaultwarden/wiki
- Bitwarden Help: https://bitwarden.com/help/
- Helm Chart: https://github.com/gissilabs/charts/tree/master/vaultwarden

## Support

For issues, check:
1. Pod logs: `kubectl logs -n vaultwarden -l app.kubernetes.io/name=vaultwarden`
2. Vaultwarden discussions: https://github.com/dani-garcia/vaultwarden/discussions
3. Full README.md in this directory
