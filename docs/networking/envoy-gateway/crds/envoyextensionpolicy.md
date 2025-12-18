# EnvoyExtensionPolicy

EnvoyExtensionPolicy extends Envoy Gateway functionality through external processing and custom extensions. It enables integration with external authentication services, authorization systems, WASM plugins, and custom Envoy filters.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `EnvoyExtensionPolicy`
- **Attachment**: Gateway or HTTPRoute via `targetRef`
- **Purpose**: Extend Envoy with custom processing logic

## Key Features

- External authentication (ExtAuth)
- External authorization
- WASM (WebAssembly) extensions
- Custom Envoy HTTP filters
- Request/response processing
- Policy-based extension configuration

## Basic Example

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: ext-auth-policy
  namespace: default
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: my-route
  extAuth:
    http:
      backendRef:
        name: auth-service
        port: 9000
      path: /verify
```

## External Authentication (ExtAuth)

### HTTP External Auth

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: http-ext-auth
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  extAuth:
    http:
      backendRef:
        name: auth-service
        namespace: auth
        port: 9000
      path: /auth
      headersToBackend:
        - Authorization
        - Cookie
```

### gRPC External Auth

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: grpc-ext-auth
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  extAuth:
    grpc:
      backendRef:
        name: auth-service
        port: 9000
```

### ExtAuth with Headers

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: ext-auth-with-headers
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: api-route
  extAuth:
    http:
      backendRef:
        name: auth-service
        port: 9000
      path: /verify
      headersToBackend:
        - Authorization
        - X-API-Key
        - Cookie
      headersToDownstream:
        - X-Auth-User
        - X-Auth-Groups
```

### ExtAuth Failure Response

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: ext-auth-failure
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: my-route
  extAuth:
    http:
      backendRef:
        name: auth-service
        port: 9000
      path: /auth
      failOpen: false  # Fail closed (default)
```

## WASM Extensions

### Basic WASM Plugin

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: wasm-plugin
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  wasm:
    - name: custom-filter
      rootID: my_root_id
      code:
        http:
          url: https://example.com/plugin.wasm
          sha256: abcdef1234567890...
```

### WASM with Configuration

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: wasm-with-config
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: my-route
  wasm:
    - name: rate-limiter
      rootID: rate_limiter_root
      code:
        http:
          url: https://example.com/rate-limiter.wasm
          sha256: abcdef1234567890...
      config:
        rateLimit: 100
        window: 60s
```

### WASM from OCI Registry

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: wasm-oci
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  wasm:
    - name: security-filter
      code:
        image:
          url: oci://ghcr.io/myorg/wasm-filter:v1.0.0
          sha256: abcdef1234567890...
          pullSecretRef:
            name: oci-credentials
```

### WASM from ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: wasm-plugin
binaryData:
  plugin.wasm: <base64-encoded-wasm>
---
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: wasm-configmap
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  wasm:
    - name: my-filter
      code:
        configMapRef:
          name: wasm-plugin
          key: plugin.wasm
```

## External Processing

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: ext-proc
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: my-route
  extProc:
    backendRef:
      name: processing-service
      port: 9002
    processingMode:
      requestHeaderMode: SEND
      responseHeaderMode: SEND
      requestBodyMode: BUFFERED
      responseBodyMode: NONE
```

## Use Cases

### OAuth2 Token Validation

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: oauth2-validation
  namespace: production
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: api-route
  extAuth:
    http:
      backendRef:
        name: oauth2-proxy
        namespace: auth
        port: 4180
      path: /oauth2/auth
      headersToBackend:
        - Authorization
        - Cookie
      headersToDownstream:
        - X-Auth-Request-User
        - X-Auth-Request-Email
        - X-Auth-Request-Groups
```

### API Key Validation

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: api-key-auth
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: public-api
  extAuth:
    http:
      backendRef:
        name: api-key-validator
        port: 8080
      path: /validate-key
      headersToBackend:
        - X-API-Key
      failOpen: false
```

### Custom Authorization

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: custom-authz
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: protected-gateway
  extAuth:
    grpc:
      backendRef:
        name: authz-service
        port: 9000
      timeout: 2s
```

### WASM-based WAF

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: wasm-waf
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: public-gateway
  wasm:
    - name: waf-filter
      rootID: waf_root
      code:
        http:
          url: https://cdn.example.com/waf.wasm
          sha256: 1234567890abcdef...
      config:
        rules:
          - type: sql_injection
            action: block
          - type: xss
            action: block
          - type: path_traversal
            action: block
```

