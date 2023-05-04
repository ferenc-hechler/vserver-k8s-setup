#!/bin/sh

set -xev
cd $(dirname -- $0)

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install wordpress --version 16.0.4 -n wordpress --create-namespace oci://registry-1.docker.io/bitnamicharts/wordpress
kubectl apply -f wordpress-vs.yaml

# kubectl delete -f wordpress-vs.yaml
# helm uninstall -n wordpress wordpress
 
 
 