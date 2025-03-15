#!/bin/sh

set -xev
cd $(dirname -- $0)
BASE_FOLDER=$(pwd)

cd /var/www/nextcloud
sudo sudo -u www-data php occ maintenance:mode --on

DB_PASSWORD=$(sudo cat /root/.dbpwd)
NOW=$(date +"%Y-%m-%d")
BACKUP_FOLDER=/tmp/BAK
DB_SERVER=localhost
DB_NAME=nextcloud
DB_USER=nextcloud

rm -rf $BACKUP_FOLDER/nextcloud-*
mkdir -p $BACKUP_FOLDER/nextcloud-$NOW
mysqldump --single-transaction -h "$DB_SERVER" -u "$DB_USER" -p$DB_PASSWORD "$DB_NAME" > $BACKUP_FOLDER/nextcloud-$NOW/nextcloud-sqldump.sql

sudo tar cvzf $BACKUP_FOLDER/nextcloud-$NOW/nextcloud-config-$NOW.tgz -C /var/www/nextcloud config
sudo tar cvzf $BACKUP_FOLDER/nextcloud-$NOW/nextcloud-themes-$NOW.tgz -C /var/www/nextcloud themes
sudo tar cvzf $BACKUP_FOLDER/nextcloud-$NOW/nextcloud-data-$NOW.tgz -C /home data

cd /var/www/nextcloud
sudo sudo -u www-data php occ maintenance:mode --off

tar cvzf $BACKUP_FOLDER/nextcloud-$NOW.tgz -C $BACKUP_FOLDER nextcloud-$NOW 
rm -rf $BACKUP_FOLDER/nextcloud-$NOW

export PGPCB_CONFIG_FILE="$BASE_FOLDER/.pcloud-config"
export PGPCB_PUBLIC_PGP_KEY_FILE="$BASE_FOLDER/encrypt-key.pub"
export PGPCB_LOCAL_FOLDER="$BACKUP_FOLDER"
export PGPCB_TEMP_FOLDER="/tmp"
export PGPCB_REMOTE_FOLDER="/VSERVERBACKUP/nextcloud-vps6"
export PGPCB_DELETE_REMOTE="false"
export PGPCB_KEEP_PERIODS="7d4w3m*y"
export PGPCB_IGNORE_MISSING_TIMESTAMPS="false"

cd $BASE_FOLDER
java -jar pgpcloudbackup-jar-with-dependencies.jar
