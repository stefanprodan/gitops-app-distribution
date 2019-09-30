# gitops-multi-cluster

## Clusters

### Kuberentes dev

Canary releases
* [frontend](clusters/dev/frontend) blue/green strategy (conformance and load testing)
* [backend](clusters/dev/backend) blue/green strategy (conformance and load testing)
* [cache](clusters/dev/cache) blue/green strategy (conformance and load testing)
* [database](clusters/dev/database) blue/green strategy (conformance and load testing)

### Istio dev

Canary releases
* [frontend](clusters/dev-istio/frontend) A/B testing strategy (conformance and load testing)
* [backend](clusters/dev-istio/backend) progressive traffic strategy (conformance and load testing)
* [cache](clusters/dev-istio/cache) blue/green strategy (conformance and load testing)
* [database](clusters/dev-istio/database) traffic mirroring strategy (conformance and load testing)

### Linkerd dev

Canary releases
* [frontend](clusters/dev-linkerd/frontend) progressive traffic strategy (conformance and load testing)
* [backend](clusters/dev-linkerd/backend) progressive traffic strategy (conformance and load testing)
* [cache](clusters/dev-linkerd/cache) blue/green strategy (conformance and load testing)
* [database](clusters/dev-linkerd/database) blue/green strategy (conformance and load testing)

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

