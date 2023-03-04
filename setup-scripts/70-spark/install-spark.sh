#!/bin/sh

set -xev
cd $(dirname -- $0)

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install -n spark bit-spark --create-namespace bitnami/spark
# helm upgrade --install -n spark bit-spark --values values.yaml --create-namespace bitnami/spark

kubectl apply -f spark-vs.yaml

# kubectl delete -f spark-vs.yaml
# helm uninstall -n spark bit-spark
 