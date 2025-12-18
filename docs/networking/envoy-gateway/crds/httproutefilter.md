# HTTPRouteFilter

HTTPRouteFilter provides reusable HTTP request and response manipulation filters that can be referenced from Gateway API HTTPRoute resources. It enables header modification, URL rewriting, redirects, and request mirroring.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `HTTPRouteFilter`
- **Usage**: Referenced from HTTPRoute via `extensionRef`
- **Benefit**: DRY principle - define once, use in multiple routes

## Key Features

- Request/response header manipulation
- URL path rewriting
- Host rewriting
- HTTP redirects
- Request mirroring
- URL prefix modification
- Reusable across multiple HTTPRoutes

## Basic Example

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: add-headers
  namespace: default
spec:
  requestHeaderModifier:
    add:
      - name: X-Custom-Header
        value: custom-value
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: my-route
spec:
  parentRefs:
    - name: my-gateway
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /api
      filters:
        - type: ExtensionRef
          extensionRef:
            group: gateway.envoyproxy.io
            kind: HTTPRouteFilter
            name: add-headers
      backendRefs:
        - name: backend-service
          port: 8080
```

## Request Header Modification

### Add Headers

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: add-request-headers
spec:
  requestHeaderModifier:
    add:
      - name: X-Request-ID
        value: "%REQ(x-request-id)%"
      - name: X-Forwarded-Proto
        value: https
```

### Set Headers

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: set-request-headers
spec:
  requestHeaderModifier:
    set:
      - name: X-Custom-Header
        value: overwrite-value
      - name: Host
        value: backend.internal
```

### Remove Headers

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: remove-request-headers
spec:
  requestHeaderModifier:
    remove:
      - X-Internal-Secret
      - X-Debug-Token
```

## Response Header Modification

### Add Response Headers

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: add-response-headers
spec:
  responseHeaderModifier:
    add:
      - name: X-Cache-Status
        value: HIT
      - name: X-Served-By
        value: envoy-gateway
```

### Set Response Headers

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: set-response-headers
spec:
  responseHeaderModifier:
    set:
      - name: Cache-Control
        value: no-cache, no-store
      - name: X-Frame-Options
        value: DENY
```

### Remove Response Headers

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: remove-response-headers
spec:
  responseHeaderModifier:
    remove:
      - Server
      - X-Powered-By
```

## URL Rewriting

### Path Rewriting

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: rewrite-path
spec:
  urlRewrite:
    path:
      type: ReplacePrefixMatch
      replacePrefixMatch: /v2/api
```

### Hostname Rewriting

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: rewrite-host
spec:
  urlRewrite:
    hostname: backend.internal.local
```

### Combined Path and Host Rewriting

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: rewrite-url
spec:
  urlRewrite:
    hostname: api.internal.local
    path:
      type: ReplacePrefixMatch
      replacePrefixMatch: /api/v1
```

## HTTP Redirect

### Simple Redirect

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: redirect-to-https
spec:
  requestRedirect:
    scheme: https
    statusCode: 301
```

### Redirect with Hostname Change

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: redirect-to-new-domain
spec:
  requestRedirect:
    hostname: new.example.com
    statusCode: 302
```

### Redirect with Port

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: redirect-with-port
spec:
  requestRedirect:
    scheme: https
    hostname: secure.example.com
    port: 8443
    statusCode: 301
```

### Path-based Redirect

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: redirect-path
spec:
  requestRedirect:
    path:
      type: ReplacePrefixMatch
      replacePrefixMatch: /new-api
    statusCode: 301
```

## Request Mirroring

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: mirror-traffic
spec:
  requestMirror:
    backendRef:
      name: mirror-service
      port: 8080
```

## Use Cases

### Security Headers Filter

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: security-headers
spec:
  responseHeaderModifier:
    add:
      - name: Strict-Transport-Security
        value: max-age=31536000; includeSubDomains
      - name: X-Content-Type-Options
        value: nosniff
      - name: X-Frame-Options
        value: DENY
      - name: X-XSS-Protection
        value: 1; mode=block
      - name: Content-Security-Policy
        value: default-src 'self'
    remove:
      - Server
      - X-Powered-By
```