### Request Transformation

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: request-transformer
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: legacy-api
  extProc:
    backendRef:
      name: transformer-service
      port: 9002
    processingMode:
      requestHeaderMode: SEND
      requestBodyMode: BUFFERED
      responseHeaderMode: SKIP
      responseBodyMode: SKIP
```

### Multi-tenant Authentication

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: multi-tenant-auth
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: tenant-api
  extAuth:
    http:
      backendRef:
        name: tenant-auth-service
        port: 8080
      path: /auth
      headersToBackend:
        - Authorization
        - X-Tenant-ID
      headersToDownstream:
        - X-Tenant-ID
        - X-User-Roles
        - X-User-ID
```

### Rate Limiting via WASM

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: wasm-rate-limit
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: api-route
  wasm:
    - name: rate-limiter
      code:
        http:
          url: https://example.com/rate-limit.wasm
          sha256: abc123...
      config:
        limits:
          - key: "client_ip"
            requests: 100
            window: "1m"
          - key: "api_key"
            requests: 1000
            window: "1h"
```

## ExtAuth Backend Service Example

### Simple HTTP Auth Service (Python)

```python
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/verify', methods=['GET', 'POST'])
def verify():
    auth_header = request.headers.get('Authorization')

    if not auth_header or not auth_header.startswith('Bearer '):
        return '', 401

    token = auth_header[7:]

    # Validate token (simplified)
    if token == 'valid-token':
        return '', 200, {
            'X-Auth-User': 'john.doe',
            'X-Auth-Groups': 'admin,users'
        }

    return '', 403

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9000)
```

### Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: auth-service
spec:
  replicas: 2
  selector:
    matchLabels:
      app: auth-service
  template:
    metadata:
      labels:
        app: auth-service
    spec:
      containers:
        - name: auth
          image: my-auth-service:latest
          ports:
            - containerPort: 9000
---
apiVersion: v1
kind: Service
metadata:
  name: auth-service
spec:
  selector:
    app: auth-service
  ports:
    - port: 9000
      targetPort: 9000
```

## Policy Precedence

1. HTTPRoute-level policies override Gateway-level policies
2. More specific targetRef takes precedence
3. Multiple policies can be attached to different routes

## Best Practices

1. **Use ExtAuth for authentication** - Centralized auth logic
2. **Cache auth responses** - Reduce latency for repeated requests
3. **Set appropriate timeouts** - Prevent auth service from blocking traffic
4. **Monitor auth failures** - Track 401/403 responses
5. **Use WASM for performance** - Critical path processing
6. **Test failOpen carefully** - Understand security implications
7. **Version WASM plugins** - Use specific versions, not latest
8. **Validate WASM checksums** - Ensure integrity with SHA256

## Security Considerations

- **Fail closed by default** - Better security posture
- **Validate auth headers** - Prevent header injection
- **Use TLS for auth services** - Encrypt auth communication
- **Rate limit auth endpoints** - Prevent abuse
- **Audit auth decisions** - Log all authentication events
- **Regular WASM audits** - Review and update plugins

## Troubleshooting

### ExtAuth Not Working

Check auth service logs:

```bash
kubectl logs -n auth deploy/auth-service -f
```

Check Envoy logs:

```bash
kubectl logs -n envoy-gateway-system \
  -l gateway.envoyproxy.io/owning-gateway-name=my-gateway
```

### WASM Plugin Failures

Verify WASM file integrity:

```bash
# Check SHA256 sum
sha256sum plugin.wasm
```

Check Envoy logs for WASM errors:

```bash
kubectl logs -n envoy-gateway-system \
  -l gateway.envoyproxy.io/owning-gateway-name=my-gateway | grep -i wasm
```

### Performance Issues

Monitor auth service latency:

```bash
kubectl top pods -n auth
```

Check ExtAuth timeout settings and consider caching.

## Related Resources

- [SecurityPolicy](securitypolicy.md) - Built-in security features
- [BackendTrafficPolicy](backendtrafficpolicy.md) - Backend configuration
- [EnvoyProxy](envoyproxy.md) - Proxy infrastructure
- [Envoy ExtAuth Filter](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/ext_authz_filter) - Envoy documentation
