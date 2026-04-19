#!/bin/bash

# from: https://docs.opencloud.eu/docs/admin/getting-started/docker
# cert issue after 1 year: https://docs.opencloud.eu/docs/admin/resources/common-issues#internal-libreidm-cert-expires
#   kubectl get pod -n opencloud -lapp=opencloud -ojsonpath="{.items[0].metadata.name}"
#   kubectl exec -n opencloud -it <pod-name> -- /bin/sh -c "rm  ./idm/ldap.key ./idm/ldap.crt"
#   ??? kubectl exec -n opencloud -it <pod-name> -- /bin/sh -c "cd ./idm && openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 -subj '/CN=ldap.opencloud.local' -keyout ldap.key -out ldap.crt"
#   kubectl rollout restart -n opencloud opencloud

set -xev
cd $(dirname -- $0)

kubectl create namespace opencloud || true

kubectl apply -f 66-opencloud/opencloud-config-pvc.yaml
kubectl apply -f 66-opencloud/opencloud-data-pvc.yaml
#kubectl apply -f 66-opencloud/opencloud-inspect.yaml
kubectl apply -f 66-opencloud/opencloud-init.yaml


