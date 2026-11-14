#!/bin/sh

set -xev
cd $(dirname -- $0)

#https://github.com/bitnami/charts/tree/main/bitnami/wordpress
helm upgrade --install wordpress --version 16.0.4 --set "service.type=ClusterIP" --set "wordpressUsername=vps4admin" --set "readinessProbe.enabled=false" --set "livenessProbe.enabled=true" -n wordpress --create-namespace oci://registry-1.docker.io/bitnamicharts/wordpress
# kubectl get secret --namespace wordpress wordpress -o jsonpath="{.data.wordpress-password}"
kubectl apply -f wordpress-vs.yaml

# kubectl delete -f wordpress-vs.yaml
# helm uninstall -n wordpress wordpress
 
 
 