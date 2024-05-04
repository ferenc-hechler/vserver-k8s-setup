#!/bin/bash

set -xev
cd $(dirname -- $0)

export DOMAINLABEL1=cluster-1
export HELMOPTS=--set=domainLabel1=$DOMAINLABEL1

./03-setup-k8s.sh
./10-metallb.sh
./20-istio.sh
./30a-host-nginx-certs.sh
./30b-host-nginx-routes.sh
./40-prometheus-grafana.sh
