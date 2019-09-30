# gitops-multi-cluster

As a software vendor I want to distribute my application in a reliable manner to service providers
that will host the app on their own Kubernetes clusters e.g. EKS, AKS/Linkerd, GKE/Istio.
The application is composed of several micro-services: [frontend](clusters/base/frontend),
[backend](clusters/base/backend), [cache](clusters/base/cache) and [database](clusters/base/database).
Each micro-services receives periodically updates via container image releases and configuration changes.
These updates should be tested in isolation with automated e2e testing. 
Once the updates are made available to service providers,
the updates rollout should be gated by conformance tests and exposed to live traffic in a progressive manner,
while measuring the service level objectives (SLOs) like availability, error rate percentage and average response time.

### Kubernetes cluster

Prerequisites:
```sh
kubectl apply -k github.com/weaveworks/flagger//kustomize/kubernetes
```

Canary releases (conformance and load testing)
* [frontend](clusters/dev/frontend) blue/green strategy 
* [backend](clusters/dev/backend) blue/green strategy
* [cache](clusters/dev/cache) blue/green strategy
* [database](clusters/dev/database) blue/green strategy

### Istio cluster

Prerequisites:
```sh
helm upgrade -i istio-init istio.io/istio-init --wait --namespace istio-system
helm upgrade -i istio istio.io/istio --wait --namespace istio-system

kubectl apply -k github.com/weaveworks/flagger//kustomize/istio
```

Canary releases (conformance and load testing)
* [frontend](clusters/dev-istio/frontend) a/b testing strategy
* [backend](clusters/dev-istio/backend) progressive traffic strategy
* [cache](clusters/dev-istio/cache) blue/green strategy
* [database](clusters/dev-istio/database) traffic mirroring strategy

### Linkerd cluster

Prerequisites:
```sh
linkerd install | kubectl apply -f -

kubectl apply -k github.com/weaveworks/flagger//kustomize/linkerd
```

Canary releases (conformance and load testing)
* [frontend](clusters/dev-linkerd/frontend) progressive traffic strategy
* [backend](clusters/dev-linkerd/backend) progressive traffic strategy
* [cache](clusters/dev-linkerd/cache) blue/green strategy
* [database](clusters/dev-linkerd/database) blue/green strategy

### End-to-end testing

The e2e testing is powered by GitHub Actions and Kubernetes Kind.

[Workflow](.github/workflows/main.yml)
* validate manifests with kustomize build and kubeval
* provision Kubernetes Kind cluster
* install Linkerd and Istio
* install Flagger
* apply manifests on the cluster
* test the workloads initialization
* test communication between microservices

