# wildcard certificate

## Install certbot

```
sudo apt install certbot
```

## Request Wildcard Certificate

```
sudo certbot certonly -d *.vps4.cluster-1.de --manual -m ferenc.hechler@gmail.com --agree-tos --preferred-challenges=dns
```

## Add DNS record

after entering the given value for "_acme-challenge.vps4" in the nameserver as "TXT" id did not appear in 
https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.vps4.cluster-1.de

after 3 minutes it appeared.

continue the cert creation by pressing &lt;Enter&gt;

```
Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/vps4.cluster-1.de/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/vps4.cluster-1.de/privkey.pem
This certificate expires on 2023-05-29.
```

## Install TLS Secret 

```
kubectl create secret -n istio-system tls wc-vps4-cluster-1-de-tls --key="privkey.pem" --cert="fullchain.pem"
```

## Create Istio Gateway

```
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: vps4-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway
  servers:
  - hosts:
    - '*.vps4.cluster-1.de'
    port:
      name: http
      number: 80
      protocol: HTTP
  - hosts:
    - '*.vps4.cluster-1.de'
    port:
      name: https
      number: 443
      protocol: HTTPS
    tls:
      credentialName: wc-vps4-cluster-1-de-tls
      mode: SIMPLE
```

