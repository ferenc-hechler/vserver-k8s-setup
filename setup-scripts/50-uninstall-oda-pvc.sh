#!/bin/bash

set -xev
cd $(dirname -- $0)

kubectl delete pvc -n canvas data-canvas-postgresql-0 || true
kubectl delete ns canvas || true
