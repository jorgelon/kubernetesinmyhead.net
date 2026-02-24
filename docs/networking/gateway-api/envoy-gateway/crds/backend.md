# Backend

Backend extends Gateway API backend references with additional endpoint types beyond standard Kubernetes Services.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `Backend`
- **Purpose**: Extended backend reference supporting FQDN, IP, and Unix socket endpoints
- **Usage**: Referenced from HTTPRoute, GRPCRoute, or other route types via `extensionRef`

## Key Features

- FQDN-based backends (external services)
- IP-based backends (legacy systems)
- Unix domain socket endpoints
- Fallback backend configuration
- AppProtocol selection (`http`, `https`, `h2c`, `h2`, `grpc`, `grpcs`, `tcp`, `udp`)

## Basic Example

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: external-api
spec:
  endpoints:
    - fqdn: api.example.com
      port: 443
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: my-route
spec:
  parentRefs:
    - name: my-gateway
  rules:
    - backendRefs:
        - group: gateway.envoyproxy.io
          kind: Backend
          name: external-api
```

## Endpoint Types

| Type        | Field           | Use case                      |
|-------------|-----------------|-------------------------------|
| FQDN        | `fqdn` + `port` | External services, cloud APIs |
| IP          | `ip` + `port`   | Legacy systems without DNS    |
| Unix socket | `unix`          | Sidecar communication         |

## Fallback Configuration

```yaml
spec:
  endpoints:
    - fqdn: primary.example.com
      port: 443
  fallback:
    backendRef:
      name: fallback-service
      port: 8080
```

## Use Backend When

1. Routing to services **outside the cluster** (FQDN or IP)
2. **Fallback** behavior is needed between endpoints
3. **Unix domain socket** communication with a sidecar
4. **Mixed protocols** not expressible via standard Service references

Use a standard Kubernetes Service reference for all in-cluster workloads.

## Security Note

Backend support is **disabled by default** in Envoy Gateway. Enable it explicitly via `extensionApis.enableBackend`. See [Backend Security Risks](backend-risks.md) for a full risk assessment before enabling.

## Official Documentation

- [Backend Routing](https://gateway.envoyproxy.io/docs/tasks/traffic/backend/)
- [Failover](https://gateway.envoyproxy.io/docs/tasks/traffic/failover/)
- [Routing outside Kubernetes](https://gateway.envoyproxy.io/docs/tasks/traffic/routing-outside-kubernetes/)
- [Multicluster Service Routing](https://gateway.envoyproxy.io/docs/tasks/traffic/multicluster-service/)

## Related Resources

- [BackendTrafficPolicy](backendtrafficpolicy.md) - Backend traffic configuration
- [HTTPRoute](https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io/v1.HTTPRoute) - Gateway API routing
- [SecurityPolicy](securitypolicy.md) - TLS and security settings
