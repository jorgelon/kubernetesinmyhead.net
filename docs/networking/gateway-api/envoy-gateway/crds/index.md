# Envoy Gateway Custom Resource Definitions (CRDs)

Envoy Gateway extends Kubernetes with custom resources to configure and manage the data plane. This section documents the key CRDs available.

## Policy CRDs

### [BackendTrafficPolicy](backendtrafficpolicy.md)

Configures traffic policies for backend connections, including:

- Load balancing strategies
- Connection limits and timeouts
- Circuit breaking
- Health checks
- Retry and timeout policies

### [ClientTrafficPolicy](clienttrafficpolicy.md)

Defines policies for client-facing traffic, such as:

- TCP/HTTP keep-alive settings
- Connection timeouts
- Client IP detection (X-Forwarded-For)
- HTTP/2 and HTTP/3 configuration

### [SecurityPolicy](securitypolicy.md)

Implements security controls for routes:

- CORS (Cross-Origin Resource Sharing)
- JWT authentication
- OIDC authentication
- Basic authentication
- Rate limiting
- Authorization policies

### [EnvoyExtensionPolicy](envoyextensionpolicy.md)

Extends Envoy functionality with external processing:

- External authentication services
- External authorization
- WASM extensions
- Custom Envoy filters

## Routing and Filtering

### [HTTPRouteFilter](httproutefilter.md)

Provides reusable HTTP filters for Gateway API HTTPRoutes:

- Request/response header modification
- URL rewriting
- Request mirroring
- Request redirects

### [Backend](backend.md)

Defines backend service references with additional capabilities:

- Backend references for multiple protocols
- Service discovery integration
- Fallback configurations

### [Backend Security Risks](backend-risks.md)

Security analysis of the Backend CRD:

- Risk assessment per feature (ReferenceGrant bypass, DynamicResolver, localhost exposure)
- Mitigation strategies (RBAC, policy engines, network policies)
- When to use and when to avoid Backend resources

## Infrastructure Configuration

### [EnvoyProxy](envoyproxy.md)

Configures the Envoy Proxy infrastructure:

- Deployment strategy and replicas
- Pod template specifications
- Service configuration
- Bootstrap configuration
- Telemetry and logging
- Shutdown configuration

### [EnvoyPatchPolicy](envoypatchpolicy.md)

Low-level Envoy configuration patching:

- Direct xDS resource modification
- JSON patches for fine-grained control
- Advanced customization beyond standard CRDs
- Emergency configuration overrides

## Policy Attachment Model

Most Envoy Gateway policies use the Gateway API Policy Attachment model:

- **Gateway-level**: Policies attached to Gateway resources affect all routes
- **HTTPRoute-level**: Policies attached to HTTPRoute resources affect specific routes
- **Inheritance**: Route-level policies override Gateway-level policies
- **Conflict resolution**: Most specific policy wins

## Common Fields

All policy CRDs share common patterns:

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: <PolicyKind>
metadata:
  name: example-policy
  namespace: default
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway  # or HTTPRoute
    name: example-gateway
  # Policy-specific configuration
```

## Version Compatibility

CRDs are versioned independently from Envoy Gateway releases. Check the API reference for compatibility:

- `v1alpha1` - Experimental features, subject to breaking changes
- `v1beta1` - Stable features, minimal breaking changes expected
- `v1` - Production-ready, backward compatibility guaranteed
