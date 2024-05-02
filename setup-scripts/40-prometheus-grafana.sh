#!/bin/bash

set -xev
cd $(dirname -- $0)


# from: https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# 1. keep existing k8s-secret, 2. use env variable, 3. generate random password 
if kubectl get secret -n grafana prometheus-kube-prometheus-stack-prometheus >/dev/null 2>&1
then
    GRAFANA_ADMIN_PASSWORD=$(kubectl get secret -n grafana kube-prometheus-stack-grafana -o go-template='{{index .data "admin-password" | base64decode}}')
elif [ "$GRAFANA_ADMIN_PASSWORD" == "" ]
then    
    GRAFANA_ADMIN_PASSWORD=$(date +VS%s | sha256sum | base64 | head -c 16)
fi

helm upgrade --install kube-prometheus-stack --namespace grafana --create-namespace --set grafana.adminPassword="$GRAFANA_ADMIN_PASSWORD" prometheus-community/kube-prometheus-stack

helm upgrade --install grafana-route --namespace grafana $HELMOPTS 40-prometheus-grafana/helm-charts/grafana-route

echo
echo "to get grafana admin password use:" 
echo "GPW=\$(kubectl get secret -n grafana kube-prometheus-stack-grafana -o go-template='{{index .data \"admin-password\" | base64decode}}')" 
echo
echo "Grafana is now accessible via https://grafana.k8s.$DOMAINLABEL1.de"
echo
