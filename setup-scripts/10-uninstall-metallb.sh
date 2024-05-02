#!/bin/bash

set -xev
cd $(dirname -- $0)


kubectl delete -f ./10-metallb/ipadresspool.yaml
kubectl delete -f ./10-metallb/l2advertisement.yaml

kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-native.yaml

kubectl get configmap kube-proxy -n kube-system -o yaml | sed -e "s/strictARP: true/strictARP: false/" | kubectl apply -f - -n kube-system

