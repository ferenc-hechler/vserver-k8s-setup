#!/bin/bash

# from: https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack

set -xev
cd $(dirname -- $0)

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

if kubectl get secret -n grafana prometheus-kube-prometheus-stack-prometheus >/dev/null 2>&1
then
    GRAFANA_PASSWORD=$(kubectl get secret -n grafana kube-prometheus-stack-grafana -o go-template='{{index .data "admin-password" | base64decode}}')
else
    GRAFANA_PASSWORD=$(date +VS%s | sha256sum | base64 | head -c 16)
fi


helm upgrade --install kube-prometheus-stack --namespace grafana --create-namespace --set grafana.adminPassword="$GRAFANA_PASSWORD" prometheus-community/kube-prometheus-stack

kubectl apply -f 06-prometheus-grafana/grafana-ingress.yaml

echo
echo "to get grafana admin password use:" 
echo "GPW=\$(kubectl get secret -n grafana kube-prometheus-stack-grafana -o go-template='{{index .data \"admin-password\" | base64decode}}')" 
echo
