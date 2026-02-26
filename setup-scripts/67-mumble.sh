#!/bin/bash

# Mumble - Voice chat application/server
# Helm chart: https://github.com/KierranM/mumble-k8s/tree/main/

set -xev
cd $(dirname -- $0)

# Add helm repository
helm repo add kierranm https://github.com/KierranM/mumble-k8s/tree/main/
helm repo update

# Install or upgrade mumble
helm upgrade --install mumble \
  -n mumble \
  --create-namespace \
  --values 67-mumble/values.yaml \
  kierranm/mumble

# Apply ingress configuration
# kubectl apply -f 67-mumble/mumble-ingress.yaml

echo ""
echo "================================================================"
echo "Mumble installation complete!"
echo "================================================================"

cd -
