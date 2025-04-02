#!/bin/bash

# from: https://docs.opencloud.eu/docs/admin/getting-started/docker

set -xev
cd $(dirname -- $0)

kubectl create namespace opencloud || true

kubectl apply -f 66-opencloud/opencloud-config-pvc.yaml
kubectl apply -f 66-opencloud/opencloud-data-pvc.yaml
#kubectl apply -f 66-opencloud/opencloud-inspect.yaml
kubectl apply -f 66-opencloud/opencloud-init.yaml


