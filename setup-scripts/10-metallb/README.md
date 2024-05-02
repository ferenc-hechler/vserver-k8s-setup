# MetalLB

## Installation

see https://metallb.org/installation/

### set strictARP to true 


```
kubectl get configmap kube-proxy -n kube-system -o yaml | sed -e "s/strictARP: false/strictARP: true/" | kubectl apply -f - -n kube-system
```


### install using kubectl

```
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-native.yaml
```

## Configure MetalLB

https://kubernetes.github.io/ingress-nginx/deploy/baremetal/

### IP Adress Pool

```
kubectl apply -f ipadresspool.yaml
```

### L2 Advertisement

```
kubectl apply -f l2advertisement.yaml
```


