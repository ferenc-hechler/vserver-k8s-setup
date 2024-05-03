#!/bin/bash

set -e

SOURCE_FILE=$1
TARGET_FILE=${SOURCE_FILE%.gpg}
test -n "${SOURCE_FILE}"
test -f "${SOURCE_FILE}"

if [[ "$SOURCE_FILE" == "$TARGET_FILE" ]]
then
	echo "suffix .gpg is missing"
	exit 1
fi 

PASSPHRASE=$(cat /etc/machine-id | md5sum |  head -c 30 | tail -c 28 | md5sum | head -c 32)

rm -f "${TARGET_FILE}"

gpg --batch --output "${TARGET_FILE}" --passphrase "$PASSPHRASE" --decrypt "${SOURCE_FILE}"