### API Versioning

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: api-v2-rewrite
spec:
  requestHeaderModifier:
    add:
      - name: X-API-Version
        value: v2
  urlRewrite:
    path:
      type: ReplacePrefixMatch
      replacePrefixMatch: /api/v2
```

### Canary Testing with Mirroring

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: canary-mirror
spec:
  requestMirror:
    backendRef:
      name: canary-service
      port: 8080
  requestHeaderModifier:
    add:
      - name: X-Mirror-Test
        value: "true"
```

### CORS Preparation Headers

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: cors-headers
spec:
  responseHeaderModifier:
    add:
      - name: Access-Control-Allow-Origin
        value: "*"
      - name: Access-Control-Allow-Methods
        value: GET, POST, PUT, DELETE, OPTIONS
      - name: Access-Control-Allow-Headers
        value: Content-Type, Authorization
      - name: Access-Control-Max-Age
        value: "86400"
```

### Backend Service Routing

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: backend-routing
spec:
  urlRewrite:
    hostname: backend.svc.cluster.local
    path:
      type: ReplacePrefixMatch
      replacePrefixMatch: /
  requestHeaderModifier:
    add:
      - name: X-Forwarded-Host
        value: "%REQ(:authority)%"
    remove:
      - X-Internal-Debug
```

### HTTP to HTTPS Redirect

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: https-redirect
spec:
  requestRedirect:
    scheme: https
    statusCode: 301
```

### Legacy API Migration

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: legacy-migration
spec:
  requestRedirect:
    hostname: api.newdomain.com
    path:
      type: ReplacePrefixMatch
      replacePrefixMatch: /v3
    statusCode: 301
  responseHeaderModifier:
    add:
      - name: X-Migration-Notice
        value: This endpoint has moved
```

## Complete Example with HTTPRoute

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: production-filter
  namespace: default
spec:
  requestHeaderModifier:
    add:
      - name: X-Request-Source
        value: gateway
      - name: X-Request-Time
        value: "%START_TIME%"
    remove:
      - X-Debug-Mode
  responseHeaderModifier:
    add:
      - name: X-Cache-Status
        value: "%UPSTREAM_CACHE_STATUS%"
      - name: Strict-Transport-Security
        value: max-age=31536000
    remove:
      - Server
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: api-route
  namespace: default
spec:
  parentRefs:
    - name: production-gateway
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /api
      filters:
        - type: ExtensionRef
          extensionRef:
            group: gateway.envoyproxy.io
            kind: HTTPRouteFilter
            name: production-filter
      backendRefs:
        - name: api-service
          port: 8080
```

## Envoy Variable Substitution

HTTPRouteFilter supports Envoy command operators for dynamic values:

- `%REQ(header-name)%` - Request header value
- `%RESP(header-name)%` - Response header value
- `%START_TIME%` - Request start time
- `%DURATION%` - Request duration
- `%RESPONSE_CODE%` - HTTP response code
- `%DOWNSTREAM_REMOTE_ADDRESS%` - Client IP
- `%REQ(:authority)%` - Host header

Example:

```yaml
spec:
  requestHeaderModifier:
    add:
      - name: X-Original-Host
        value: "%REQ(:authority)%"
      - name: X-Request-Start
        value: "%START_TIME%"
```

## Best Practices

1. **Reuse filters** - Define common filters once
2. **Name clearly** - Use descriptive names indicating purpose
3. **Namespace properly** - Keep filters in same namespace as routes
4. **Document purpose** - Add annotations explaining filter usage
5. **Test thoroughly** - Validate header modifications don't break clients
6. **Avoid sensitive data** - Don't log or add headers with secrets
7. **Use variables** - Leverage Envoy variables for dynamic values
8. **Security first** - Add security headers, remove sensitive ones

## Limitations

- Cannot conditionally apply filters based on request properties
- No support for request body modification
- Limited to HTTP/HTTPS traffic
- Header values are static or use Envoy variables only

## Related Resources

- [SecurityPolicy](securitypolicy.md) - CORS, authentication, rate limiting
- [BackendTrafficPolicy](backendtrafficpolicy.md) - Backend connection policies
- [Gateway API HTTPRoute](https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io/v1.HTTPRoute) - Gateway API specification
