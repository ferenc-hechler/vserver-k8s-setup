#!/bin/bash

set -e

TARGET_FILE=$1
test -n "${TARGET_FILE}"
test -f "${TARGET_FILE}.gpg"

PASSPHRASE=$(cat /etc/machine-id | md5sum |  head -c 30 | tail -c 28 | md5sum | head -c 32)

rm -f "${TARGET_FILE}"

gpg --batch --output "${TARGET_FILE}" --passphrase "$PASSPHRASE" --decrypt "${TARGET_FILE}.gpg"
