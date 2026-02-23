# Gateway API Implementations

!!! info "Last updated"
    This document and the table below were last updated on **2026-02-23**. Implementation statuses, GitHub stars, and contributor counts change frequently — verify against the [official implementations page](https://gateway-api.sigs.k8s.io/implementations/) for the latest status.

## Requirements

For inclusion in this documentation, Gateway API implementations must meet the following criteria:

1. **Open Source**: The implementation must be open source software
2. **Official Listing**: Must be listed on the official [Gateway API implementations page](https://gateway-api.sigs.k8s.io/implementations/)

## Available Open Source Implementations

| Implementation                                                                                                    | Status        | Type  | GitHub Stars | Contributors | Description                                                          |
|-------------------------------------------------------------------------------------------------------------------|---------------|-------|--------------|--------------|----------------------------------------------------------------------|
| [Envoy Gateway](https://github.com/envoyproxy/gateway)                                                           | ✅ GA          | Envoy | 2.5k         | 308+         | CNCF Graduated Envoy subproject, latest: v1.7.0                      |
| [Istio](https://github.com/istio/istio)                                                                           | ✅ GA          | Envoy | 37.3k        | 1,147        | CNCF Graduated service mesh                                          |
| [kgateway](https://github.com/kgateway-dev/kgateway)                                                             | ✅ GA          | Envoy | 5.3k         | 243          | CNCF Sandbox AI-powered API Gateway (formerly Gloo)                  |
| [Cilium](https://github.com/cilium/cilium)                                                                        | ✅ Conformant  | eBPF  | 23.8k        | 955+         | CNCF Graduated eBPF-based networking, sidecarless mesh support       |
| [NGINX Gateway Fabric](https://github.com/nginx/nginx-gateway-fabric)                                            | ✅ GA          | NGINX | 674          | 56           | Open source NGINX implementation                                     |
| [Traefik Proxy](https://github.com/traefik/traefik)                                                              | ✅ GA          | Other | 56.8k        | 891          | Open source cloud-native application proxy                           |
| [Linkerd](https://github.com/linkerd/linkerd2)                                                                    | ✅ SM          | Other | 11.1k        | 375+         | CNCF Graduated service mesh (service mesh conformance)               |
| [Contour](https://github.com/projectcontour/contour)                                                             | 🟡 Partial     | Envoy | 3.8k         | 226          | CNCF Incubating Envoy-based ingress controller                       |
| [AWS Load Balancer Controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller)                  | 🟡 Partial     | Other | 4.3k         | 251          | Provisions ALB/NLB on AWS; Gateway API support added in v3.0 (2026)  |
| [Emissary-Ingress](https://github.com/emissary-ingress/emissary)                                                 | 🔴 Stale       | Envoy | 4.5k         | 215          | CNCF Incubating project, no recent conformance reports               |
| [Apache APISIX](https://github.com/apache/apisix)                                                                | 🔴 Stale       | Other | 15.7k        | 480          | Apache Foundation API Gateway, no recent conformance reports         |
| [Easegress](https://github.com/easegress-io/easegress)                                                           | 🔴 Stale       | Other | 5.9k         | 65+          | CNCF Sandbox Cloud Native traffic orchestration                      |
| [Flomesh Service Mesh](https://github.com/flomesh-io/fsm)                                                        | 🔴 Stale       | Other | 66           | 9+           | Community driven lightweight service mesh                            |
| [HAProxy Ingress](https://github.com/haproxytech/kubernetes-ingress)                                             | 🔴 Stale       | Other | 791          | 50+          | Community driven ingress controller, no recent conformance reports   |
| [Kuma](https://github.com/kumahq/kuma)                                                                            | 🔴 Stale       | Other | 3.9k         | 114          | CNCF Sandbox service mesh, no recent conformance reports             |
| [LoxiLB](https://github.com/loxilb-io/loxilb)                                                                    | 🔴 Stale       | Other | 1.8k         | 20+          | Open source load balancer                                            |
| [WSO2 APK](https://github.com/wso2/apk)                                                                          | 🔴 Stale       | Other | 166          | 30+          | Open source API management solution                                  |
| [ingate](https://github.com/kubernetes-sigs/ingate)                                                              | ⚠️ Retiring    | Other | 685          | Multiple     | Kubernetes SIG Network reference impl — retiring early 2026          |

> **Status Legend**:
> ✅ GA = Generally Available, fully conformant |
> ✅ Conformant = Passes full conformance tests (no GA label) |
> ✅ SM = Service mesh conformance only |
> 🟡 Partial = Partially conformant (passes some but not all conformance tests) |
> 🔴 Stale = No recent conformance reports submitted to the official registry |
> ⚠️ Retiring = Deprecated / being retired
>
> **Notes**:
>
> * **ingate** was a migration path from NGINX Ingress Controller to Gateway API — SIG Network recommends migrating away immediately
> * **GitHub Stars** are approximate and were last checked on 2026-02-23
> * Status is based on the [official conformance registry](https://gateway-api.sigs.k8s.io/implementations/)

### Deprecated/Legacy Implementations

* **Acnodal EPIC** Open Source External Gateway platform
  * *GitHub*: [epic-gateway/resource-model](https://github.com/epic-gateway/resource-model) | ⭐ 0 | 👥 2 contributors
* **Airlock Microgateway** Open source WAAP solution
  * *GitHub*: [airlock/microgateway](https://github.com/airlock/microgateway) | ⭐ 18 | 👥 3-5 contributors

## Commercial/Proprietary Implementations

The following commercial or proprietary Gateway API implementations are officially listed:

* **LiteSpeed Ingress Controller** Commercial web ADC controller with Gateway API support
* **Tyk Gateway** Cloud-native API Gateway working towards Gateway API implementation

## Cloud Provider Implementations

Cloud providers offer managed Gateway API implementations:

### Amazon Web Services (AWS)

* **AWS Load Balancer Controller** Partially conformant — provisions ALB/NLB with Gateway API support (added in v3.0, January 2026). See main table above.
* **AWS Gateway API Controller** Integrates with Amazon VPC Lattice for EKS clusters

### Microsoft Azure

* **Azure Application Gateway for Containers** Managed application load balancing solution

### Google Cloud Platform (GCP)

* **GKE Gateway API Controller** Integrates with Google Cloud Load Balancers
* **Google Cloud Service Mesh** Supports Envoy-based and Proxyless-GRPC mesh implementations
