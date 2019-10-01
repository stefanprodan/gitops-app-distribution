# Kubernetes cluster

### Prerequisites

```sh
kubectl apply -k github.com/weaveworks/flagger//kustomize/kubernetes
```

### App

Canary releases (conformance and load testing)
* [frontend](frontend) progressive traffic strategy
* [backend](backend) progressive traffic strategy
* [cache](cache) blue/green strategy
* [database](database) blue/green strategy

### End-to-end testing

The e2e testing is powered by GitHub Actions and Kubernetes Kind.

Workflow
* validate manifests with kustomize build and kubeval
* provision Kubernetes Kind cluster
* install Linkerd
* install Flagger
* apply manifests on the cluster
* test the workloads initialization
* test communication between microservices
