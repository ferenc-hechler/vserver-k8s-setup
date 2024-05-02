#!/bin/bash

set -xev
cd $(dirname -- $0)


kubectl apply -f 08-minio/backup/minio-backup-secret-encrypted.yaml
kubectl apply -f 08-minio/backup/minio-backup-cronjob.yaml



