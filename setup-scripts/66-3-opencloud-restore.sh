#!/bin/bash

set -xev
cd $(dirname -- $0)


kubectl apply -f 40-opencloud/restore/opencloud-restore-secret-encrypted.yaml
kubectl apply -f 40-opencloud/restore/opencloud-restore-job.yaml

echo # scale down opencloud
echo kubectl scale deployment -n opencloud opencloud --replicas=0
echo # delete all data from volume
echo # connect to the restore pod
echo kubectl exec -it -n opencloud opencloud-restore-job-XXXXXXXXX -- /bin/sh
echo export PGPCB_DELETE_LOCAL=
echo pgp-cloud-restore.sh -F YYYY-MM-DD  # gewuenschtes restore-datum
echo # remove old data
echo rm -rf /opencloud-data/*
echo rm -rf /opencloud-config/*
echo # extract backup
echo cd /opencloud-data
echo tar xzf /restore/opencloud-data-YYYY-MM-DD.tgz
echo cd /opencloud-config
echo tar xzf /restore/opencloud-config-YYYY-MM-DD.tgz
echo # leave pod and scale up opencloud
echo kubectl scale deployment -n opencloud opencloud --replicas=1


