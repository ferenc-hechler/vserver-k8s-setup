#!/bin/bash

set -xev
cd $(dirname -- $0)

cd ~/git/oda-canvas-component-vault

cd chart/cert-manager-init
helm dependency update
helm dependency build
cd ../..

cd chart/controller
helm dependency update
helm dependency build
cd ../..

cd chart/canvas-oda
helm dependency update
helm dependency build
cd ../..

helm upgrade --install canvas -n canvas --create-namespace --values source/component-vault/custom/patched-oda-canvas/values.yaml charts/canvas-oda

helm upgrade --install componentvault-operator -n canvas --create-namespace source/component-vault/operators/componentvaultoperator-hc/helmcharts/cvop
