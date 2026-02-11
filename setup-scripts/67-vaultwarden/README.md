# Vaultwarden Deployment Guide

## Overview

Vaultwarden (formerly Bitwarden_RS) is an unofficial Bitwarden server implementation written in Rust. It's compatible with official Bitwarden clients and provides a lightweight, self-hosted password management solution.

## Prerequisites

- Kubernetes cluster with kubectl configured
- Helm 3 installed
- cert-manager installed and configured with Let's Encrypt
- nginx ingress controller installed
- Storage class `openebs-hostpath` available

## Installation Steps

### 1. Generate Admin Token

Before deploying, generate a secure admin token:

```bash
openssl rand -base64 48
```

Edit `67-vaultwarden/values.yaml` and set the `adminToken.value` with the generated token.

### 2. Configure Domain

Update the domain in both files:
- `67-vaultwarden/values.yaml` - Set `domain` parameter
- `67-vaultwarden/vaultwarden-ingress.yaml` - Set `host` in rules and TLS sections

Default domain: `vaultwarden.k8s.cluster-4.de`

### 3. Deploy Vaultwarden

Run the installation script:

```bash
cd setup-scripts
./67-vaultwarden.sh
```

Or manually:

```bash
helm repo add gissilabs https://gissilabs.github.io/charts/
helm repo update

helm upgrade --install vaultwarden \
  -n vaultwarden \
  --create-namespace \
  --values 67-vaultwarden/values.yaml \
  gissilabs/vaultwarden

kubectl apply -f 67-vaultwarden/vaultwarden-ingress.yaml
```

### 4. Verify Deployment

Check if pods are running:

```bash
kubectl get pods -n vaultwarden
kubectl get ingress -n vaultwarden
kubectl get pvc -n vaultwarden
```

Check logs:

```bash
kubectl logs -n vaultwarden -l app.kubernetes.io/name=vaultwarden -f
```

### 5. Access Vaultwarden

- Web Vault: `https://vaultwarden.k8s.cluster-4.de`
- Admin Panel: `https://vaultwarden.k8s.cluster-4.de/admin`

Use the admin token from step 1 to access the admin panel.

## Configuration

### Database

Vaultwarden uses SQLite by default. The database file is stored at `/data/db.sqlite3` within the persistent volume.

Benefits of SQLite:
- Simple setup, no external database required
- Sufficient for most use cases (< 100 users)
- Easy to backup (single file)

### Signups

By default, signups are enabled. After creating your accounts:

1. Edit `values.yaml` and set `config.signupsAllowed: false`
2. Upgrade the deployment:
   ```bash
   helm upgrade vaultwarden -n vaultwarden --values 67-vaultwarden/values.yaml gissilabs/vaultwarden
   ```

Alternatively, disable signups via the admin panel.

### SMTP Configuration

To enable email notifications and email verification:

1. Edit `values.yaml` and uncomment the SMTP section
2. Fill in your SMTP server details
3. Upgrade the deployment

### Resource Limits

Default resources:
- Requests: 100m CPU, 256Mi memory
- Limits: 500m CPU, 512Mi memory

Adjust in `values.yaml` based on your usage.

## Backup and Restore

### Option 1: Velero (Recommended)

The deployment includes Velero annotations for automatic backup of the data volume:

```yaml
podAnnotations:
  backup.velero.io/backup-volumes: data
```

### Option 2: Manual Backup with CronJob

1. Create backup PVC:
   ```bash
   kubectl apply -f 67-vaultwarden/vaultwarden-backup-pvc.yaml
   ```

2. Deploy backup CronJob (runs daily at 2 AM):
   ```bash
   kubectl apply -f 67-vaultwarden/vaultwarden-backup-cronjob.yaml
   ```

3. Manual backup trigger:
   ```bash
   kubectl create job -n vaultwarden --from=cronjob/vaultwarden-backup vaultwarden-backup-manual
   ```

4. List backups:
   ```bash
   kubectl exec -n vaultwarden -it deployment/vaultwarden -- ls -lh /backup/
   ```

### Restore from Backup

1. Scale down deployment:
   ```bash
   kubectl scale deployment -n vaultwarden vaultwarden --replicas=0
   ```

2. Restore database:
   ```bash
   # Copy backup to pod
   kubectl cp vaultwarden-backup.tar.gz vaultwarden/vaultwarden-pod:/tmp/
   
   # Extract and restore
   kubectl exec -n vaultwarden vaultwarden-pod -- sh -c "
     cd /tmp && \
     tar -xzf vaultwarden-backup.tar.gz && \
     cp -r vaultwarden-*/* /data/
   "
   ```

3. Scale up deployment:
   ```bash
   kubectl scale deployment -n vaultwarden vaultwarden --replicas=1
   ```

## Monitoring

### Check Service Health

```bash
# Check if service responds
kubectl exec -n vaultwarden deployment/vaultwarden -- wget -O- http://localhost/alive
```

### View Logs

```bash
kubectl logs -n vaultwarden -l app.kubernetes.io/name=vaultwarden -f
```

### Database Size

```bash
kubectl exec -n vaultwarden deployment/vaultwarden -- du -sh /data/
```

## Troubleshooting

### Pod not starting

Check events:
```bash
kubectl describe pod -n vaultwarden -l app.kubernetes.io/name=vaultwarden
```

Check logs:
```bash
kubectl logs -n vaultwarden -l app.kubernetes.io/name=vaultwarden
```

### Cannot access admin panel

Verify admin token is set:
```bash
kubectl get deployment -n vaultwarden vaultwarden -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="ADMIN_TOKEN")].value}'
```

### TLS certificate issues

Check cert-manager:
```bash
kubectl get certificate -n vaultwarden
kubectl describe certificate -n vaultwarden vaultwarden-tls
```

### WebSocket not working

Ensure ingress annotations are correct:
```bash
kubectl get ingress -n vaultwarden vaultwarden-ingress -o yaml | grep websocket
```

## Updating Vaultwarden

1. Update image tag in `values.yaml`
2. Run upgrade:
   ```bash
   helm upgrade vaultwarden -n vaultwarden --values 67-vaultwarden/values.yaml gissilabs/vaultwarden
   ```

## Uninstallation

```bash
helm uninstall vaultwarden -n vaultwarden
kubectl delete namespace vaultwarden
```

Note: This will delete all data. Backup first if needed!

## Security Considerations

1. **Admin Token**: Keep it secure, never commit to git
2. **Disable Signups**: After creating accounts
3. **HTTPS Only**: Ensure TLS is working before use
4. **Regular Backups**: Set up automated backups
5. **Updates**: Keep Vaultwarden updated for security patches
6. **Network Policies**: Consider adding network policies to restrict access

## Official Documentation

- Vaultwarden Wiki: https://github.com/dani-garcia/vaultwarden/wiki
- Bitwarden Help: https://bitwarden.com/help/
- Helm Chart: https://github.com/gissilabs/charts/tree/master/vaultwarden

## Support

For issues specific to:
- Vaultwarden: https://github.com/dani-garcia/vaultwarden/discussions
- Helm Chart: https://github.com/gissilabs/charts/issues
- Bitwarden Clients: https://community.bitwarden.com/
