# nginx.ingress.kubernetes.io/proxy-body-size

This annotation sets the maximum allowed size of the client request body. If the request body exceeds this limit, the gateway returns a 413 (Request Entity Too Large) error.
Usually it is used for

- File upload services
- API endpoints accepting large payloads
- Services handling image/video uploads
- Webhook receivers with large payloads

Security consideration: Setting this value too high can make your service vulnerable to DoS attacks via large request bodies. Set reasonable limits based on your application's actual needs.

The default value in nginx is 1m (1 megabyte) and some common values are: `8m`, `50m`, `100m`, or `0` (unlimited)

## Gateway API Implementation

### Envoy Gateway

It provides spec.requestBuffer.limit under the **BackendTrafficPolicy** resource. It supports SI units: Ki, Mi, Gi

**Important limitation**: Due to an Envoy limitation, requests with body size ≤ 16KB (16384 bytes) are not rejected. You must specify a value > 16KB for the policy to work correctly.

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: BackendTrafficPolicy
metadata:
  name: request-size-limit
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: my-route
  requestBuffer:
    limit: 50Mi  # 50 megabytes
```

### Istio

It can be configured using an **EnvoyFilter** resource to modify the Envoy configuration:

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: request-size-limit
spec:
  workloadSelector:
    labels:
      app: my-app
  configPatches:
  - applyTo: ROUTE_CONFIGURATION
    match:
      context: GATEWAY
    patch:
      operation: MERGE
      value:
        per_filter_config:
          envoy.filters.http.buffer:
            max_request_bytes: 52428800  # 50MB in bytes
```

### Kgateway

It supports request body size limits through its policy mechanisms (similar to Envoy Gateway's BackendTrafficPolicy):

```yaml
apiVersion: gateway.kgateway.dev/v1alpha1
kind: BackendTrafficPolicy
metadata:
  name: request-size-limit
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: my-route
  connection:
    bufferLimit: 50Mi
```
