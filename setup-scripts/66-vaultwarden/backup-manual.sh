#!/bin/bash

# Backup script for Vaultwarden SQLite database
# Run manually to create an immediate backup

set -e

NAMESPACE="vaultwarden"
DEPLOYMENT="vaultwarden"
BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="vaultwarden-backup-${TIMESTAMP}.tar.gz"

echo "Vaultwarden Manual Backup Script"
echo "================================="
echo ""

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Get pod name
POD=$(kubectl get pod -n "$NAMESPACE" -l app.kubernetes.io/name=vaultwarden -o jsonpath='{.items[0].metadata.name}')

if [ -z "$POD" ]; then
    echo "ERROR: No Vaultwarden pod found in namespace $NAMESPACE"
    exit 1
fi

echo "Found pod: $POD"
echo "Creating backup..."

# Create temporary directory in pod
kubectl exec -n "$NAMESPACE" "$POD" -- mkdir -p /tmp/backup

# Copy database and data to temp directory
kubectl exec -n "$NAMESPACE" "$POD" -- sh -c "
    cp -r /data/db.sqlite3 /tmp/backup/ 2>/dev/null || true
    cp -r /data/attachments /tmp/backup/ 2>/dev/null || true
    cp -r /data/sends /tmp/backup/ 2>/dev/null || true
    cp -r /data/icon_cache /tmp/backup/ 2>/dev/null || true
    cp -r /data/config.json /tmp/backup/ 2>/dev/null || true
"

# Create tarball in pod
kubectl exec -n "$NAMESPACE" "$POD" -- sh -c "
    cd /tmp && tar -czf backup.tar.gz backup/
"

# Copy tarball to local machine
echo "Downloading backup..."
kubectl cp "$NAMESPACE/$POD:/tmp/backup.tar.gz" "$BACKUP_DIR/$BACKUP_FILE"

# Cleanup temp files in pod
kubectl exec -n "$NAMESPACE" "$POD" -- rm -rf /tmp/backup /tmp/backup.tar.gz

echo ""
echo "✓ Backup completed successfully!"
echo "Backup file: $BACKUP_DIR/$BACKUP_FILE"
echo "Size: $(du -h "$BACKUP_DIR/$BACKUP_FILE" | cut -f1)"
echo ""

# List all backups
echo "Available backups:"
ls -lh "$BACKUP_DIR"/vaultwarden-backup-*.tar.gz 2>/dev/null || echo "  No backups found"
echo ""

# Optional: Clean old backups (keep last 7)
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/vaultwarden-backup-*.tar.gz 2>/dev/null | wc -l)
if [ "$BACKUP_COUNT" -gt 7 ]; then
    echo "Cleaning old backups (keeping last 7)..."
    ls -t "$BACKUP_DIR"/vaultwarden-backup-*.tar.gz | tail -n +8 | xargs rm -f
    echo "✓ Cleanup completed"
fi
