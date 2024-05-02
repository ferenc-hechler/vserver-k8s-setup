#!/bin/bash

set -xev
cd $(dirname -- $0)

helm uninstall -n echoservice echoservice || true
helm uninstall -n demoapp demoapp || true 
helm uninstall -n istio-system c2gateway || true 
helm uninstall -n istio-ingress istio-ingress || true  
helm uninstall -n istio-system istiod || true
helm uninstall -n istio-system istio-base || true 
 