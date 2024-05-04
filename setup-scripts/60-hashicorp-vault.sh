#!/bin/bash

set -xev
cd $(dirname -- $0)


helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm upgrade --install canvas-vault-hc --namespace canvas-vault --create-namespace --version 0.28.0 --values 60-hashicorp-vault/values.yaml hashicorp/vault 

kubectl apply -n canvas-vault -f 60-hashicorp-vault/canvas-vault-hc-vs.yaml

kubectl exec -n canvas-vault canvas-vault-hc-0 -- vault auth enable -path jwt-k8s-cv jwt

# see: https://developer.hashicorp.com/vault/docs/auth/jwt/oidc-providers/kubernetes#using-service-account-issuer-discovery
kubectl create clusterrolebinding oidc-reviewer  --clusterrole=system:service-account-issuer-discovery --group=system:unauthenticated

ISSUER="$(kubectl get --raw /.well-known/openid-configuration | jq -r '.issuer')"
echo "ISSUER=$ISSUER"
kubectl exec -n canvas-vault -it canvas-vault-hc-0 -- vault write auth/jwt-k8s-cv/config oidc_discovery_url=$ISSUER oidc_discovery_ca_pem=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
