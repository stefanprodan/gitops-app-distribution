# gitops-multi-cluster

## Clusters

Microservices:
* [frontend](clusters/base/frontend) deployment, hpa, canary
* [backend](clusters/base/backend) deployment, hpa, canary
* [cache](clusters/base/cache) deployment, hpa, canary
* [database](clusters/base/database) deployment, hpa, canary
* [tester](clusters/base/tester) deployment, ClusterIP service
* [ingress](clusters/base/ingress) deployment, LoadBalancer service

### Kuberentes dev

Canary releases (conformance and load testing)
* [frontend](clusters/dev/frontend) blue/green strategy 
* [backend](clusters/dev/backend) blue/green strategy
* [cache](clusters/dev/cache) blue/green strategy
* [database](clusters/dev/database) blue/green strategy

### Istio dev

Canary releases (conformance and load testing)
* [frontend](clusters/dev-istio/frontend) A/B testing strategy
* [backend](clusters/dev-istio/backend) progressive traffic strategy
* [cache](clusters/dev-istio/cache) blue/green strategy
* [database](clusters/dev-istio/database) traffic mirroring strategy

### Linkerd dev

Canary releases (conformance and load testing)
* [frontend](clusters/dev-linkerd/frontend) progressive traffic strategy
* [backend](clusters/dev-linkerd/backend) progressive traffic strategy
* [cache](clusters/dev-linkerd/cache) blue/green strategy
* [database](clusters/dev-linkerd/database) blue/green strategy

## End-to-end testing

The e2e testing is powered by GitHub Actions and Kubernetes Kind.

[Workflow](.github/workflows/main.yml)
* validate manifests with kustomize build and kubeval
* provision Kubernetes Kind cluster
* install Linkerd and Istio
* install Flagger
* apply manifests on the cluster
* test the workloads initialization
* test communication between microservices

