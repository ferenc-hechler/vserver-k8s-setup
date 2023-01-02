#!/bin/bash
kubectl patch service -n canvas canvas-keycloak -p '{"spec": {"selector":{"app":"canvas-keycloak"}}}'
kubectl patch service -n canvas compcrdwebhook -p '{"spec": {"selector":{"app":"compcrdwebhook"}}}'
kubectl patch service -n canvas seccon -p '{"spec": {"selector":{"app":"oda-controller-ingress"}}}'
kubectl patch service -n kubernetes-dashboard kubernetes-dashboard -p '{"spec": {"selector":{"k8s-app":"kubernetes-dashboard"}}}'
