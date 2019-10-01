# Kubernetes cluster

### Prerequisites

```sh
helm upgrade -i istio-init istio.io/istio-init --wait --namespace istio-system
helm upgrade -i istio istio.io/istio --wait --namespace istio-system

kubectl apply -k github.com/weaveworks/flagger//kustomize/istio
```

### App

Canary releases (conformance and load testing)
* [frontend](frontend) a/b testing strategy
* [backend](backend) progressive traffic strategy
* [cache](cache) blue/green strategy
* [database](database) traffic mirroring strategy

### End-to-end testing

The e2e testing is powered by GitHub Actions and Kubernetes Kind.

Workflow
* validate manifests with kustomize build and kubeval
* provision Kubernetes Kind cluster
* install Istio
* install Flagger
* apply manifests on the cluster
* test the workloads initialization
* test communication between microservices
