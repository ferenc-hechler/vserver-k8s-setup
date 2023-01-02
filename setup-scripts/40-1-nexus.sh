#!/bin/bash

# from: https://hub.docker.com/r/sonatype/nexus3

set -xev
cd $(dirname -- $0)

kubectl create namespace nexus || true

kubectl apply -f 40-nexus/nexus-data-pvc.yaml
kubectl apply -f 40-nexus/nexus-deployment.yaml
kubectl apply -f 40-nexus/nexus-service.yaml
kubectl apply -f 40-nexus/nexus-ingress.yaml
kubectl apply -f 40-nexus/nexus-hechler-ingress.yaml

echo 
echo "the admin password is stored in the PVC in file admin.password"
echo 

