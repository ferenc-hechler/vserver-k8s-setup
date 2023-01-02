#!/bin/bash

# from: https://min.io/docs/minio/kubernetes/upstream/
#       https://raw.githubusercontent.com/minio/docs/master/source/extra/examples/minio-dev.yaml
#       https://github.com/vmware-tanzu/velero/blob/main/examples/minio/00-minio-deployment.yaml

set -xev
cd $(dirname -- $0)

kubectl create namespace minio || true

if kubectl get secret -n minio minio-admin-secret >/dev/null 2>&1
then
    echo "secret already exists"
else
    MINIO_PASSWORD=$(date +VS%s | sha256sum | base64 | head -c 16)
	kubectl create secret generic -n minio minio-admin-secret --from-literal=admin-password="$MINIO_PASSWORD"
fi

kubectl apply -f 08-minio/minio-pvc.yaml
kubectl apply -f 08-minio/minio-statefulset.yaml
kubectl apply -f 08-minio/minio-service.yaml
kubectl apply -f 08-minio/minio-api-service.yaml
kubectl apply -f 08-minio/minio-ingress.yaml
kubectl apply -f 08-minio/minio-api-ingress.yaml

echo
echo "to get the minio admin password use:" 
echo "GPW=\$(kubectl get secret -n minio minio-admin-secret -o go-template='{{index .data \"admin-password\" | base64decode}}')" 
echo
