#!/bin/bash

# Script to generate admin token and create Kubernetes secret
# This script helps securely manage the Vaultwarden admin token

set -e

echo "Vaultwarden SMTP Credentials Generator"
echo "======================================"
echo ""

read -p "SMTP Username: " -r
SMTP_USER=$REPLY
read -p "SMTP Password: " -r -s
SMTP_PASSWORD=$REPLY
echo ""
echo ""

# Ask if user wants to create a Kubernetes secret
read -p "Create Kubernetes secret for user $SMTP_USER? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Check if namespace exists
    if ! kubectl get namespace vaultwarden &> /dev/null; then
        echo "Creating namespace 'vaultwarden'..."
        kubectl create namespace vaultwarden
    fi
    
    # Delete existing secret if it exists
    if kubectl get secret vaultwarden-smtp-credentials -n vaultwarden &> /dev/null; then
        echo "Deleting existing secret..."
        kubectl delete secret vaultwarden-smtp-credentials -n vaultwarden
    fi
    
    # Create new secret
    echo "Creating secret 'vaultwarden-smtp-credentials' in namespace 'vaultwarden'..."
    kubectl create secret generic vaultwarden-smtp-credentials \
        -n vaultwarden \
        --from-literal=smtp-user="$SMTP_USER" \
        --from-literal=smtp-password="$SMTP_PASSWORD"
    
    echo ""
    echo "Secret created successfully!"
    echo ""
    echo "To use this secret, update values.yaml:"
    echo "  vaultwarden:"
    echo "    smtp:"
    echo "      enabled: true"
    echo "      existingSecret: \"vaultwarden-smtp-credentials\""
    echo "      ..."
    echo ""
else
    echo ""
    echo "Secret not created. You can manually add the token to values.yaml:"
    echo "  vaultwarden:"
    echo "    smtp:"
    echo "      enabled: true"
    echo "      user: \"$SMTP_USER\""
    echo "      password: \"$SMTP_PASSWORD\""
    echo "      ..."
    echo ""
fi

