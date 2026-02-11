#!/bin/bash

# Vaultwarden (formerly Bitwarden_RS) - Self-hosted password manager
# Helm chart: https://github.com/gissilabs/charts/tree/master/vaultwarden

set -xev
cd $(dirname -- $0)

# Add helm repository
helm repo add gissilabs https://gissilabs.github.io/charts/
helm repo update

# Generate admin token if not set
# Use: openssl rand -base64 48
# export VAULTWARDEN_ADMIN_TOKEN="your-secure-token-here"

# Install or upgrade vaultwarden
helm upgrade --install vaultwarden \
  -n vaultwarden \
  --create-namespace \
  --values 67-vaultwarden/values.yaml \
  gissilabs/vaultwarden

# Apply ingress configuration
kubectl apply -f 67-vaultwarden/vaultwarden-ingress.yaml

echo ""
echo "================================================================"
echo "Vaultwarden installation complete!"
echo ""
echo "Access the web interface at: https://vaultwarden.k8s.cluster-4.de"
echo ""
echo "IMPORTANT: Set admin token before first use:"
echo "  Generate token: openssl rand -base64 48"
echo "  Update in values.yaml under adminToken.value"
echo "  Then run: helm upgrade vaultwarden -n vaultwarden --values 67-vaultwarden/values.yaml gissilabs/vaultwarden"
echo ""
echo "Admin panel: https://vaultwarden.k8s.cluster-4.de/admin"
echo "================================================================"

cd ..
