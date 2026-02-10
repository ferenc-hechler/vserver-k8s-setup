#!/bin/bash

# Script to generate admin token and create Kubernetes secret
# This script helps securely manage the Vaultwarden admin token

set -e

echo "Vaultwarden Admin Token Generator"
echo "=================================="
echo ""

# Generate a secure token
TOKEN=$(openssl rand -base64 48)

echo "Generated secure admin token:"
echo "$TOKEN"
echo ""

# Ask if user wants to create a Kubernetes secret
read -p "Create Kubernetes secret for this token? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Check if namespace exists
    if ! kubectl get namespace vaultwarden &> /dev/null; then
        echo "Creating namespace 'vaultwarden'..."
        kubectl create namespace vaultwarden
    fi
    
    # Delete existing secret if it exists
    if kubectl get secret vaultwarden-admin-token -n vaultwarden &> /dev/null; then
        echo "Deleting existing secret..."
        kubectl delete secret vaultwarden-admin-token -n vaultwarden
    fi
    
    # Create new secret
    echo "Creating secret 'vaultwarden-admin-token' in namespace 'vaultwarden'..."
    kubectl create secret generic vaultwarden-admin-token \
        -n vaultwarden \
        --from-literal=token="$TOKEN"
    
    echo ""
    echo "Secret created successfully!"
    echo ""
    echo "To use this secret, update values.yaml:"
    echo "  adminToken:"
    echo "    existingSecret: \"vaultwarden-admin-token\""
    echo "    existingSecretKey: \"token\""
    echo ""
else
    echo ""
    echo "Secret not created. You can manually add the token to values.yaml:"
    echo "  adminToken:"
    echo "    value: \"$TOKEN\""
    echo ""
fi

echo "IMPORTANT: Save this token in a secure location (password manager)!"
echo "You will need it to access the admin panel at /admin"
