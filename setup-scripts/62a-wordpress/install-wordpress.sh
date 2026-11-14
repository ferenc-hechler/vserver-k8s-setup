#!/bin/sh

set -xev
cd $(dirname -- $0)

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install wordpress -n wordpress --create-namespace bitnami/wordpress --version 34.2.5 --set "service.type=ClusterIP" --set "wordpressUsername=vps4admin" --set "readinessProbe.enabled=false" --set "livenessProbe.enabled=true"

#helm pull oci://registry-1.docker.io/bitnamicharts/wordpress --version 34.2.5



##https://github.com/bitnami/charts/tree/main/bitnami/wordpress
#helm upgrade --install wordpress --version 16.0.4 --set "service.type=ClusterIP" --set "wordpressUsername=vps4admin" --set "readinessProbe.enabled=false" --set "livenessProbe.enabled=true" -n wordpress --create-namespace oci://registry-1.docker.io/bitnamicharts/wordpress
## kubectl get secret --namespace wordpress wordpress -o jsonpath="{.data.wordpress-password}"
#kubectl apply -f wordpress-vs.yaml

# kubectl delete -f wordpress-vs.yaml
# helm uninstall -n wordpress wordpress
 
 
 