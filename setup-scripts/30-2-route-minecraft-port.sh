#!/bin/bash

set -xev
cd $(dirname -- $0)

#CLUSTER_IP=$(kubectl get service minecraft-service -n minecraft -o  go-template='{{ .spec.clusterIP }}')
#CLUSTER_PORT=$(kubectl get service minecraft-service -n minecraft -o  go-template='{{ (index .spec.ports 0).port}}')
#sudo nohup socat TCP-LISTEN:61267,fork TCP:$CLUSTER_IP:$CLUSTER_PORT  >/dev/null 2>&1 &

export MINECRAFT_SVC_NODEPORT=$(kubectl get service minecraft-service -n minecraft -o  go-template='{{ (index .spec.ports 0).nodePort}}')
export PUBLIC_IP=$(curl ident.me)
sudo nohup socat TCP-LISTEN:61267,fork TCP:$PUBLIC_IP:$MINECRAFT_SVC_NODEPORT  >/dev/null 2>&1 &