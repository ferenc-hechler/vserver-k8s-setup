#!/bin/bash

set -xev
cd $(dirname -- $0)


kubectl apply -f 40-nexus/restore/nexus-restore-secret-encrypted.yaml
kubectl apply -f 40-nexus/restore/nexus-restore-job.yaml



