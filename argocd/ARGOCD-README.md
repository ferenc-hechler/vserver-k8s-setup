# ArgoCD

## KUBECONFIG

```
set KUBECONFIG=%USERPROFILE%\.kube\config-vps2
kubectl config set-context --current --namespace=argocd
```

## installation

```
kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.3.4/manifests/install.yaml
```

## Ingress wird nicht healthy

Health status is set based on entry in status.loadBalancer. 
As this stay empty (nginx ingress controller does not add something) it never gets healthy.

Resolution:

Add custom health rule in argocd-cm (ConfigMap)

```
$ kubectl -n argocd edit configmap argocd-cm

...
data:
  resource.customizations.health.networking.k8s.io_Ingress: |
    hs = {}
    hs.status = "Healthy"
    hs.message = "Ingress health check ignores loadBalancer status"
    return hs
  ...
```

Alternative using patch:

```
kubectl -n argocd patch configmap argocd-cm --type merge -p "{\"data\":{\"resource.customizations.health.networking.k8s.io_Ingress\":\"hs = {}\nhs.status = \\\"Healthy\\\"\nreturn hs\n\"}}"
```

## Uninstall ArgoCD

### Delete Applications deployed by ArgoCD

```
kubectl get applications -A
kubectl delete application -n ...
```

### uninstall using yaml

```
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.3.4/manifests/install.yaml
```
