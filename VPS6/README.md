# VPS 6

Ubuntu 22.04 base image

## NextCloud installation 

https://contabo.com/blog/setting-up-nextcloud-on-vps/

## STEP 1 - Install Required Programs

```
sudo apt update 
sudo apt upgrade –y 
sudo apt install apache2 unzip wget curl mariadb-client mariadb-server nano
```

## STEP 2 - Install PHP8.0

https://linuxhint.com/install-php-8-ubuntu-22-04/

```
sudo apt install lsb-release ca-certificates apt-transport-https software-properties-common -y
sudo add-apt-repository ppa:ondrej/php
```

```
sudo apt install php8.0
```

check

```
php -v

  PHP 8.0.30 (cli) (built: Sep  2 2023 08:05:13) ( NTS )
  Copyright (c) The PHP Group
  Zend Engine v4.0.30, Copyright (c) Zend Technologies
      with Zend OPcache v8.0.30, Copyright (c), by Zend Technologies
```

### install php 8 extensions

```
sudo apt install libapache2-mod-php8.0 php8.0-{zip,xml,mbstring,gd,curl,imagick,intl,bcmath,gmp,cli,mysql,apcu,redis} 
```

### config

sudo vi /etc/php/8.0/apache2/php.ini 

```
;memory_limit = 128M
memory_limit = 1024M

;upload_max_filesize = 2M
upload_max_filesize = 16G

;post_max_size = 8M
post_max_size = 16G

;date.timezone =
date.timezone = Europe/Berlin
```


## STEP 3 - Setting up a Database

```
sudo mysql -u root -p 
```

login with root password

```
create database nextcloud;
create user 'nextcloud'@'localhost' identified by '<PASSWORD>';
grant all privileges on nextcloud.* to 'nextcloud'@'localhost';
flush privileges;
exit;
```


## STEP 4: Download Nextcloud Files

```
cd /tmp 
wget https://download.nextcloud.com/server/releases/latest.zip 
unzip latest.zip
rm latest.zip
sudo mv nextcloud /var/www
```

## STEP 5: Configure Apache2

```
sudo a2enmod rewrite headers env dir mime
sudo systemctl restart apache2
```

### configure reverse proxy

```
sudo vi /etc/apache2/sites-available/nextcloud.conf
```

```
sudo a2ensite nextcloud.conf
sudo systemctl restart apache2
```

## STEP 6 (optional) create data folder

```
sudo mkdir /home/data
```

## STEP 7

```
sudo chown -R www-data:www-data /var/www/nextcloud 
sudo chmod -R 755 /var/www/nextcloud
sudo chown -R www-data:www-data /home/data
```

## STEP 8

```
sudo apt install certbot python3-certbot-apache -y
sudo certbot --apache
```

a certbot dialog follows


# Backup

https://docs.nextcloud.com/server/latest/admin_manual/maintenance/backup.html

```
DB_PASSWORD=...

NOW=$(date +"%Y-%m-%d")

DB_SERVER=localhost
DB_NAME=nextcloud
DB_USER=nextcloud
mkdir -p /tmp/BAK/nextcloud-$NOW
mysqldump --single-transaction --default-character-set=utf8mb4 -h "$DB_SERVER" -u "$DB_USER" -p$DB_PASSWORD "$DB_NAME" > /tmp/BAK/nextcloud-`date +"%Y-%m-%d"`/nextcloud-sqldump.sql
```

```
cd /var/www/nextcloud
sudo sudo -u www-data php occ maintenance:mode --on

  Maintenance mode enabled
```

```
sudo tar cvzf /tmp/BAK/nextcloud-`date +"%Y-%m-%d"`/nextcloud-config-`date +"%Y-%m-%d"`.tgz -C /var/www/nextcloud config
sudo tar cvzf /tmp/BAK/nextcloud-`date +"%Y-%m-%d"`/nextcloud-themes-`date +"%Y-%m-%d"`.tgz -C /var/www/nextcloud themes
sudo tar cvzf /tmp/BAK/nextcloud-`date +"%Y-%m-%d"`/nextcloud-data-`date +"%Y-%m-%d"`.tgz -C /home data
```

### create one upload-file for backup

```
tar cvzf /tmp/BAK/nextcloud-$NOW.tgz -C /tmp/BAK nextcloud-$NOW 
rm -rf /tmp/BAK/nextcloud-$NOW
```

## restore

https://docs.nextcloud.com/server/latest/admin_manual/maintenance/restore.html

```
DB_PASSWORD=...
DB_SERVER=localhost
DB_NAME=nextcloud
DB_USER=nextcloud
mysql -h "$DB_SERVER" -u "$DB_USER" -p$DB_PASSWORD -e "DROP DATABASE $DB_NAME"
mysql -h "$DB_SERVER" -u "$DB_USER" -p$DB_PASSWORD -e "CREATE DATABASE $DB_NAME"

mysql -h "$DB_SERVER" -u "$DB_USER" -p$DB_PASSWORD "$DB_NAME" < uploads/nextcloud-2023-11-11/nextcloud-sqldump.sql

sudo rm -rf /var/www/nextcloud/config/
sudo rm -rf /var/www/nextcloud/themes/
sudo rm -rf /home/data/

sudo tar xvzf ~/uploads/nextcloud-2023-11-11/nextcloud-config-2023-11-11.tgz -C /var/www/nextcloud
sudo tar xvzf ~/uploads/nextcloud-2023-11-11/nextcloud-themes-2023-11-11.tgz -C /var/www/nextcloud
sudo tar xvzf ~/uploads/nextcloud-2023-11-11/nextcloud-data-2023-11-11.tgz -C /home
```

## Switch off maintenance mode

```
cd /var/www/nextcloud
sudo sudo -u www-data php occ maintenance:mode --off

  Maintenance mode disabled
```


# Push Backups

```
sudo apt install openjdk-17-jre-headless
```