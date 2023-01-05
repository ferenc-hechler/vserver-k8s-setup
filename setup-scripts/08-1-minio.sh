#!/bin/bash

# from: https://min.io/docs/minio/kubernetes/upstream/
#       https://raw.githubusercontent.com/minio/docs/master/source/extra/examples/minio-dev.yaml
#       https://github.com/vmware-tanzu/velero/blob/main/examples/minio/00-minio-deployment.yaml

set -xev
cd $(dirname -- $0)

MINIO_PASSWORD=$(00-utils/define-password.sh minio minio-admin-secret admin-password)
VELEROUSER_PASSWORD=$(00-utils/define-password.sh minio velerouser-secret velerouser-password)

kubectl apply -f 08-minio/minio-pvc.yaml
kubectl apply -f 08-minio/minio-statefulset.yaml
kubectl apply -f 08-minio/minio-service.yaml
kubectl apply -f 08-minio/minio-api-service.yaml
kubectl apply -f 08-minio/minio-ingress.yaml
kubectl apply -f 08-minio/minio-api-ingress.yaml

kubectl apply -f 08-minio/init/create-velero-user-and-buckets.yaml

echo
echo "to get the minio admin password use:" 
echo "GPW=\$(kubectl get secret -n minio minio-admin-secret -o go-template='{{index .data \"admin-password\" | base64decode}}')" 
echo
