#!/usr/bin/env bash

set -o errexit

export KUBECONFIG="$(kind get kubeconfig-path)"

env=app-kubernetes
namespace=app
ENV=${1:-$env}
NS=${2:-$namespace}

echo ">>> Apply state"
kubectl apply -k dist/${ENV}

function onexit()
{
  echo ">>> Test logs"
  kubectl -n ${NS} logs job/e2e-test

  echo ">>> List pods"
  kubectl -n ${NS} get pods

  echo ">>> List canaries"
  kubectl -n ${NS} get canaries
}
trap onexit EXIT

echo ">>> Wait for ingress to start"
kubectl -n ${NS} rollout status deployment/ingress

echo ">>> Wait for tester to start"
kubectl -n ${NS} rollout status deployment/tester

echo ">>> Check primary workloads"
for WORKLOAD in frontend backend cache database
do
	kubectl -n ${NS} rollout status deployment/${WORKLOAD}-primary --timeout=2m
done

echo ">>> Check canaries status"
for WORKLOAD in frontend backend cache database
do
  kubectl -n ${NS} wait canary/${WORKLOAD} --for=condition=promoted
done

echo ">>> Test connectivity"
kubectl -n ${NS} create job --from=cronjob/traffic-tester e2e-test
kubectl -n ${NS} wait --for=condition=complete job/e2e-test
