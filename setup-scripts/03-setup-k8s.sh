#!/bin/bash

set -xev

export K8S_VERSION=v1.36
export MY_IP=$(hostname -I | awk '{print $1}')

echo "K8S_VERSION=$K8S_VERSION"
echo "MY_IP=$MY_IP"


# from https://linuxize.com/post/how-to-install-kubernetes-with-kubeadm-on-ubuntu-26-04/


# https://kind.sigs.k8s.io/docs/user/known-issues/
# increase number of watchers (kubectl logs .. -f)
# original values:
# fs.inotify.max_user_instances = 128
# fs.inotify.max_user_watches = 234227
sudo sysctl fs.inotify.max_user_watches=524288
sudo sysctl fs.inotify.max_user_instances=512
echo fs.inotify.max_user_watches = 524288 | sudo tee -a /etc/sysctl.conf > /dev/null
echo fs.inotify.max_user_instances = 512 | sudo tee -a /etc/sysctl.conf > /dev/null


# Schritt 1: Grundlegende Vorbereitungen (Auf allen Nodes)

## Swap deaktivieren:

sudo swapoff -a
sudo sed -i '/\sswap\s/ s/^/#/' /etc/fstab


## Erforderliche Kernel-Module laden:

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter


## Sysctl-Parameter für das Netzwerk einrichten:

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system



# Schritt 2: Container Runtime installieren (containerd)

## Containerd installieren:

sudo apt update
sudo apt install -y containerd


## Standardkonfiguration generieren und anpassen:

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd



# Schritt 3: Kubernetes Tools installieren (kubeadm, kubelet, kubectl)

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# GPG-Key erstellen und Repository einbinden (Beispiel für eine stabile Version)
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/$K8S_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$K8S_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Pakete installieren und sperren, damit sie nicht automatisch via apt upgrade überschrieben werden
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl



# Schritt 4: Control Plane (Master-Node) initialisieren

## Kubeadm initialisieren:

# CIDR für das Pod-Netzwerk (z.B. Flannel) angeben, damit die Pods im Cluster kommunizieren können
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$MY_IP


## kubectl für Ihren Benutzer konfigurieren:

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# Schritt 5: Container Network Interface (CNI) installieren

kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml


kubectl get pods -A



# Optional: Single-Node Beschränkung aufheben (für Test-VPS)

kubectl taint nodes --all node-role.kubernetes.io/control-plane-



# further installations

# install helm

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash


# Add openebs repo to helm
helm repo add openebs https://openebs.github.io/charts

kubectl create namespace openebs

helm --namespace=openebs install openebs openebs/openebs

# define a default storageclass:
kubectl patch storageclass openebs-hostpath -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'


# install socat for routing http/https ports 
sudo apt-get install -y socat


