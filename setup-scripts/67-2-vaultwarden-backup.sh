#!/bin/bash

set -xev
cd $(dirname -- $0)


kubectl apply -f 67-vaultwarden/backup/vaultwarden-backup-pvc.yaml
kubectl apply -f 67-vaultwarden/backup/vaultwarden-backup-secret-encrypted.yaml
kubectl apply -f 67-vaultwarden/backup/vaultwarden-backup-cronjob.yaml



