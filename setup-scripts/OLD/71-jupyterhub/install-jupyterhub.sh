#!/bin/sh

# see https://github.com/jupyterhub/zero-to-jupyterhub-k8s/blob/2.0.0/images/hub/requirements.txt

set -xev
cd $(dirname -- $0)

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
helm upgrade --install jupyter jupyterhub/jupyterhub --values values.yaml  --namespace spark --create-namespace

#kubectl apply -f jupyter-vs.yaml
kubectl apply -f jupyter-ingress.yaml

# helm upgrade --install jupyter --values values.yaml  jupyterhub/jupyterhub --namespace spark

# kubectl delete -f jupyter-vs.yaml
# helm uninstall -n spark jupyter
 
 
# helm upgrade --install jupyter jupyterhub/jupyterhub --values values.yaml  --namespace jupyter --create-namespace
# helm uninstall -n jupyter jupyter

 