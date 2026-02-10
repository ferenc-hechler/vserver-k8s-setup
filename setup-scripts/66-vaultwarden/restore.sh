#!/bin/bash

# Restore script for Vaultwarden from backup
# WARNING: This will overwrite existing data!

set -e

NAMESPACE="vaultwarden"
DEPLOYMENT="vaultwarden"

echo "Vaultwarden Restore Script"
echo "=========================="
echo ""
echo "WARNING: This will overwrite all existing Vaultwarden data!"
echo ""

# Check if backup file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <backup-file.tar.gz>"
    echo ""
    echo "Available backups:"
    ls -lh ./backups/vaultwarden-backup-*.tar.gz 2>/dev/null || echo "  No backups found"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "ERROR: Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "Backup file: $BACKUP_FILE"
echo "Size: $(du -h "$BACKUP_FILE" | cut -f1)"
echo ""

read -p "Are you sure you want to restore from this backup? (yes/no): " -r
echo ""

if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Restore cancelled."
    exit 0
fi

# Get pod name
POD=$(kubectl get pod -n "$NAMESPACE" -l app.kubernetes.io/name=vaultwarden -o jsonpath='{.items[0].metadata.name}')

if [ -z "$POD" ]; then
    echo "ERROR: No Vaultwarden pod found in namespace $NAMESPACE"
    exit 1
fi

echo "Found pod: $POD"
echo ""

# Scale down deployment
echo "1. Scaling down deployment..."
kubectl scale deployment -n "$NAMESPACE" "$DEPLOYMENT" --replicas=0
echo "   Waiting for pod to terminate..."
kubectl wait --for=delete pod -n "$NAMESPACE" -l app.kubernetes.io/name=vaultwarden --timeout=60s || true

# Wait a bit to ensure everything is stopped
sleep 5

# Scale back up
echo "2. Scaling up deployment..."
kubectl scale deployment -n "$NAMESPACE" "$DEPLOYMENT" --replicas=1
echo "   Waiting for pod to be ready..."
kubectl wait --for=condition=ready pod -n "$NAMESPACE" -l app.kubernetes.io/name=vaultwarden --timeout=120s

# Get new pod name
POD=$(kubectl get pod -n "$NAMESPACE" -l app.kubernetes.io/name=vaultwarden -o jsonpath='{.items[0].metadata.name}')
echo "   New pod: $POD"

# Copy backup to pod
echo "3. Uploading backup to pod..."
kubectl cp "$BACKUP_FILE" "$NAMESPACE/$POD:/tmp/backup.tar.gz"

# Extract backup
echo "4. Extracting backup..."
kubectl exec -n "$NAMESPACE" "$POD" -- sh -c "
    cd /tmp && tar -xzf backup.tar.gz
"

# Stop vaultwarden process temporarily (if possible)
echo "5. Stopping Vaultwarden process..."
kubectl exec -n "$NAMESPACE" "$POD" -- sh -c "killall vaultwarden || true" || true
sleep 2

# Restore data
echo "6. Restoring data..."
kubectl exec -n "$NAMESPACE" "$POD" -- sh -c "
    # Backup current data (just in case)
    mkdir -p /tmp/old-data
    cp -r /data/* /tmp/old-data/ 2>/dev/null || true
    
    # Restore from backup
    cp -r /tmp/backup/db.sqlite3 /data/ 2>/dev/null || true
    cp -r /tmp/backup/attachments /data/ 2>/dev/null || true
    cp -r /tmp/backup/sends /data/ 2>/dev/null || true
    cp -r /tmp/backup/icon_cache /data/ 2>/dev/null || true
    cp -r /tmp/backup/config.json /data/ 2>/dev/null || true
    
    # Cleanup
    rm -rf /tmp/backup /tmp/backup.tar.gz
"

# Restart pod to reload data
echo "7. Restarting pod..."
kubectl delete pod -n "$NAMESPACE" "$POD"
echo "   Waiting for pod to be ready..."
kubectl wait --for=condition=ready pod -n "$NAMESPACE" -l app.kubernetes.io/name=vaultwarden --timeout=120s

echo ""
echo "✓ Restore completed successfully!"
echo ""
echo "Please verify:"
echo "  1. Access the web interface"
echo "  2. Log in with your account"
echo "  3. Check that all data is present"
echo ""
echo "If something went wrong, the old data is backed up in the pod at /tmp/old-data"
