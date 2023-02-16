#!/bin/sh

set -xev
cd $(dirname -- $0)

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
helm upgrade --install jupyter jupyterhub/jupyterhub --namespace spark --create-namespace --version=<chart-version> --values values.yaml

kubectl apply -f jupyter-vs.yaml

# kubectl delete -f jupyter-vs.yaml
# helm uninstall -n spark jupyter
 