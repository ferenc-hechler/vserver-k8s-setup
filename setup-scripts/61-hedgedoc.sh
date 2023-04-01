#!/bin/bash

# from: https://artifacthub.io/packages/helm/schmitzis/hedgedoc
#       https://artifacthub.io/packages/helm/nicholaswilde/hedgedoc
#       https://docs.hedgedoc.org/setup/community/

set -xev
cd $(dirname -- $0)

#helm repo add nicholaswilde https://nicholaswilde.github.io/helm-charts/
#helm repo update
#helm upgrade --install hedgedoc nicholaswilde/hedgedoc --namespace hedgedoc --create-namespace --set hedgedoc.security.cspEnabled=false

helm upgrade --install hedgedoc-postgresql bitnami/postgresql --namespace hedgedoc --values psql-values.yaml

helm repo add schmitzis https://schmitzis.github.io/helm-charts/
helm repo update
helm upgrade --install hedgedoc schmitzis/hedgedoc --namespace hedgedoc --create-namespace --values values.yaml


kubectl apply -f 61-hedgedoc/hedgedoc-ingress.yaml

