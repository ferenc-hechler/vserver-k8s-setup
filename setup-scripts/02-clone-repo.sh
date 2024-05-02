#!/bin/bash

set -xev

# Install general dependencies

sudo apt-get update -y
sudo apt-get install -y git git-crypt

mkdir -p ~/git
cd ~/git

git clone --branch vps2 https://github.com/ferenc-hechler/vserver-k8s-setup.git
