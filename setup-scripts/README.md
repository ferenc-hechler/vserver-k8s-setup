# Setup Scripts

these scripts can be used to setup a kubernetes cluster on a fresh ubuntu 22.04 installation

# Step 1 - Create User

after starting with a fresh ubuntu 22.04 image create a user with sudo rights and ssh login.
Execute as root user:

```
curl -O https://raw.githubusercontent.com/ferenc-hechler/vserver-scripts/main/setup-scripts/01-create-user.sh
chmod u+x 01-create-user.sh
./create-user.sh ferenc
   <enter hidden password>

# cleanup
rm 01-create-user.sh
```

login as newly created user 

# Step 2 - Clone this Repo

```
curl https://raw.githubusercontent.com/ferenc-hechler/vserver-scripts/main/setup-scripts/02-clone-repo.sh | bash
```

# Step 3 - Setup Kubernetes

```
~/git/vserver-scripts/setup-scripts/03-setup-k8s.sh
```

## Use kubectl from local PC

To execute kubectl from a local PC the content of ~/.kube/config has to be copied to 
the local filesystem ~/.kube/config


# Step 4 - Ingress NginX

## 4-1 install ingress-nginx

```
~/git/vserver-scripts/setup-scripts/04-1-ingress-nginx.sh
```

## 4-2 forward default ports (sudo inside) 

```
~/git/vserver-scripts/setup-scripts/04-2-route-default-ports.sh
```


# Step 5 - Cert-Manager


```
~/git/vserver-scripts/setup-scripts/05-cert-manager.sh
```


# Step 6 - Prometheus + Grafana

https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack

```
~/git/vserver-scripts/setup-scripts/06-prometheus-grafana.sh
```

# Step 7 - Dashboard

```
~/git/vserver-scripts/setup-scripts/07-dashboard.sh
```

# Step 8 - MinIO

```
~/git/vserver-scripts/setup-scripts/08-minio.sh
```

# Applikationen

## Minecraft

```
~/git/vserver-scripts/setup-scripts/30-1-minecraft.sh
```

### setup routes from port 61267 to nodeport (uses sudo)  

```
~/git/vserver-scripts/setup-scripts/30-2-route-minecraft-port.sh
```

### World-Backup CronJob (needs git-crypt unlock)
  
```
~/git/vserver-scripts/setup-scripts/30-3-minecraft-backup.sh
```

### Manual World-Restore Job (needs git-crypt unlock)
  
```
# ~/git/vserver-scripts/setup-scripts/30-4-minecraft-restore.sh
```

## Nexus

```
~/git/vserver-scripts/setup-scripts/40-1-nexus.sh
```

### Nexus Backup CronJob (needs git-crypt unlock)
  
```
~/git/vserver-scripts/setup-scripts/40-2-nexus-backup.sh
```

### Manual Nexus-Restore Job (needs git-crypt unlock)
  
```
# ~/git/vserver-scripts/setup-scripts/40-3-nexus-restore.sh
```



