#!/usr/bin/env bash

set -o errexit

ENV=$1

echo ">>> Downloading kubectl"
KUBECTL_VER=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
sudo curl -sL https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VER}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
sudo chmod +x /usr/local/bin/kubectl

echo ">>> Downloading kubeval"
wget -q https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz
tar xf kubeval-linux-amd64.tar.gz
sudo mv kubeval /usr/local/bin

echo ">>> Validate kustomize build"
kubectl kustomize ${ENV} | kubeval --strict --ignore-missing-schemas
