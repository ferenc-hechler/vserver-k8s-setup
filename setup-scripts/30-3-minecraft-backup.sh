#!/bin/bash

set -xev
cd $(dirname -- $0)


kubectl apply -f 30-minecraft/backup/minecraft-backup-pvc.yaml
kubectl apply -f 30-minecraft/backup/minecraft-backup-secret-encrypted.yaml
kubectl apply -f 30-minecraft/backup/minecraft-backup-cronjob.yaml



