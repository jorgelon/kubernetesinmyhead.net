# Gateway API

## Supported releases

| Cilium release | Supported Gateway Api release |
|----------------|-------------------------------|
| 1.16           | v1.1.0                        |
| 1.17           | v1.2.0                        |

## Enable gateway api support

- Deploy the gateway api crds

<https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml>

- Cilium must be deployed with kubeproxy replacement or nodePort.enabled=true

- Cilium must have l7Proxy=true (default)

> Then enable gateway api with gatewayAPI.enabled=true in the helm chart
