# install nginx

``` 
sudo apt update
sudo apt install -y nginx ufw

sudo cp -f nginx.conf /etc/nginx/nginx.conf
sudo service nginx reload

sudo ufw allow 'OpenSSH'
sudo ufw allow 'Nginx Full'
sudo service ufw start
echo "y" | sudo ufw enable
sudo ufw reload
``` 

 