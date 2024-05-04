#!/bin/bash

set -xev
cd $(dirname -- $0)

kubectl delete clusterrolebinding oidc-reviewer --ignore-not-found=true
kubectl delete -n canvas-vault -f 60-hashicorp-vault/canvas-vault-hc-vs.yaml --ignore-not-found=true
helm uninstall -n canvas-vault canvas-vault-hc || true
kubectl delete ns canvas-vault --ignore-not-found=true