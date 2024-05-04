#!/bin/bash

set -xev
cd $(dirname -- $0)



helm repo add oda-canvas https://tmforum-oda.github.io/oda-canvas
helm repo update
helm upgrade --install canvas oda-canvas/canvas-oda -n canvas --create-namespace --set keycloak.service.type=ClusterIP --set controller.deployment.compconImage=mtr.devops.telekom.de/magenta_canvas/public:component-istio-controller-0.4.0-depapi  --set=controller.configmap.loglevel=10  --set=controller.deployment.dataDog.enabled=false

# cd ~/git/oda-canvas-dependent-api
# helm upgrade --install canvas ../../oda-canvas-dependent-api/charts/canvas-oda -n canvas --create-namespace --set keycloak.service.type=ClusterIP --set=controller.configmap.loglevel=10 --set=controller.deployment.compconImagePullPolicy=Always --set=dependentapi-simple-operator.loglevel=10

kubectl patch configmap/canvas-controller-configmap -n canvas --type merge -p "{\"data\":{\"APIOPERATORISTIO_PUBLICHOSTNAME\":\"components.k8s.cluster-1.de\"}}"
kubectl rollout restart deployment -n canvas oda-controller-ingress

kubectl apply -f ./50-ODA/keycloak-vs.yaml

