# vserver-k8s-setup
Scripts for setting up a Kubernetes cluster with applications from a new ubuntu 22.04 image.

# secrets 

Secrets are encrypted using  [git-crypt](https://github.com/AGWA/git-crypt/).
After cloning the repo, these secrets can be unlocked using an authorized PGP key:

```
git-crypt unlock
```

# Kubectl change Default Namespace

```
kubectl config set-context --current --namespace=<defaultnamespace>
```


# wildcard certificate

```
sudo certbot certonly -d *.k8s2.feri.ai --manual -m ferenc.hechler@gmail.com --agree-tos --preferred-challenges=dns
```

after entering the given value in the nameserver as "TXT" id did not appear in 
https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.k8s2.feri.ai

after 3 minutes it appeared.

```
Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/k8s2.feri.ai/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/k8s2.feri.ai/privkey.pem
This certificate expires on 2023-04-12.
```

Install in Cluster

```
kubectl create secret -n istio-system tls wc-k8s2-feri-ai-tls --key="privkey.pem" --cert="fullchain.pem"
```

patch istio gateway

```
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: k8s2-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway
  servers:
  - hosts:
    - '*.k8s2.feri.ai'
    port:
      name: http
      number: 80
      protocol: HTTP
  - hosts:
    - '*.k8s2.feri.ai'
    port:
      name: https
      number: 443
      protocol: HTTPS
    tls:
      credentialName: wc-k8s2-feri-ai-tls
      mode: SIMPLE
```


