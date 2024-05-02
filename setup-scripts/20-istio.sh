#!/bin/bash

set -xev
cd $(dirname -- $0)


helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
kubectl create namespace istio-system || true
helm upgrade --install istio-base istio/base -n istio-system
helm upgrade --install istiod istio/istiod -n istio-system --wait
kubectl create namespace istio-ingress || true
kubectl label namespace istio-ingress istio-injection=enabled
helm upgrade --install istio-ingress istio/gateway -n istio-ingress --set labels.app=istio-ingress --set labels.istio=ingressgateway 

if [ -n "$FAKE_LB" ]
then
	## fake lb hostname
	kubectl patch service -n istio-ingress istio-ingress --subresource=status --type="json" --patch "[{ \"op\": \"replace\", \"path\": \"/status/loadBalancer\", \"value\": {\"ingress\": [{\"hostname\":\"component.k8s.$DOMAINLABEL1.de\"}]} }]"
fi


helm upgrade --install c2gateway --namespace istio-ingress $HELMOPTS ./20-istio/helm-charts/c2gateway
helm upgrade --install demoapp --namespace demoapp --create-namespace $HELMOPTS ./20-istio/helm-charts/demoapp --wait
helm upgrade --install echoservice --namespace echoservice --create-namespace $HELMOPTS ./20-istio/helm-charts/echoservice --wait

echo "demoapp should now be accessible via https://demoapp.k8s.$DOMAINLABEL1.de"
echo "echoservice should now be accessible via https://echoservice.k8s.$DOMAINLABEL1.de"
