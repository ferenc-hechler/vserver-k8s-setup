#!/bin/bash

# from: https://devopscube.com/setup-ingress-kubernetes-nginx-controller/
#       https://github.com/kubernetes/ingress-nginx
#       https://github.com/scriptcamp/nginx-ingress-controller
#       https://medium.com/@ahmedwaleedmalik/exposing-tcp-and-udp-services-in-kubernetes-using-nginx-ingress-9b8fd639c576
#       https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#proxy-body-size

set -xev
cd $(dirname -- $0)

# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.1/deploy/static/provider/cloud/deploy.yaml
# customized to allow file uploads > 1MB

kubectl apply -f 04-ingress-nginx/ingress-nginx-deploy.yaml

