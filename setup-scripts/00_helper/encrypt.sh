#!/bin/bash

set -e

SOURCE_FILE=$1
test -n $SOURCE_FILE
test -f "${SOURCE_FILE}"


PASSPHRASE=$(cat /etc/machine-id | md5sum |  head -c 30 | tail -c 28 | md5sum | head -c 32)

rm -f "${SOURCE_FILE}.gpg"

gpg --batch --output "${SOURCE_FILE}.gpg" --armor --passphrase "$PASSPHRASE" --symmetric "${SOURCE_FILE}"
