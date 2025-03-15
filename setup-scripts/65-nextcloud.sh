#!/bin/bash

# from: https://github.com/nextcloud/helm

set -xev
cd $(dirname -- $0)
65-nextcloud

helm repo add nextcloud https://nextcloud.github.io/helm/
helm repo update

#NEXTCLOUD_PASSWORD=...
helm upgrade --install nextcloud -n nextcloud --create-namespace --values values.yaml --set nextcloud.password=$NEXTCLOUD_PASSWORD nextcloud/nextcloud

kubectl apply -f nextcloud-ingress.yaml

cd ..

