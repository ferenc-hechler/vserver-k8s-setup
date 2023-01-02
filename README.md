# vserver-k8s-setup
Scripts for setting up a Kubernetes cluster with applications from a new ubuntu 20.04 image.

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

