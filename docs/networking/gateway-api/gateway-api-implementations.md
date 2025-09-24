# Gateway API Implementations

## Requirements

For inclusion in this documentation, Gateway API implementations must meet the following criteria:

1. **Open Source**: The implementation must be open source software
2. **Official Listing**: Must be listed on the official [Gateway API implementations page](https://gateway-api.sigs.k8s.io/implementations/)

## Available Open Source Implementations

| Implementation | Status | Type | GitHub Stars | Contributors | Description |
|---|---|---|---|---|---|
| [Contour](https://github.com/projectcontour/contour) | ✅ | Envoy | 3.8k | 226 | CNCF Incubating Envoy-based ingress controller |
| [Emissary-Ingress](https://github.com/emissary-ingress/emissary) | 🔴 | Envoy | 4.5k | 215 | CNCF Incubating project (Alpha status) |
| [Envoy Gateway](https://github.com/envoyproxy/gateway) | ✅ | Envoy | 2.1k | 251 | CNCF Graduated Envoy subproject |
| [Istio](https://github.com/istio/istio) | ✅ | Envoy | 37.3k | 1,147 | CNCF Graduated service mesh |
| [kgateway](https://github.com/kgateway-dev/kgateway) | ✅ | Envoy | 4.9k | 219 | CNCF Sandbox AI-powered API Gateway (formerly Gloo) |
| [Cilium](https://github.com/cilium/cilium) | 🔴 | eBPF | 22.5k | 955+ | CNCF Graduated eBPF-based networking solution |
| [Apache APISIX](https://github.com/apache/apisix) | 🔴 | Other | 15.7k | 480 | Apache Foundation API Gateway |
| [Easegress](https://github.com/easegress-io/easegress) | ✅ | Other | 5.9k | 65+ | CNCF Sandbox Cloud Native traffic orchestration |
| [Flomesh Service Mesh](https://github.com/flomesh-io/fsm) | 🔴 | Other | 66 | 9+ | Community driven lightweight service mesh |
| [HAProxy Ingress](https://github.com/haproxytech/kubernetes-ingress) | ✅ | Other | 791 | 50+ | Community driven ingress controller |
| [ingate](https://github.com/kubernetes-sigs/ingate) | - | Other | 685 | Multiple | Kubernetes SIG Network reference implementation |
| [Kuma](https://github.com/kumahq/kuma) | ✅ | Other | 3.9k | 114 | CNCF Sandbox service mesh |
| [Linkerd](https://github.com/linkerd/linkerd2) | - | Other | 11.1k | 375+ | CNCF Graduated service mesh |
| [LoxiLB](https://github.com/loxilb-io/loxilb) | 🔴 | Other | 1.8k | 20+ | Open source load balancer |
| [NGINX Gateway Fabric](https://github.com/nginx/nginx-gateway-fabric) | ✅ | Other | 674 | 56 | Open source NGINX implementation |
| [Traefik Proxy](https://github.com/traefik/traefik) | ✅ | Other | 56.8k | 891 | Open source cloud-native application proxy |
| [WSO2 APK](https://github.com/wso2/apk) | ✅ | Other | 166 | 30+ | Open source API management solution |

> **Status Legend**: ✅ = GA (Generally Available) | 🔴 = Beta/Alpha/Experimental | - = Not specified
>
> **Notes**:
>
> * **ingate** is designed as a migration path from NGINX Ingress Controller to Gateway API

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

* **AWS Gateway API Controller** Integrates with Amazon VPC Lattice for EKS clusters

### Microsoft Azure

* **Azure Application Gateway for Containers** Managed application load balancing solution

### Google Cloud Platform (GCP)

* **GKE Gateway API Controller** Integrates with Google Cloud Load Balancers
* **Google Cloud Service Mesh** Supports Envoy-based and Proxyless-GRPC mesh implementations
