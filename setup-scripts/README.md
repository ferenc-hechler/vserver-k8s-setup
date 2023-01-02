# Setup Scripts

these scripts can be used to setup a kubernetes cluster on a fresh ubuntu 22.04 installation

# Step 1 - Create User

after starting with a fresh ubuntu 22.04 image create a user with sudo rights and ssh login.
Execute as root user:

Important: the script contains my public SSH key to allow login with ssh. You should 
replace the value in `echo "ssh-ed25519 AAAAC3Nza...` with your public key.

```
curl -O https://raw.githubusercontent.com/ferenc-hechler/vserver-k8s-setup/main/setup-scripts/01-create-user.sh
source 01-create-user.sh ferenc
   <enter hidden password>

# cleanup
rm 01-create-user.sh
```

login as newly created user 

# Step 2 - Clone this Repo

```
curl https://raw.githubusercontent.com/ferenc-hechler/vserver-k8s-setup/main/setup-scripts/02-clone-repo.sh | bash
```

# All following steps (except backup & restore) 

The steps can be executed each or all together with the following command:

```
~/git/vserver-k8s-setup/setup-scripts/xx-run-all-scripts.sh
```


# Step 3 - Setup Kubernetes

```
~/git/vserver-k8s-setup/setup-scripts/03-setup-k8s.sh
```

## Use kubectl from local PC

To execute kubectl from a local PC the content of ~/.kube/config has to be copied to 
the local filesystem ~/.kube/config


# Step 4 - Ingress NginX

## 4-1 install ingress-nginx

```
~/git/vserver-k8s-setup/setup-scripts/04-1-ingress-nginx.sh
```

## 4-2 forward default ports (sudo inside) 

```
~/git/vserver-k8s-setup/setup-scripts/04-2-route-default-ports.sh
```


# Step 5 - Cert-Manager


```
~/git/vserver-k8s-setup/setup-scripts/05-cert-manager.sh
```


# Step 6 - Prometheus + Grafana

https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack

```
~/git/vserver-k8s-setup/setup-scripts/06-prometheus-grafana.sh
```

# Step 7 - Dashboard

```
~/git/vserver-k8s-setup/setup-scripts/07-dashboard.sh
```

# Step 8 - MinIO

Infos

* Quickstart https://min.io/docs/minio/kubernetes/upstream/
* Example Deployment https://raw.githubusercontent.com/minio/docs/master/source/extra/examples/minio-dev.yaml
* usage in velero https://github.com/vmware-tanzu/velero/blob/main/examples/minio/00-minio-deployment.yaml

## Problems in GUI uploading files > 1MB

* https://github.com/minio/minio/issues/8538#issuecomment-586445269
* https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/#custom-max-body-size



```
~/git/vserver-k8s-setup/setup-scripts/08-minio.sh
```

# Applikationen

## Minecraft

```
~/git/vserver-k8s-setup/setup-scripts/30-1-minecraft.sh
```

### setup routes from port 61267 to nodeport (uses sudo)  

```
~/git/vserver-k8s-setup/setup-scripts/30-2-route-minecraft-port.sh
```

### World-Backup CronJob (needs git-crypt unlock)
  
```
~/git/vserver-k8s-setup/setup-scripts/30-3-minecraft-backup.sh
```

### Manual World-Restore Job (needs git-crypt unlock)
  
```
# ~/git/vserver-k8s-setup/setup-scripts/30-4-minecraft-restore.sh
```

## Nexus

```
~/git/vserver-k8s-setup/setup-scripts/40-1-nexus.sh
```

### Nexus Backup CronJob (needs git-crypt unlock)
  
```
~/git/vserver-k8s-setup/setup-scripts/40-2-nexus-backup.sh
```

### Manual Nexus-Restore Job (needs git-crypt unlock)
  
```
# ~/git/vserver-k8s-setup/setup-scripts/40-3-nexus-restore.sh
```



