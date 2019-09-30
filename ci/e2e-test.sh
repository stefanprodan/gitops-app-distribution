#!/usr/bin/env bash

set -o errexit

export KUBECONFIG="$(kind get kubeconfig-path)"
ENV=$1

echo ">>> Apply state"
kubectl apply -k clusters/${ENV}

function onexit()
{
  echo ">>> Test logs"
  kubectl -n ${ENV} logs job/e2e-test

  echo ">>> List pods"
  kubectl -n ${ENV} get pods

  echo ">>> List canaries"
  kubectl -n ${ENV} get canaries
}
trap onexit EXIT

echo ">>> Wait for ingress to start"
kubectl -n ${ENV} rollout status deployment/ingress

echo ">>> Wait for tester to start"
kubectl -n ${ENV} rollout status deployment/tester

echo ">>> Check primary workloads"
for WORKLOAD in frontend backend cache database
do
	kubectl -n ${ENV} rollout status deployment/${WORKLOAD}-primary --timeout=2m
done

echo ">>> Check canaries status"
for WORKLOAD in frontend backend cache database
do
  kubectl -n ${ENV} wait canary/${WORKLOAD} --for=condition=promoted
done

echo ">>> Test connectivity"
kubectl -n ${ENV} create job --from=cronjob/traffic-tester e2e-test
kubectl -n ${ENV} wait --for=condition=complete job/e2e-test
