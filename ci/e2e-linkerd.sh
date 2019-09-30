#!/usr/bin/env bash

set -o errexit

LINKERD_VER="stable-2.4.0"
export KUBECONFIG="$(kind get kubeconfig-path)"

echo ">>> Downloading Linkerd ${LINKERD_VER}"
wget -q https://github.com/linkerd/linkerd2/releases/download/${LINKERD_VER}/linkerd2-cli-${LINKERD_VER}-linux
mv linkerd2-cli-${LINKERD_VER}-linux linkerd
chmod +x linkerd
sudo mv linkerd /usr/local/bin

echo ">>> Installing Linkerd"
linkerd install | kubectl apply -f -
linkerd check


