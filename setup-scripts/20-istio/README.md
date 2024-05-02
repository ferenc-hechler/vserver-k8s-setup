# Istio Gateways

## *.cluster2.de gateway

```
helm upgrade --install c2gateway --namespace istio-system helm-charts\c2gateway
```

# install demoapp

```
helm upgrade --install demoapp --namespace demoapp --create-namespace helm-charts\demoapp
```