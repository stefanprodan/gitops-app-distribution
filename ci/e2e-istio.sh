#!/usr/bin/env bash

set -o errexit

ISTIO_VER="1.3.1"
export KUBECONFIG="$(kind get kubeconfig-path)"

function onexit()
{
  kubectl -n istio-system get pods
}
trap onexit EXIT

echo ">>> Installing Helm"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

echo '>>> Installing Tiller'
kubectl --namespace kube-system create sa tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --upgrade --wait

echo ">>> Installing Istio ${ISTIO_VER}"
helm repo add istio.io https://storage.googleapis.com/istio-release/releases/${ISTIO_VER}/charts

echo '>>> Installing Istio CRDs'
helm upgrade -i istio-init istio.io/istio-init --wait --namespace istio-system

echo '>>> Waiting for Istio CRDs to be ready'
kubectl -n istio-system wait --timeout=2m --for=condition=complete job/istio-init-crd-10-${ISTIO_VER}
kubectl -n istio-system wait --timeout=2m --for=condition=complete job/istio-init-crd-11-${ISTIO_VER}
kubectl -n istio-system wait --timeout=2m --for=condition=complete job/istio-init-crd-12-${ISTIO_VER}

echo '>>> Installing Istio control plane'
cat <<EOF >> ${HOME}/e2e-istio-values.yaml
global:
  useMCP: false
  defaultPodDisruptionBudget:
    enabled: false
  hub: gcr.io/istio-release
  tag: release-1.3-20190929-10-15
  proxy:
    resources:
      requests:
        cpu: 10m
        memory: 32Mi

pilot:
  enabled: true
  sidecar: true
  autoscaleEnabled: false
  resources:
    requests:
      cpu: 10m
      memory: 64Mi

mixer:
  policy:
    enabled: false
  telemetry:
    enabled: true
    autoscaleEnabled: false
    resources:
      requests:
        cpu: 10m
        memory: 64Mi
  resources:
    requests:
      cpu: 10m
      memory: 64Mi

prometheus:
  enabled: true
  scrapeInterval: 5s

sidecarInjectorWebhook:
  enabled: true

security:
  enabled: true
gateways:
  enabled: false
galley:
  enabled: false
tracing:
  enabled: false
EOF

helm upgrade -i istio istio.io/istio --wait --namespace istio-system -f ${HOME}/e2e-istio-values.yaml




