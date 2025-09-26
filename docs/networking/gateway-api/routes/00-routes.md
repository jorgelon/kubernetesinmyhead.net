# Gateway API Routes

Gateway API routes are fundamental resources that define how traffic flows from Gateways to backend services. They provide declarative configuration for traffic routing, load balancing, and request processing within Kubernetes clusters.

## Route Types Overview

Gateway API defines several route types to handle different traffic patterns and protocols:

### Standard Routes (GA)

- **[HTTPRoute](httproute.md)** - HTTP/HTTPS traffic routing with advanced features
- **[GRPCRoute](grpcroute.md)** - gRPC-specific routing with protocol awareness

### Experimental Routes

- **[TCPRoute](tcproute.md)** - Layer 4 TCP traffic routing
- **[TLSRoute](tlsroute.md)** - TLS passthrough and SNI-based routing  
- **[UDPRoute](udproute.md)** - UDP traffic routing for stateless protocols

## Core Concepts

### Route Attachment

Routes attach to Gateways through `parentRefs`, creating a binding between the Gateway listener and the route configuration:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: example-route
spec:
  parentRefs:
  - name: example-gateway
    sectionName: http-listener
```

### Traffic Matching

Routes define matching criteria to select which requests they handle:

- **Hostname matching** - Route based on Host header
- **Path matching** - Route based on URL paths (exact, prefix, regex)
- **Header matching** - Route based on HTTP headers
- **Method matching** - Route based on HTTP methods
- **Query parameter matching** - Route based on URL parameters

### Backend Selection

Routes forward matched traffic to backend services with configurable weights and filters:

```yaml
spec:
  rules:
  - backendRefs:
    - name: service-a
      port: 80
      weight: 90
    - name: service-b  
      port: 80
      weight: 10
```

### Request Processing

Routes can modify requests and responses through filters:

- **Request header modification** - Add, set, or remove headers
- **Response header modification** - Transform response headers
- **URL rewriting** - Modify paths and hostnames
- **Request mirroring** - Duplicate traffic to additional backends
- **Request redirection** - Return HTTP redirects

## Route Hierarchy

Routes follow a hierarchical attachment model:

1. **Gateway** - Defines listeners and infrastructure
2. **Route** - Defines traffic routing rules
3. **Backend** - Target services for traffic forwarding

## Cross-Namespace Routing

Routes can reference backends in different namespaces with proper RBAC configuration:

```yaml
spec:
  rules:
  - backendRefs:
    - name: backend-service
      namespace: backend-ns
      port: 8080
```

Requires ReferenceGrant in the target namespace:

```yaml
apiVersion: gateway.networking.k8s.io/v1beta1
kind: ReferenceGrant
metadata:
  name: allow-routes
  namespace: backend-ns
spec:
  from:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    namespace: frontend-ns
  to:
  - group: ""
    kind: Service
```

## Route Status and Conditions

Routes report their status through conditions:

- **Accepted** - Route configuration is valid
- **ResolvedRefs** - All references can be resolved
- **PartiallyInvalid** - Some rules are invalid but others work

## Best Practices

### Security

- Use ReferenceGrants for cross-namespace access
- Implement proper RBAC for route management
- Validate input through admission controllers
- Use TLS termination at the Gateway level

### Performance

- Minimize regex matching in favor of exact/prefix matching
- Use appropriate backend weights for load distribution
- Configure timeouts and retry policies appropriately
- Monitor route performance and adjust configurations

### Maintainability

- Use descriptive names and annotations
- Group related routes logically
- Document complex routing logic
- Version control route configurations
