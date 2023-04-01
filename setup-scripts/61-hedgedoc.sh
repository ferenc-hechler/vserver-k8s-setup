#!/bin/bash

# from: https://artifacthub.io/packages/helm/nicholaswilde/hedgedoc
#       https://docs.hedgedoc.org/setup/community/

set -xev
cd $(dirname -- $0)

helm repo add nicholaswilde https://nicholaswilde.github.io/helm-charts/
helm repo update
$ helm install hedgedoc nicholaswilde/hedgedoc

helm upgrade --install hedgedoc nicholaswilde/hedgedoc --namespace hedgedoc --create-namespace 

kubectl apply -f 61-hedgedoc/hedgedoc-ingress.yaml

