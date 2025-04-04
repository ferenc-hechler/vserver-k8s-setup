#!/bin/bash

set -xev
cd $(dirname -- $0)

export NGINX_HTTP_NODEPORT=$(kubectl get service ingress-nginx-controller -n ingress-nginx -o  go-template='{{ (index .spec.ports 0).nodePort}}')
export NGINX_HTTPS_NODEPORT=$(kubectl get service ingress-nginx-controller -n ingress-nginx -o  go-template='{{ (index .spec.ports 1).nodePort}}')

export PUBLIC_IP=$(curl -q ident.me)

sudo nohup socat TCP-LISTEN:80,fork TCP:$PUBLIC_IP:$NGINX_HTTP_NODEPORT & >/dev/null 2>&1
sudo nohup socat TCP-LISTEN:443,fork TCP:$PUBLIC_IP:$NGINX_HTTPS_NODEPORT &  >/dev/null 2>&1
