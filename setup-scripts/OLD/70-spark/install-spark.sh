#!/bin/sh

set -xev
cd $(dirname -- $0)

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install -n spark bit-spark --set "worker.replicaCount=2" --create-namespace bitnami/spark
# helm upgrade --install bit-spark --version 6.1.10 --set "worker.replicaCount=2" -n spark --create-namespace bitnami/spark
# helm upgrade --install -n spark bit-spark --values values.yaml --create-namespace bitnami/spark

kubectl apply -f spark-vs.yaml

# kubectl delete -f spark-vs.yaml
# helm uninstall -n spark bit-spark
 