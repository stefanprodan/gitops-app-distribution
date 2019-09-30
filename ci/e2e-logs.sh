#!/usr/bin/env bash

set -o errexit

export KUBECONFIG="$(kind get kubeconfig-path)"

kubectl describe nodes

if [[ "$1" = "linkerd" ]]; then
  kubectl -n linkerd logs deployment/flagger || true
  exit 0
fi

if [[ "$1" = "istio" ]]; then
  kubectl -n istio-system logs deployment/flagger || true
  exit 0
fi

kubectl -n flagger-system logs deployment/flagger || true


