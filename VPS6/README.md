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
sudo add-apt-repository ppa:ondrej/php^
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

vi /etc/php/8.0/apache2/php.ini 

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

