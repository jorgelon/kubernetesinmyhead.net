# Backend

Backend is a custom resource that extends the Gateway API's backend references with additional capabilities. It provides enhanced service discovery, load balancing, and fallback configurations for upstream services.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `Backend`
- **Purpose**: Extended backend service reference with advanced features
- **Usage**: Referenced from HTTPRoute, GRPCRoute, or other route types

## Key Features

- Multiple endpoint configurations
- Fallback backends
- Custom health checks
- Service discovery integration
- FQDN-based backends (external services)
- IP-based backends
- Unix domain socket support

## Basic Example

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: my-backend
  namespace: default
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
          name: my-backend
```

## Endpoint Types

### FQDN Endpoints

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: external-api
spec:
  endpoints:
    - fqdn: api.external.com
      port: 443
      protocol: HTTPS
```

### IP Endpoints

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: ip-backend
spec:
  endpoints:
    - ip: 192.168.1.100
      port: 8080
    - ip: 192.168.1.101
      port: 8080
```

### Unix Domain Socket

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: unix-socket-backend
spec:
  endpoints:
    - unix: /var/run/app.sock
```

### Mixed Endpoints

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: mixed-backend
spec:
  endpoints:
    - fqdn: primary.example.com
      port: 443
    - ip: 192.168.1.100
      port: 8080
    - ip: 192.168.1.101
      port: 8080
```

## Fallback Configuration

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: backend-with-fallback
spec:
  endpoints:
    - fqdn: primary.example.com
      port: 443
  fallback:
    backendRef:
      name: fallback-service
      port: 8080
```

## AppProtocol

Specify application protocol for the backend:

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: grpc-backend
spec:
  appProtocol: grpc
  endpoints:
    - fqdn: grpc.example.com
      port: 9090
```

Supported protocols:
- `http` - HTTP/1.1
- `https` - HTTP/1.1 over TLS
- `h2c` - HTTP/2 cleartext
- `h2` - HTTP/2 over TLS
- `grpc` - gRPC
- `grpcs` - gRPC over TLS
- `tcp` - Raw TCP
- `udp` - Raw UDP

## Use Cases

### External API Integration

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: external-payment-api
  namespace: default
spec:
  endpoints:
    - fqdn: api.stripe.com
      port: 443
      protocol: HTTPS
```

### Multi-Region Endpoints

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: multi-region-api
spec:
  endpoints:
    - fqdn: us-east.api.example.com
      port: 443
    - fqdn: us-west.api.example.com
      port: 443
    - fqdn: eu-west.api.example.com
      port: 443
```

### High Availability with Fallback

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: ha-backend
spec:
  endpoints:
    - fqdn: primary.example.com
      port: 443
    - fqdn: secondary.example.com
      port: 443
  fallback:
    backendRef:
      name: emergency-service
      namespace: default
      port: 8080
```

### Legacy IP-Based Service

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: legacy-service
spec:
  endpoints:
    - ip: 10.0.1.50
      port: 8080
    - ip: 10.0.1.51
      port: 8080
    - ip: 10.0.1.52
      port: 8080
```

### gRPC Backend

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: grpc-service
spec:
  appProtocol: grpc
  endpoints:
    - fqdn: grpc.internal.example.com
      port: 9090
```

### Unix Socket for Sidecar

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: sidecar-backend
spec:
  endpoints:
    - unix: /var/run/sidecar.sock
```

### Cloud Service Endpoints

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: s3-backend
spec:
  endpoints:
    - fqdn: my-bucket.s3.amazonaws.com
      port: 443
      protocol: HTTPS
```

## Complete Example with HTTPRoute

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: api-backend
  namespace: production
spec:
  appProtocol: https
  endpoints:
    - fqdn: api-primary.example.com
      port: 443
    - fqdn: api-secondary.example.com
      port: 443
  fallback:
    backendRef:
      name: maintenance-page
      port: 8080
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: api-route
  namespace: production
