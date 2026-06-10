#!/bin/bash

# from: https://hub.docker.com/r/sonatype/nexus3

set -xev
cd $(dirname -- $0)

kubectl create namespace jfrog || true

helm repo add jfrog https://charts.jfrog.io
helm repo update

POSTGRES_PASSWORD=$(openssl rand -base64 16 | tr -dc 'a-zA-Z0-9' | head -c 20)

helm upgrade --install jfrog jfrog/artifactory-oss \
  --namespace jfrog --create-namespace \
  --set artifactory.postgresql.auth.password=${POSTGRES_PASSWORD} \
  --set artifactory.artifactory.service.type=ClusterIP \
  --set artifactory.nginx.service.type=ClusterIP \
  --set artifactory.postgresql.primary.persistence.size=20Gi \
  --set artifactory.artifactory.persistence.size=5Gi

kubectl apply -f 40-jfrog/jfrog-ingress.yaml

echo "PostgreSQL Password: ${POSTGRES_PASSWORD}"