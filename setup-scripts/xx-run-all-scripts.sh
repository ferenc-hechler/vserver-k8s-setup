#!/bin/bash

set -xev
cd $(dirname -- $0)

./03-setup-k8s.sh
./04-1-ingress-nginx.sh
./04-2-route-default-ports.sh
./05-cert-manager.sh
./06-prometheus-grafana.sh
./07-dashboard.sh
./08-1-minio.sh
# ./08-2-minio-backup.sh
# ./08-3-minio-restore.sh
./30-1-minecraft.sh
./30-2-route-minecraft-port.sh
# ./30-3-minecraft-backup.sh
# ./30-4-minecraft-restore.sh
./40-1-nexus.sh
# ./40-2-nexus-backup.sh
# ./40-3-nexus-restore.sh
