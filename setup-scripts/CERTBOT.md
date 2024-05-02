# Create Wildcard certificate using certbot

```
sudo apt install certbot
sudo certbot certonly --manual --preferred-challenges=dns --email ferenc.hechler@gmail.com --agree-tos -d *.k8s.cluster-1.de
sudo cp /etc/letsencrypt/live/k8s.cluster-1.de/fullchain.pem fullchain.pem
sudo cp /etc/letsencrypt/live/k8s.cluster-1.de/privkey.pem privkey.pem
sudo chown ferenc:users *.pem
kubectl create secret -n istio-ingress tls wc-k8s-tls --key="privkey.pem" --cert="fullchain.pem"
```
