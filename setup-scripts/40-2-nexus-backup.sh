#!/bin/bash

set -xev
cd $(dirname -- $0)


kubectl apply -f 40-nexus/backup/nexus-backup-pvc.yaml
kubectl apply -f 40-nexus/backup/nexus-backup-secret-encrypted.yaml
kubectl apply -f 40-nexus/backup/nexus-backup-cronjob.yaml



