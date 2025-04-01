#!/bin/bash

set -xev
cd $(dirname -- $0)


kubectl apply -f 40-nexus/restore/nexus-restore-secret-encrypted.yaml
kubectl apply -f 40-nexus/restore/nexus-restore-job.yaml

echo # scale down nexus
echo kubectl scale deployment -n nexus nexus --replicas=0
echo # delete all data from volume
echo # connect to the restore pod
echo kubectl exec -it -n nexus nexus-restore-job-XXXXXXXXX -- /bin/sh
echo export PGPCB_DELETE_LOCAL=
echo pgp-cloud-restore.sh -F YYYY-MM-DD  # gewuenschtes restore-datum
echo # remove old data
echo rm -rf /nexus-data/*
echo # extract backup
echo cd /nexus-data
echo tar xzf /restore/nexus-data-YYYY-MM-DD.tgz
echo # leave pod and scale up nexus
echo kubectl scale deployment -n nexus nexus --replicas=1


