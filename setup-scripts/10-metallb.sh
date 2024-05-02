#!/bin/bash

set -xev
cd $(dirname -- $0)


# prerequesites
kubectl get configmap kube-proxy -n kube-system -o yaml | sed -e "s/strictARP: false/strictARP: true/" | kubectl apply -f - -n kube-system

# install
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml

# give webhook some time to startup
sleep 30

# configure
kubectl apply -f ./10-metallb/ipadresspool.yaml
kubectl apply -f ./10-metallb/l2advertisement.yaml
