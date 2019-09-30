#!/usr/bin/env bash

set -o errexit

FLAGGER_VER="0.18.4"
export KUBECONFIG="$(kind get kubeconfig-path)"

if [[ "$1" = "linkerd" ]]; then
  echo ">>> Installing Flagger for $1"
  kubectl apply -k github.com/weaveworks/flagger//kustomize/linkerd?ref=${FLAGGER_VER}
  kubectl -n linkerd rollout status deployment/flagger
  exit 0
fi

if [[ "$1" = "istio" ]]; then
  echo ">>> Installing Flagger for $1"
  kubectl apply -k github.com/weaveworks/flagger//kustomize/istio?ref=${FLAGGER_VER}
  kubectl -n istio-system rollout status deployment/flagger
  exit 0
fi

echo ">>> Installing Flagger for Kubernetes"
kubectl apply -k github.com/weaveworks/flagger//kustomize/kubernetes?ref=${FLAGGER_VER}
kubectl -n flagger-system rollout status deployment/flagger
kubectl -n flagger-system rollout status deployment/flagger-prometheus