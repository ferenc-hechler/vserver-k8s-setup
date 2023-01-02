#!/bin/bash

set -xev
cd $(dirname -- $0)


kubectl apply -f 30-minecraft/restore/minecraft-restore-secret-encrypted.yaml
kubectl apply -f 30-minecraft/restore/minecraft-restore-job.yaml



