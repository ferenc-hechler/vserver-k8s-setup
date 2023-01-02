# kubernetes-cluster scripts

these scripts can be used to setup a kubernetes cluster on a fresh ubuntu 22.04 installation

## usage

after starting with a fresh ubuntu 22.04 image create a user with sudo rights and ssh login.
Execute as root user:

```
curl -O https://raw.githubusercontent.com/ferenc-hechler/vserver-scripts/main/kubernetes-cluster/create-user.sh
chmod u+x create-user.sh
./create-user.sh ferenc
   <enter hidden password>

# cleanup
rm create-user.sh
```

login as newly created user and setup kubernetes:

```
curl https://raw.githubusercontent.com/ferenc-hechler/vserver-scripts/main/kubernetes-cluster/setup-k8s.sh | bash
```


## prometheus + grafana

https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install kube-prometheus-stack -n grafana prometheus-community/kube-prometheus-stack

kubectl get secrets -n grafana kube-prometheus-stack-grafana
admin/prom-operator
```



