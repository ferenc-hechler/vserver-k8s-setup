#!/bin/bash

# Yopass - share secrets securely

set -xev
cd $(dirname -- $0)

# Add helm repository
helm repo add cloudhippie https://cloudhippie.github.io/charts
helm repo update

helm upgrade --install yopass \
  -n yopass --create-namespace \
  --set memcached.enabled=true \
  cloudhippie/yopass 


# Apply ingress configuration
kubectl apply -f 68-yopass/yopass-ingress.yaml

echo ""
echo "================================================================"
echo "Yopass installation complete!"
echo ""
echo "Access the web interface at: https://yopass.k8s.cluster-4.de"
echo ""
echo "================================================================"

cd ..