spec:
  parentRefs:
    - name: production-gateway
  hostnames:
    - api.example.com
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /v1
      backendRefs:
        - group: gateway.envoyproxy.io
          kind: Backend
          name: api-backend
```

## Backend vs Service References

### Standard Service Reference

```yaml
backendRefs:
  - name: my-service  # Kubernetes Service
    port: 8080
```

### Backend Reference

```yaml
backendRefs:
  - group: gateway.envoyproxy.io
    kind: Backend
    name: my-backend  # Custom Backend resource
```

## Use Backend When:

1. **External services** - Services outside the cluster
2. **FQDN-based routing** - Need to route to specific hostnames
3. **IP-based backends** - Legacy systems without service discovery
4. **Fallback required** - Need automatic failover to backup services
5. **Unix sockets** - Local sidecar communication
6. **Mixed protocols** - Complex protocol requirements

## Use Standard Service When:

1. **In-cluster services** - Native Kubernetes Services
2. **Simple routing** - No special requirements
3. **Service mesh** - Leveraging mesh capabilities
4. **Standard patterns** - Following conventional practices

## DNS Resolution

FQDN endpoints support different DNS resolution strategies:

### Logical DNS

Default behavior - DNS resolution happens periodically:

```yaml
spec:
  endpoints:
    - fqdn: api.example.com
      port: 443
```

DNS TTL is respected, and Envoy re-resolves periodically.

## Health Checks

Backend resources inherit health check configuration from BackendTrafficPolicy:

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: BackendTrafficPolicy
metadata:
  name: backend-health
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: my-route
  healthCheck:
    active:
      http:
        path: /health
---
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: my-backend
spec:
  endpoints:
    - fqdn: api.example.com
      port: 443
```

## Load Balancing

Load balancing across Backend endpoints uses BackendTrafficPolicy:

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: BackendTrafficPolicy
metadata:
  name: lb-policy
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: my-route
  loadBalancer:
    type: RoundRobin
---
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: multi-endpoint
spec:
  endpoints:
    - fqdn: node1.example.com
      port: 443
    - fqdn: node2.example.com
      port: 443
    - fqdn: node3.example.com
      port: 443
```

## Best Practices

1. **Use for external services** - Primary use case for Backend resources
2. **Combine with policies** - Use BackendTrafficPolicy for health checks
3. **Configure fallbacks** - Always have a fallback for critical services
4. **Monitor DNS resolution** - Watch for DNS issues with FQDN endpoints
5. **Group related endpoints** - Keep related endpoints in same Backend
6. **Document external dependencies** - Clearly annotate external service backends
7. **Test failover** - Verify fallback behavior in staging
8. **Security considerations** - Use TLS for external communications

## Limitations

- DNS resolution frequency controlled by Envoy, not user-configurable per-Backend
- No support for SRV records
- Limited to HTTP/HTTPS/gRPC protocols (no arbitrary TCP/UDP routing)
- Fallback only supports single level (no chained fallbacks)

## Troubleshooting

### DNS Resolution Issues

Check Envoy logs for DNS resolution failures:

```bash
kubectl logs -n envoy-gateway-system \
  -l gateway.envoyproxy.io/owning-gateway-name=my-gateway
```

### Endpoint Connectivity

Verify endpoints are reachable:

```bash
# From a pod in the cluster
kubectl run -it --rm debug --image=curlimages/curl --restart=Never \
  -- curl -v https://api.example.com
```

### Backend Health

Check Envoy admin interface for cluster health:

```bash
kubectl port-forward -n envoy-gateway-system \
  deploy/envoy-gateway 19000:19000
curl localhost:19000/clusters | grep my-backend
```

## Related Resources

- [BackendTrafficPolicy](backendtrafficpolicy.md) - Backend traffic configuration
- [HTTPRoute](https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io/v1.HTTPRoute) - Gateway API routing
- [SecurityPolicy](securitypolicy.md) - TLS and security settings
