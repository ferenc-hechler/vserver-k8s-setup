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

