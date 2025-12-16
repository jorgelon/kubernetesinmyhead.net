# Migrate from nginx ingress controller

This guide is a reference to migrate common NGINX Ingress Controller annotations to gateway api.

## nginx.ingress.kubernetes.io/force-ssl-redirect: "true"

**Purpose**: Forces HTTP traffic to redirect to HTTPS automatically.

In Gateway API, you need to create:

1. A Gateway with both HTTP (port 80) and HTTPS (port 443) listeners
2. An HTTPRoute attached to the HTTP listener that redirects to HTTPS
3. An HTTPRoute attached to the HTTPS listener that routes to your backend

**2. HTTPRoute for HTTP to HTTPS Redirect:**

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: example-redirect
spec:
  parentRefs:
  - name: eg
    sectionName: http  # Attach to HTTP listener
  hostnames:
  - "www.example.com"
  rules:
  - filters:
    - type: RequestRedirect
      requestRedirect:
        scheme: https
        statusCode: 301  # Permanent redirect (default)
```

**References:**

- [Envoy Gateway HTTP Redirects](https://gateway.envoyproxy.io/docs/tasks/traffic/http-redirect/)
- [Gateway API HTTP Redirect/Rewrite Guide](https://gateway-api.sigs.k8s.io/guides/http-redirect-rewrite/)

## nginx.ingress.kubernetes.io/backend-protocol

**Purpose**: Specifies the protocol used to communicate with the backend service. For example, it is a common behaviour to use HTTPS for backends using that protocol.

**Valid values**: `HTTP` (default), `HTTPS`, `GRPC`, `GRPCS`, `FCGI`, `AUTO_HTTP`

### At service level

We can specify the protocol at service level with `spec.ports.[].appProtocol` in the backend kubernetes service resource. This works as a hint for be treated by different implementations, like gateway api or service mesh solutions.

Valid values are:

- IANA standard service names (http, https, tcp, grpc, http2,...)
- kubernetes.io/h2c (HTTP/2 over cleartext)
- kubernetes.io/ws (WebSocket over cleartext)
- kubernetes.io/wss (WebSocket over TLS)
- Custom implementations

**Important**: Gateway API implementations **SHOULD** honor the `appProtocol` field (per GEP-1911), but it's not a MUST requirement. So take care how every gateway api implementation uses or not appProtocol

> If a Route cannot use the specified protocol, implementations MUST set `ResolvedRefs` condition to `False` with reason `UnsupportedProtocol`

See this:

- GEP-1911: Backend Protocol Selection

<https://gateway-api.sigs.k8s.io/geps/gep-1911/>

### At gateway api implementation level

The protocol can be specified at implementation crd level

- Envoy gateway:

It provides spec.appProtocols under its **Backend** resource (gateway.envoyproxy.io/v1alpha1)

- Kgateway

It provides appProtocol under spec.static in its *Backend** resource (gateway.kgateway.dev/v1alpha1)

- Istio

It uses appProtocol or the port name

### Note about web certificates in HTTPS backends

When the backend service uses HTTPS and we want to validate the certificates we need to use a `BackendTLSPolicy` resource

But if we want to ignore that backends certificate we must use the implementation crd. Currently there is not a native gateway api implementation

- Envoy gateway:

It provides spec.tls.insecureSkipVerify under its **Backend** resource (gateway.envoyproxy.io/v1alpha1)

- Kgateway

It provides spec.tls.insecureSkipVerify under its **BackendConfigPolicy** resource (gateway.kgateway.dev/v1alpha1)

## nginx.ingress.kubernetes.io/ssl-passthrough

This is applied to the connection between the client and the gateway (downstream connection). It enables SSL/TLS passthrough mode so the the Gateway forwards encrypted traffic directly to backend pods without terminating TLS at the gateway level. Routing is performed based on the SNI (Server Name Indication) field in the TLS handshake.

**Common use cases**:

- Applications that need to handle TLS termination themselves
- Mutual TLS (mTLS) where the application validates client certificates
- End-to-end encryption requirements
- Legacy applications with embedded TLS configuration

**Performance note**: In NGINX Ingress, this feature introduces a performance penalty as it bypasses NGINX's normal processing and uses a TCP proxy.

The only way to enable passthrough in gateway api is using a TLS listener protocol and a tlsroute.

See more here <https://gateway-api.sigs.k8s.io/guides/tls/>

## nginx.ingress.kubernetes.io/rewrite-target

This annotation permite to change the url path it is sent to the backend service.

Examples:

- You want to expose your app at /v1/api/* but your backend service expects paths without the /v1 prefix.
- Strip application context paths
- Route multiple frontend paths to a single backend path
- Map public URLs to different internal paths

It can be archieved using the standard `URLRewrite` filter in HTTPRoute rules.

### Option 1: ReplacePrefixMatch (most common)

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

### Option 2: ReplaceFullPath

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

### Option 3: Hostname Rewrite

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

### Advanced Implementation-Specific Extensions

- In Envoy Gateway we can use HTTPRouteFilter resource (spec.urlRewrite)
- In Istio we can use VirtualService resource (spec.http)

## nginx.ingress.kubernetes.io/proxy-body-size

This annotation sets the maximum allowed size of the client request body. If the request body exceeds this limit, the gateway returns a 413 (Request Entity Too Large) error.
Usually it is used for

- File upload services
- API endpoints accepting large payloads
- Services handling image/video uploads
- Webhook receivers with large payloads

Security consideration: Setting this value too high can make your service vulnerable to DoS attacks via large request bodies. Set reasonable limits based on your application's actual needs.

The default value in nginx is 1m (1 megabyte) and some common values are: `8m`, `50m`, `100m`, or `0` (unlimited)

- Envoy Gateway

It provides spec.requestBuffer.limit under the **BackendTrafficPolicy** resource. It supports SI units: Ki, Mi, Gi

**Important limitation**: Due to an Envoy limitation, requests with body size ≤ 16KB (16384 bytes) are not rejected. You must specify a value > 16KB for the policy to work correctly.

- Istio

It can be configured using an **EnvoyFilter** resource

- kgateway

It supports request body size limits through its policy mechanisms (similar to Envoy Gateway's BackendTrafficPolicy)

- NGINX Gateway Fabric

It provides spec.body under the **ClientSettingsPolicy** resource

## Links

- Migrating from Ingress

<https://gateway-api.sigs.k8s.io/guides/getting-started/migrating-from-ingress/>

- Nginx ingress controller annotations

<https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/>

- A Welcome Guide for Ingress-NGINX Users

<https://gateway-api.sigs.k8s.io/guides/getting-started/migrating-from-ingress-nginx/>
