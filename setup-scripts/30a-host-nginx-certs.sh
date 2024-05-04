#!/bin/bash

set -xe

cd $(dirname -- $0)

00-helper/decrypt.sh 30-host-nginx/certs/fullchain.pem.gpg
00-helper/decrypt.sh 30-host-nginx/certs/privkey.pem.gpg
