#!/bin/bash

set -xev
cd $(dirname -- $0)


# prerequesites
kubectl get configmap kube-proxy -n kube-system -o yaml | sed -e "s/strictARP: false/strictARP: true/" | kubectl apply -f - -n kube-system

# install
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml

# give webhook some time to startup
OK=0
while [ $OK -ne 1 ]
do
    sleep 15
    OK=1
    kubectl apply -f ./10-metallb/ipadresspool.yaml || OK=0
	kubectl apply -f ./10-metallb/l2advertisement.yaml || OK=0
done
