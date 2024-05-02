#!/bin/sh

set -xev
cd $(dirname -- $0)


sudo mkdir -p /etc/nginx/certs
rm -f /etc/nginx/certs/fullchain.pem || true
sudo cp -f ~/fullchain.pem /etc/nginx/certs/fullchain.pem
rm -f /etc/nginx/certs/privkey.pem || true
sudo cp -f ~/privkey.pem /etc/nginx/certs/privkey.pem
sudo chmod 444 /etc/nginx/certs/*.pem

sudo apt update
sudo apt install -y nginx ufw

export INGRESS_IP=$(kubectl -n  istio-ingress get service  istio-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
sudo chmod 666 /etc/nginx/nginx.conf || true
cat 30-host-nginx/nginx.conf | sudo sed -e "s/[$]{INGRESS_IP}/$INGRESS_IP/g" > /etc/nginx/nginx.conf
sudo chmod 444 /etc/nginx/nginx.conf || true

sudo service nginx reload

### deactivate to avoid keycloak to hang
#sudo ufw allow 'OpenSSH'
#sudo ufw allow 'Nginx Full'
#sudo ufw allow 6443
#sudo service ufw start
#echo "y" | sudo ufw enable
#sudo ufw reload
