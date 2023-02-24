#!/bin/sh

# see https://github.com/jupyterhub/zero-to-jupyterhub-k8s/blob/2.0.0/images/hub/requirements.txt

set -xev
cd $(dirname -- $0)

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
helm upgrade --install jupyter15 --values values.yaml --version 1.5.0 jupyterhub/jupyterhub --namespace jupyter --create-namespace

#helm upgrade --install jupyter15 --version 1.5.0 jupyterhub/jupyterhub --namespace jupyter --create-namespace

kubectl apply -f jupyter-vs.yaml

# helm upgrade --install jupyter15 --values values.yaml  --version 1.5.0 jupyterhub/jupyterhub --namespace jupyter

# kubectl delete -f jupyter15-vs.yaml
# helm uninstall -n jupyter jupyter15
 