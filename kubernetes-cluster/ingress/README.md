# Ingress

## tcp

https://medium.com/@ahmedwaleedmalik/exposing-tcp-and-udp-services-in-kubernetes-using-nginx-ingress-9b8fd639c576


## nginx

https://devopscube.com/setup-ingress-kubernetes-nginx-controller/

## nginx k8s controller

https://github.com/kubernetes/ingress-nginx

* https://github.com/scriptcamp/nginx-ingress-controller


```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.1/deploy/static/provider/cloud/deploy.yaml
```

## ingress demo

```
cd demoapp
kubectl create namespace dev
kubectl apply -f hello-app-deployment.yaml
kubectl apply -f hello-app-service.yaml
kubectl apply -f hello-app-ingress.yaml
```
### port forwarding

```
kubectl --namespace ingress-nginx get services -o wide -w ingress-nginx-controller

NAME                       TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE   SELECTOR
ingress-nginx-controller   LoadBalancer   10.102.173.136   <pending>     80:31517/TCP,443:31406/TCP   23m   app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
```

```
sudo nohup socat TCP-LISTEN:80,fork TCP:89.117.56.30:31517 &
sudo nohup socat TCP-LISTEN:443,fork TCP:89.117.56.30:31406 &
```


# Let´s Encrypt

https://getbetterdevops.io/k8s-ingress-with-letsencrypt/


