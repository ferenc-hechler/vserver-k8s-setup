#!/bin/bash

set -xev
cd $(dirname -- $0)

# from: https://docs.opencloud.eu/docs/admin/getting-started/docker
echo 'cert issue after 1 year: https://docs.opencloud.eu/docs/admin/resources/common-issues#internal-libreidm-cert-expires'
echo 'kubectl get pod -n opencloud -lapp=opencloud -ojsonpath="{.items[0].metadata.name}"'
echo 'kubectl exec -n opencloud -it <pod-name> -- /bin/sh -c "rm  ./idm/ldap.key ./idm/ldap.crt"'
echo '10 years certs?: openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 -subj '/CN=ldap.opencloud.local' -keyout ldap.key -out ldap.crt"'
echo 'kubectl rollout restart -n opencloud opencloud'

