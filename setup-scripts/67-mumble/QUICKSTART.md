# Mumble Quick Start Guide

## What is Mumble?

Mumble is a voice chat application and hosting server

## Quick Deployment

### 1. Prerequisites Check

Ensure your Kubernetes cluster has:
- ✓ openebs-hostpath storage class

### 2. Generate Admin Token

```bash
cd setup-scripts/67-mumble
./generate-admin-token.sh
```

Save the generated token securely!

### 3. Update Configuration

Edit `67-mumble/values.yaml`:
- Set `domain` to your actual domain
- Set `adminToken.value` with the token from step 2

Edit `67-mumble/mumble-ingress.yaml`:
- Update `host` entries with your domain

### 4. Deploy

```bash
cd setup-scripts
./67-mumble.sh
```

### 5. Verify

```bash
kubectl get pods -n mumble
# kubectl get ingress -n mumble
```

<!-- Wait for TLS certificate to be issued (~2 minutes). -->

### 6. Access

Use the mumble client to add a new server (use `your-domain.example` as address).

## Post-Deployment Configuration

## Backup and Restore

### Automated Backup (Recommended)

Setup daily automated backups:

```bash
kubectl apply -f 67-mumble/mumble-backup-pvc.yaml
kubectl apply -f 67-mumble/mumble-backup-cronjob.yaml
```

Backups run daily at 2 AM and keep the last 7 days.

### Manual Backup

```bash
cd setup-scripts/67-mumble
./backup-manual.sh
```

Backups are saved to `./backups/` directory.

### Restore

```bash
cd setup-scripts/67-mumble
./restore.sh backups/mumble-backup-YYYYMMDD-HHMMSS.tar.gz
```

## Using Mumble

### Super user Password

TODO

### Mobile App

1. Install Mumla — Mumble VoIP app from Play Store

### Desktop App

1. Download Mumble (at `https://www.mumble.info/downloads/`) desktop app

## Common Commands

### Check Status
```bash
kubectl get all -n mumble
kubectl logs -n mumble -l app.kubernetes.io/name=mumble -f
```

### Restart
```bash
kubectl rollout restart deployment -n mumble mumble
```

### Update
```bash
# Edit values.yaml and change image tag
helm upgrade mumble -n mumble --values 67-mumble/values.yaml kierranm/mumble
```

### Uninstall
```bash
helm uninstall mumble -n mumble
kubectl delete namespace mumble
# WARNING: This deletes all data!
```

## Security Best Practices

1. ✓ Disable signups after creating accounts
2. ✓ Set up automated backups
3. ✓ Enable 2FA for all accounts
4. ✓ Keep Mumble updated
5. ✓ Use strong master passwords
6. ✓ Regularly review admin panel for unauthorized access

## Troubleshooting

### Admin panel not working
- Verify admin token is set correctly
- Check pod logs for authentication errors

### Database locked errors
- Only one pod should run (default)
- Check if backup job is running: `kubectl get jobs -n mumble`

## File Structure

```
setup-scripts/
├── 67-mumble.sh                      # Main installation script
└── 67-mumble/
    ├── README.md                     # Detailed documentation
    ├── QUICKSTART.md                 # This file
    ├── values.yaml                   # Helm values configuration
    ├── mumble-ingress.yaml           # Ingress with TLS
    ├── mumble-backup-pvc.yaml        # Backup storage
    ├── mumble-backup-cronjob.yaml    # Automated backup job
    ├── generate-admin-token.sh       # Token generator
    ├── backup-manual.sh              # Manual backup script
    └── restore.sh                    # Restore script
```

## Resources

- Mumble Website: https://www.mumble.info/
- Mumble github: https://github.com/mumble-voip/mumble/
- Docker: https://github.com/mumble-voip/mumble-docker

## Support

For issues, check:
1. Pod logs: `kubectl logs -n mumble -l app.kubernetes.io/name=mumble`
2. Full README.md in this directory
