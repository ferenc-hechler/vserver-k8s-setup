#!/bin/sh

set -xev
cd $(dirname -- $0)

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install wordpress2 -n wordpress2 --create-namespace bitnami/wordpress --version 34.2.5 --set "service.type=ClusterIP" --set "wordpressUsername=vps-2adMIN" --set "readinessProbe.enabled=false" --set "livenessProbe.enabled=true"

kubectl apply -f wordpress2-ing.yaml


# kubectl delete -f wordpress2-ing.yaml
# helm uninstall -n wordpress2 wordpress2
 
 
 