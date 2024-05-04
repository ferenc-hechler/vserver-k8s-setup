#!/bin/bash

set -xev
cd $(dirname -- $0)

kubectl delete -f ./50-ODA/keycloak-vs.yaml || true
helm uninstall -n canvas canvas || true
