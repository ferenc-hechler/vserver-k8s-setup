#!/bin/sh

set -xev
cd $(dirname -- $0)
BASE_FOLDER=$(pwd)


export PGPCB_CONFIG_FILE="$BASE_FOLDER/.pcloud-config"
export PGPCB_PUBLIC_PGP_KEY_FILE="$BASE_FOLDER/encrypt-key.pub"
export PGPCB_LOCAL_FOLDER="/tmp/BAK"
export PGPCB_TEMP_FOLDER="/tmp"
export PGPCB_REMOTE_FOLDER="/VSERVERBACKUP/nextcloud-vps6"
export PGPCB_DELETE_REMOTE="false"
export PGPCB_KEEP_PERIODS="7d4w3m*y"
export PGPCB_IGNORE_MISSING_TIMESTAMPS="false"

java -jar pgpcloudbackup-jar-with-dependencies.jar
