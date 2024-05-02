#!/bin/bash

# from: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

set -xev
cd $(dirname -- $0)

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

kubectl apply -f 07-dashboard/kd-admin-user-sa.yaml
kubectl apply -f 07-dashboard/kd-cluster-admin-rolebinding.yaml

kubectl apply -f 07-dashboard/dashboard-ingress.yaml

echo "TOKEN for login:"
kubectl -n kubernetes-dashboard create token admin-user