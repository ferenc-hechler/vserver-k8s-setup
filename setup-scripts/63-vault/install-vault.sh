#!/bin/sh

set -xev
cd $(dirname -- $0)

# https://developer.hashicorp.com/vault/docs/platform/k8s/helm
helm repo add hashicorp https://helm.releases.hashicorp.com

helm search repo hashicorp/vault

helm upgrade --install vault  -n vault --create-namespace hashicorp/vault --version 0.24.0

# https://developer.hashicorp.com/vault/tutorials/kubernetes

# https://github.com/hashicorp/vault-helm/issues/17
#
echo "kubectl exec -it -n vault vault-0 -- vault operator init"
#  Unseal Key 1: UPdx...dw8ED
#  Unseal Key 2: bhav...r4Vf
#  Unseal Key 3: kv8O...z6xq
#  Unseal Key 4: liOP...7MjQ
#  Unseal Key 5: omuv...6/1n
#  Initial Root Token: hvs.GJOd...Ekjp

echo "unseal with 3 of 5 keys"
  
echo kubectl exec -it -n vault vault-0 -- vault operator unseal
#  Unseal Key (will be hidden): UPdx...w8ED

echo kubectl exec -it -n vault vault-0 -- vault operator unseal
#  Unseal Key (will be hidden): bhav...r4Vf

echo kubectl exec -it -n vault vault-0 -- vault operator unseal
#  Unseal Key (will be hidden): kv8O...z6xq

kubectl apply -f vault-ing.yaml
 
# https://developer.hashicorp.com/vault/docs/platform/k8s/helm/run

# videos
# https://developer.hashicorp.com/vault/tutorials/getting-started-ui/getting-started-intro-ui
# https://developer.hashicorp.com/vault/tutorials/getting-started-ui/getting-started-policies-ui

 