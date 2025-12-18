# nginx.ingress.kubernetes.io/rewrite-target

This annotation permite to change the url path it is sent to the backend service.

Examples:

- You want to expose your app at /v1/api/* but your backend service expects paths without the /v1 prefix.
- Strip application context paths
- Route multiple frontend paths to a single backend path
- Map public URLs to different internal paths

It can be archieved using the standard `URLRewrite` filter in HTTPRoute rules.

## Option 1: ReplacePrefixMatch (most common)

Replaces the matched path prefix with a new prefix:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: api-rewrite
spec:
  parentRefs:
  - name: my-gateway
  hostnames:
  - "api.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /v1
    filters:
    - type: URLRewrite
      urlRewrite:
        path:
          type: ReplacePrefixMatch
          replacePrefixMatch: /  # Strips /v1 prefix
    backendRefs:
    - name: api-service
      port: 80
```

**Example**: `/v1/users/123` → `/users/123`

## Option 2: ReplaceFullPath

Replaces the entire path with a fixed path:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: api-rewrite
spec:
  parentRefs:
  - name: my-gateway
  hostnames:
  - "api.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /old-api
    filters:
    - type: URLRewrite
      urlRewrite:
        path:
          type: ReplaceFullPath
          replaceFullPath: /new-api
    backendRefs:
    - name: api-service
      port: 80
```

**Example**: `/old-api/users/123` → `/new-api` (entire path replaced)

## Option 3: Hostname Rewrite

Can also rewrite the hostname:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: api-rewrite
spec:
  rules:
  - filters:
    - type: URLRewrite
      urlRewrite:
        hostname: "internal-api.example.com"
        path:
          type: ReplacePrefixMatch
          replacePrefixMatch: /api
    backendRefs:
    - name: api-service
      port: 80
```

## Advanced Implementation-Specific Extensions

- In Envoy Gateway we can use HTTPRouteFilter resource (spec.urlRewrite)
- In Istio we can use VirtualService resource (spec.http)
