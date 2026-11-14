#!/bin/sh

set -xev
cd $(dirname -- $0)

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install wordpress -n wordpress --create-namespace bitnami/wordpress --version 34.2.5 --set "service.type=ClusterIP" --set "wordpressUsername=vps4admin" --set "readinessProbe.enabled=false" --set "livenessProbe.enabled=true"

kubectl apply -f wordpress-ing.yaml


# kubectl delete -f wordpress-ing.yaml
# helm uninstall -n wordpress wordpress
 
 
 