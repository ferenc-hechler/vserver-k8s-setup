#!/bin/bash

set -xev
cd $(dirname -- $0)

export MINECRAFT_NODEPORT=$(kubectl get service minecraft-service -n minecraft -o  go-template='{{ (index .spec.ports 0).nodePort}}')

export PUBLIC_IP=$(curl ident.me)

sudo nohup socat TCP-LISTEN:61267,fork TCP:$PUBLIC_IP:$MINECRAFT_NODEPORT  >/dev/null 2>&1 &
