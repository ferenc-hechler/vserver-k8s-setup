#!/bin/bash

set -xev
cd $(dirname -- $0)


kubectl delete -f 40-prometheus-grafana/grafana-vs.yaml || true
helm uninstall -n grafana grafana-route || true
helm uninstall -n grafana kube-prometheus-stack || true
kubectl delete ns grafana || true

