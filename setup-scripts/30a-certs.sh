#!/bin/bash

cd $(dirname -- $0)

00_helper/decrypt.sh 20-istio/certs/fullchain.pem.gpg
00_helper/decrypt.sh 20-istio/certs/privkey.pem.gpg
