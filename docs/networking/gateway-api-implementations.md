# Gateway API Implementations

## Requirements

For inclusion in this documentation, Gateway API implementations must meet the following criteria:

1. **Open Source**: The implementation must be open source software
2. **Official Listing**: Must be listed on the official [Gateway API implementations page](https://gateway-api.sigs.k8s.io/implementations/)

## Available Open Source Implementations

> **Legend**: ✅ = GA (Generally Available) | 🔴 = Beta/Alpha/Experimental

### Envoy-Based Implementations

- **Contour** ✅ - CNCF Incubating Envoy-based ingress controller
  - *GitHub*: [projectcontour/contour](https://github.com/projectcontour/contour) | ⭐ 3.8k | 👥 226 contributors
- **Emissary-Ingress** 🔴 - CNCF Incubating project (Alpha status)
  - *GitHub*: [emissary-ingress/emissary](https://github.com/emissary-ingress/emissary) | ⭐ 4.5k | 👥 215 contributors
- **Envoy Gateway** ✅ - CNCF Graduated Envoy subproject
  - *GitHub*: [envoyproxy/gateway](https://github.com/envoyproxy/gateway) | ⭐ 2.1k | 👥 251 contributors
- **Istio** ✅ - CNCF Graduated service mesh
  - *GitHub*: [istio/istio](https://github.com/istio/istio) | ⭐ 37.3k | 👥 1,147 contributors
- **kgateway** ✅ - CNCF Sandbox AI-powered API Gateway (formerly Gloo)
  - *GitHub*: [kgateway-dev/kgateway](https://github.com/kgateway-dev/kgateway) | ⭐ 4.9k | 👥 219 contributors

### eBPF-Based Implementations

- **Cilium** 🔴 - CNCF Graduated eBPF-based networking solution (Beta status)
  - *GitHub*: [cilium/cilium](https://github.com/cilium/cilium) | ⭐ 22.5k | 👥 955+ contributors

### Other Open Source Implementations

- **Apache APISIX** 🔴 - Apache Foundation API Gateway (Beta status)
  - *GitHub*: [apache/apisix](https://github.com/apache/apisix) | ⭐ 15.7k | 👥 480 contributors
- **Easegress** ✅ - CNCF Sandbox Cloud Native traffic orchestration
  - *GitHub*: [easegress-io/easegress](https://github.com/easegress-io/easegress) | ⭐ 5.9k | 👥 65+ contributors
- **Flomesh Service Mesh** 🔴 - Community driven lightweight service mesh (Beta status)
  - *GitHub*: [flomesh-io/fsm](https://github.com/flomesh-io/fsm) | ⭐ 66 | 👥 9+ contributors
- **HAProxy Ingress** ✅ - Community driven ingress controller
  - *GitHub*: [haproxytech/kubernetes-ingress](https://github.com/haproxytech/kubernetes-ingress) | ⭐ 791 | 👥 50+ contributors
- **ingate** - Kubernetes SIG Network reference implementation and NGINX migration path
  - *GitHub*: [kubernetes-sigs/ingate](https://github.com/kubernetes-sigs/ingate) | ⭐ 685 | 👥 Multiple contributors
  - *Note*: Designed as migration path from NGINX Ingress Controller to Gateway API
- **Kuma** ✅ - CNCF Sandbox service mesh
  - *GitHub*: [kumahq/kuma](https://github.com/kumahq/kuma) | ⭐ 3.9k | 👥 114 contributors
- **Linkerd** - CNCF Graduated service mesh (Status not specified)
  - *GitHub*: [linkerd/linkerd2](https://github.com/linkerd/linkerd2) | ⭐ 11.1k | 👥 375+ contributors
- **LoxiLB** 🔴 - Open source load balancer (Beta status)
  - *GitHub*: [loxilb-io/loxilb](https://github.com/loxilb-io/loxilb) | ⭐ 1.8k | 👥 20+ contributors
- **NGINX Gateway Fabric** ✅ - Open source NGINX implementation
  - *GitHub*: [nginx/nginx-gateway-fabric](https://github.com/nginx/nginx-gateway-fabric) | ⭐ 674 | 👥 56 contributors
- **Traefik Proxy** ✅ - Open source cloud-native application proxy
  - *GitHub*: [traefik/traefik](https://github.com/traefik/traefik) | ⭐ 56.8k | 👥 891 contributors
- **WSO2 APK** ✅ - Open source API management solution
  - *GitHub*: [wso2/apk](https://github.com/wso2/apk) | ⭐ 166 | 👥 30+ contributors

### Deprecated/Legacy Implementations

- **Acnodal EPIC** - Open Source External Gateway platform
  - *GitHub*: [epic-gateway/resource-model](https://github.com/epic-gateway/resource-model) | ⭐ 0 | 👥 2 contributors
- **Airlock Microgateway** - Open source WAAP solution
  - *GitHub*: [airlock/microgateway](https://github.com/airlock/microgateway) | ⭐ 18 | 👥 3-5 contributors

## Commercial/Proprietary Implementations

The following commercial or proprietary Gateway API implementations are officially listed:

- **LiteSpeed Ingress Controller** - Commercial web ADC controller with Gateway API support
- **Tyk Gateway** - Cloud-native API Gateway working towards Gateway API implementation

## Cloud Provider Implementations

Cloud providers offer managed Gateway API implementations:

### Amazon Web Services (AWS)

- **AWS Gateway API Controller** - Integrates with Amazon VPC Lattice for EKS clusters

### Microsoft Azure

- **Azure Application Gateway for Containers** - Managed application load balancing solution

### Google Cloud Platform (GCP)

- **GKE Gateway API Controller** - Integrates with Google Cloud Load Balancers
- **Google Cloud Service Mesh** - Supports Envoy-based and Proxyless-GRPC mesh implementations
