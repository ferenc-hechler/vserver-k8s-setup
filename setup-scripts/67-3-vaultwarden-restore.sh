#!/bin/bash

set -xev
cd $(dirname -- $0)


kubectl apply -f 67-vaultwarden/restore/vaultwarden-restore-secret-encrypted.yaml
kubectl apply -f 67-vaultwarden/restore/vaultwarden-restore-job.yaml

echo # scale down vaultwarden
echo kubectl scale deployment -n vaultwarden vaultwarden --replicas=0
echo # delete all data from volume
echo # connect to the restore pod
echo kubectl exec -it -n vaultwarden vaultwarden-restore-job-XXXXXXXXX -- /bin/sh
echo export PGPCB_DELETE_LOCAL=
echo pgp-cloud-restore.sh -F YYYY-MM-DD  # gewuenschtes restore-datum
echo # remove old data
echo rm -rf /vaultwarden-data/*
echo # extract backup
echo cd /vaultwarden-data
echo tar xzf /restore/vaultwarden-data-YYYY-MM-DD.tgz
echo # leave pod and scale up vaultwarden
echo kubectl scale deployment -n vaultwarden vaultwarden --replicas=1


