#!/bin/bash

set -xev
cd $(dirname -- $0)


kubectl apply -f 66-opencloud/backup/opencloud-backup-pvc.yaml
kubectl apply -f 66-opencloud/backup/opencloud-backup-secret-encrypted.yaml
kubectl apply -f 66-opencloud/backup/opencloud-backup-cronjob.yaml



