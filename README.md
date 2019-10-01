# gitops-app-distribution

As a software vendor I want to distribute my application in a reliable manner to service providers
that will host the app on their own Kubernetes clusters e.g. EKS, AKS/Linkerd, GKE/Istio.
The application is composed of several containerized micro-services: [frontend](dist/base/frontend),
[backend](dist/base/backend), [cache](dist/base/cache) and [database](dist/base/database).

Each micro-service receives periodically updates via container image releases and configuration changes.
These updates should be tested in isolation with automated e2e testing. 
Once the updates are made available to service providers, the release on production clusters
should be gated by conformance tests.

In order to ensure that the service providers SLAs are not being broken by new releases,
the release process will expose the micro-service new version to live traffic in a progressive manner,
while measuring the service level objectives (SLOs) like availability, error rate percentage and average response time.
If a drop in performance is noticed during the SLOs analysis, the release will be automatically rolled back
with minimum impact to end-users.

Technical solution:
* create a repository with the manifests required to distribute the app on Kubernetes
* create a dedicated distribution for each service provider environment type
    * [Kubernetes without a service mesh](dist/app-kubernetes/README.md)
    * [Kubernetes with Istio](dist/app-istio/README.md)
    * [Kubernetes with Linkerd](dist/app-linkerd/README.md)
* use kustomize to build each environment type (distribution) while keeping the YAML duplication at minimum
* use GitHub Actions and Kubernetes Kind to validate changes in all three environments
    * validate manifests with kubeval
    * deploy each distribution on Kubernetes Kind
    * end-to-end testing for Kubernetes, Istio and Linkerd distributions
* use Flux to distribute changes on the service providers clusters
* use Flagger to automate the production releases on the service providers clusters
    * run conformance tests before exposing a micro-service to live traffic
    * run canary style deployments with progressive traffic shifting for _frontend_ and _backend_ micro-services
    * run blue/green style deployments for _cache_ and _database_ micro-services

