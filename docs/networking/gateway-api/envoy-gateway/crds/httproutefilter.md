# HTTPRouteFilter

HTTPRouteFilter provides reusable HTTP request and response manipulation filters that can be referenced from Gateway API HTTPRoute resources via `extensionRef`.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `HTTPRouteFilter`
- **Usage**: Referenced from HTTPRoute via `filters[].type: ExtensionRef`
- **Benefit**: Define header/URL transformations once, reuse across multiple routes

## Key Features

- Add, set, or remove request headers
- Add, set, or remove response headers
- URL path rewriting (prefix replace or full replace)
- Hostname rewriting
- HTTP redirects (scheme, hostname, path, port, status code)
- Request mirroring to a shadow backend
- Dynamic header values via Envoy command operators (e.g. `%REQ(:authority)%`)

## Basic Example

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
    remove:
      - Server
      - X-Powered-By
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
            name: security-headers
      backendRefs:
        - name: backend-service
          port: 8080
```

## Key Configuration Sections

| Section                         | Purpose                                                               |
|---------------------------------|-----------------------------------------------------------------------|
| `requestHeaderModifier.add`     | Append headers to the upstream request                                |
| `requestHeaderModifier.set`     | Overwrite headers on the upstream request                             |
| `requestHeaderModifier.remove`  | Remove headers from the upstream request                              |
| `responseHeaderModifier.add`    | Append headers to the downstream response                             |
| `responseHeaderModifier.set`    | Overwrite headers on the downstream response                          |
| `responseHeaderModifier.remove` | Remove headers from the downstream response                           |
| `urlRewrite.path`               | Replace path prefix or full path before forwarding                    |
| `urlRewrite.hostname`           | Rewrite the Host header before forwarding                             |
| `requestRedirect`               | Return a redirect response (scheme, hostname, path, port, statusCode) |
| `requestMirror.backendRef`      | Shadow-copy requests to a secondary backend                           |

## Official Documentation

- [HTTP Request Headers](https://gateway.envoyproxy.io/docs/tasks/traffic/http-request-headers/)
- [HTTP Response Headers](https://gateway.envoyproxy.io/docs/tasks/traffic/http-response-headers/)
- [HTTP Redirects](https://gateway.envoyproxy.io/docs/tasks/traffic/http-redirect/)
- [HTTP URL Rewrite](https://gateway.envoyproxy.io/docs/tasks/traffic/http-urlrewrite/)
- [HTTPRoute Request Mirroring](https://gateway.envoyproxy.io/docs/tasks/traffic/http-request-mirroring/)
- [HTTP Routing](https://gateway.envoyproxy.io/docs/tasks/traffic/http-routing/)
- [HTTPRoute Traffic Splitting](https://gateway.envoyproxy.io/docs/tasks/traffic/http-traffic-splitting/)

## Related Resources

- [SecurityPolicy](securitypolicy.md) - CORS, authentication, rate limiting
- [BackendTrafficPolicy](backendtrafficpolicy.md) - Backend connection policies
- [Gateway API HTTPRoute](https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io/v1.HTTPRoute) - Gateway API specification
