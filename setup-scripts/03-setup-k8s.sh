#!/bin/bash

# from: https://blog.radwell.codes/2022/07/single-node-kubernetes-cluster-via-kubeadm-on-ubuntu-22-04/

set -xev


KUB_DEB_VER=1.31
K8S_VERSION=1.31.7
# apt-cache policy kubeadm
KUBEADM_VERSION=1.31.7-1.1    
# apt-cache policy critools
CRITOOLS_VERSION=1.31.1-1.1

CONTAINERD_VERSION=2.0.3
CNIPLUGIN_VERSION=1.6.2


# https://kind.sigs.k8s.io/docs/user/known-issues/
# increase number of watchers (kubectl logs .. -f)
# original values:
# fs.inotify.max_user_instances = 128
# fs.inotify.max_user_watches = 234227
sudo sysctl fs.inotify.max_user_watches=524288
sudo sysctl fs.inotify.max_user_instances=512
echo fs.inotify.max_user_watches = 524288 | sudo tee -a /etc/sysctl.conf > /dev/null
echo fs.inotify.max_user_instances = 512 | sudo tee -a /etc/sysctl.conf > /dev/null

cd ~

# Install general dependencies

sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl

# Install containerd
## config
curl -fsSLo containerd-config.toml https://gist.githubusercontent.com/oradwell/31ef858de3ca43addef68ff971f459c2/raw/5099df007eb717a11825c3890a0517892fa12dbf/containerd-config.toml
sudo mkdir -p /etc/containerd
sudo mv containerd-config.toml /etc/containerd/config.toml

curl -fsSLo containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz https://github.com/containerd/containerd/releases/download/v$CONTAINERD_VERSION/containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz
## Extract the binaries
sudo tar Cxzvf /usr/local containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz

## Install containerd as a service
sudo curl -fsSLo /etc/systemd/system/containerd.service https://raw.githubusercontent.com/containerd/containerd/main/containerd.service

sudo systemctl daemon-reload
sudo systemctl enable --now containerd

## install runc

#curl -fsSLo runc.amd64 https://github.com/opencontainers/runc/releases/download/v1.1.3/runc.amd64
curl -fsSLo runc.amd64 https://github.com/opencontainers/runc/releases/download/v1.1.15/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc

## Install CNI network plugins

curl -fsSLo cni-plugins-linux-amd64-v$CNIPLUGIN_VERSION.tgz https://github.com/containernetworking/plugins/releases/download/v$CNIPLUGIN_VERSION/cni-plugins-linux-amd64-v$CNIPLUGIN_VERSION.tgz
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v$CNIPLUGIN_VERSION.tgz

## Forward IPv4 and let iptables see bridged network traffic

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe -a overlay br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Install kubeadm, kubelet & kubectl

# Add Kubernetes GPG key
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# Add Kubernetes apt repository
# OLD: echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$KUB_DEB_VER/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v$KUB_DEB_VER/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Fetch package list
sudo apt-get update

## this may take a while
sudo apt-get install -y kubelet=$KUBEADM_VERSION kubeadm=$KUBEADM_VERSION kubectl=$KUBEADM_VERSION cri-tools=$CRITOOLS_VERSION

# Prevent them from being updated automatically
sudo apt-mark hold kubelet kubeadm kubectl


## Ensure swap is disabled
# See if swap is enabled
swapon --show

# Turn off swap
sudo swapoff -a

# Disable swap completely
sudo sed -i -e '/swap/d' /etc/fstab

## Create the cluster using kubeadm

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --kubernetes-version="$K8S_VERSION"

# setup kubectl

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# allow master/control-plane node to run workloads

kubectl taint nodes --all node-role.kubernetes.io/control-plane-
# before k8s 1.26: 
#kubectl taint nodes --all node-role.kubernetes.io/master-

# Install a CNI plugin

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

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
