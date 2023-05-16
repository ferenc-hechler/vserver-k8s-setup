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
#  Unseal Key 1: UPdxbv8w3OLpdUX1L6XbyHhlWK/ghglGkDXTJfQdw8ED
#  Unseal Key 2: bhavO5NcDCDcspgUvwG6MQ7F9+T1cRTpLB3zbYKRr4Vf
#  Unseal Key 3: kv8O2iegM4PZAAJjaZfRuGd5vu1+N1f+Bjcx3urgz6xq
#  Unseal Key 4: liOPhUTIXvQHGf2V9volHFWR4MI8c08tzHJkAWWP7MjQ
#  Unseal Key 5: omuvUj6JJvCIPeSTSH7NPetjR9sXVc7pfNfrE9+36/1n

echo "unseal with 3 of 5 keys"
  
echo kubectl exec -it -n vault vault-0 -- vault operator unseal
#  Unseal Key (will be hidden): UPdxbv8w3OLpdUX1L6XbyHhlWK/ghglGkDXTJfQdw8ED

echo kubectl exec -it -n vault vault-0 -- vault operator unseal
#  Unseal Key (will be hidden): bhavO5NcDCDcspgUvwG6MQ7F9+T1cRTpLB3zbYKRr4Vf

echo kubectl exec -it -n vault vault-0 -- vault operator unseal
#  Unseal Key (will be hidden): kv8O2iegM4PZAAJjaZfRuGd5vu1+N1f+Bjcx3urgz6xq

 
 