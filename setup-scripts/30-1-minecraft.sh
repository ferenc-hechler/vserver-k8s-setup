#!/bin/bash

# from: https://github.com/itzg/docker-minecraft-server

set -xev
cd $(dirname -- $0)

kubectl create namespace minecraft || true

kubectl apply -f 30-minecraft/minecraft-service.yaml
kubectl apply -f 30-minecraft/minecraft-pvc.yaml
kubectl apply -f 30-minecraft/minecraft-config-cm.yaml
kubectl apply -f 30-minecraft/minecraft-deployment.yaml


