# External Authentication

This guide covers how to migrate NGINX Ingress Controller external authentication annotations to Gateway API.

## NGINX Ingress Annotations Overview

NGINX Ingress Controller provides three key annotations for external authentication:

### nginx.ingress.kubernetes.io/auth-url

**Purpose**: Specifies the URL of the external authentication service that validates requests.

**How it works**: Before forwarding a request to the backend, NGINX sends a subrequest to this URL. If the auth service returns 2xx, the request proceeds. If it returns 401/403, access is denied.

**Example**:

```yaml
nginx.ingress.kubernetes.io/auth-url: "https://oauth2-proxy.auth-system.svc.cluster.local/oauth2/auth"
```

**Common values**:

- OAuth2 Proxy: `http://oauth2-proxy.namespace.svc.cluster.local/oauth2/auth`
- Authelia: `http://authelia.namespace.svc.cluster.local/api/verify`
- Custom auth service: `http://my-auth.namespace.svc.cluster.local/verify`

---

### nginx.ingress.kubernetes.io/auth-signin

**Purpose**: Specifies where to redirect users when authentication fails (401/403).

**How it works**: When the auth service denies access, NGINX redirects the user to this URL to initiate authentication (e.g., OAuth2 login flow).

**Example**:

```yaml
nginx.ingress.kubernetes.io/auth-signin: "https://oauth2-proxy.example.com/oauth2/start?rd=$escaped_request_uri"
```

**Common patterns**:

- OAuth2 Proxy: `https://auth.example.com/oauth2/start?rd=$escaped_request_uri`
- Authelia: `https://auth.example.com/?rd=$escaped_request_uri`
- Custom redirect: `https://login.example.com/login?redirect_uri=$scheme://$host$request_uri`

**Variables available**:

- `$escaped_request_uri` - The original request URI (URL-encoded)
- `$scheme` - http or https
- `$host` - Original hostname
- `$request_uri` - Full request URI

---

### nginx.ingress.kubernetes.io/auth-response-headers

**Purpose**: Forwards specific headers from the authentication response to the backend application.

**How it works**: After successful authentication, the auth service returns headers (like user email, groups, tokens). This annotation specifies which headers to forward to your backend.

**Example**:

```yaml
nginx.ingress.kubernetes.io/auth-response-headers: X-Auth-Request-User,X-Auth-Request-Email,X-Auth-Request-Access-Token
```

**Common headers forwarded**:

- `X-Auth-Request-User` - Username or user ID
- `X-Auth-Request-Email` - User email address
- `X-Auth-Request-Groups` - User groups/roles
- `X-Auth-Request-Access-Token` - OAuth2 access token
- `X-Auth-Request-Preferred-Username` - Preferred username from OIDC

---

## Complete NGINX Example

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: protected-app
  annotations:
    nginx.ingress.kubernetes.io/auth-url: "http://oauth2-proxy.auth-system.svc.cluster.local/oauth2/auth"
    nginx.ingress.kubernetes.io/auth-signin: "https://auth.example.com/oauth2/start?rd=$escaped_request_uri"
    nginx.ingress.kubernetes.io/auth-response-headers: "X-Auth-Request-User,X-Auth-Request-Email,X-Auth-Request-Groups"
spec:
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app
            port:
              number: 80
```

---

## Gateway API Migration

In Gateway API, external authentication is achieved using implementation-specific policies. The exact approach varies by Gateway implementation:

### Envoy Gateway

Envoy Gateway provides native OIDC support through **SecurityPolicy** and can forward headers via **BackendTrafficPolicy**:

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: oauth2-policy
  namespace: default
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: protected-route
  oidc:
    provider:
      issuer: "https://auth.example.com"
      authorizationEndpoint: "https://auth.example.com/oauth2/authorize"
      tokenEndpoint: "https://auth.example.com/oauth2/token"
    clientID: "my-client-id"
    clientSecret:
      name: oauth2-client-secret
    redirectURL: "https://app.example.com/oauth2/callback"
    logoutPath: "/oauth2/logout"
    scopes:
    - openid
    - email
    - profile
---
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: BackendTrafficPolicy
metadata:
  name: add-auth-headers
  namespace: default
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: protected-route
  requestHeaders:
    set:
    - name: X-User-Email
      value: "%REQ(X-Auth-Request-Email)%"
    - name: X-User-Name
      value: "%REQ(X-Auth-Request-User)%"
    - name: X-User-Groups
      value: "%REQ(X-Auth-Request-Groups)%"
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: protected-route
  namespace: default
spec:
  parentRefs:
  - name: my-gateway
  hostnames:
  - "app.example.com"
  rules:
  - backendRefs:
    - name: my-app
      port: 80
```

**For external auth service (not native OIDC)**:

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: external-auth
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: protected-route
  extAuth:
    http:
      backendRef:
        name: oauth2-proxy
        namespace: auth-system
        port: 4180
      path: /oauth2/auth
      headersToBackend:
      - X-Auth-Request-User
      - X-Auth-Request-Email
      - X-Auth-Request-Groups
```

---

### Istio

Istio uses **RequestAuthentication** and **AuthorizationPolicy** for JWT-based authentication:

```yaml
apiVersion: security.istio.io/v1
kind: RequestAuthentication
metadata:
  name: jwt-auth
  namespace: default
spec:
  selector:
    matchLabels:
      app: my-app
  jwtRules:
  - issuer: "https://auth.example.com"
    jwksUri: "https://auth.example.com/.well-known/jwks.json"
    forwardOriginalToken: true
    outputPayloadToHeader: X-JWT-Payload
---
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: require-jwt
  namespace: default
spec:
  selector:
    matchLabels:
      app: my-app
  action: ALLOW
  rules:
  - from:
    - source:
        requestPrincipals: ["*"]
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: protected-route
  namespace: default
spec:
  parentRefs:
  - name: my-gateway
  hostnames:
  - "app.example.com"
  rules:
  - filters:
    - type: RequestHeaderModifier
      requestHeaderModifier:
        add:
        - name: X-User-Email
          value: "%JWT_CLAIM(email)%"
        - name: X-User-Name
          value: "%JWT_CLAIM(name)%"
        - name: X-User-Groups
          value: "%JWT_CLAIM(groups)%"
    backendRefs:
    - name: my-app
      port: 80
```

**For external OAuth2 Proxy integration**:

```yaml
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: ext-authz
  namespace: default
spec:
  selector:
    matchLabels:
      app: my-app
  action: CUSTOM
  provider:
    name: oauth2-proxy
  rules:
  - to:
    - operation:
        paths: ["/*"]
```

---

### Kgateway

Kgateway uses **ExtAuthPolicy** with detailed configuration:

```yaml
apiVersion: gateway.kgateway.dev/v1alpha1
kind: ExtAuthPolicy
metadata:
  name: oauth2-auth
  namespace: default
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: protected-route
  config:
    server:
      name: oauth2-proxy
      namespace: auth-system
      port: 4180
    requestPath: /oauth2/auth
    failureMode: deny
    requestTimeout: 5s
    headerOptions:
      headersToForward:
      - X-Auth-Request-User
      - X-Auth-Request-Email
      - X-Auth-Request-Groups
      - X-Auth-Request-Access-Token
    redirectOptions:
      redirectUrl: "https://auth.example.com/oauth2/start"
      redirectParameters:
        rd: "$request_uri"
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: protected-route
  namespace: default
spec:
  parentRefs:
  - name: my-gateway
  hostnames:
  - "app.example.com"
  rules:
  - backendRefs:
    - name: my-app
      port: 80
```

---

## Migration Mapping Table

| NGINX Annotation        | Gateway API Equivalent                                                   | Implementation          |
|-------------------------|--------------------------------------------------------------------------|-------------------------|
| `auth-url`              | SecurityPolicy/ExtAuthPolicy `backendRef` or `server`                    | Implementation-specific |
| `auth-signin`           | SecurityPolicy/ExtAuthPolicy `redirectURL` or `signInPath`               | Implementation-specific |
| `auth-response-headers` | SecurityPolicy/ExtAuthPolicy `headersToBackend` or `authResponseHeaders` | Implementation-specific |

---

## Common Use Cases

### Use Case 1: OAuth2 Proxy with Google Auth

**NGINX Ingress**:

```yaml
annotations:
  nginx.ingress.kubernetes.io/auth-url: "http://oauth2-proxy.auth.svc.cluster.local/oauth2/auth"
  nginx.ingress.kubernetes.io/auth-signin: "https://auth.example.com/oauth2/start?rd=$escaped_request_uri"
  nginx.ingress.kubernetes.io/auth-response-headers: "X-Auth-Request-User,X-Auth-Request-Email"
```

**Envoy Gateway**:

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
spec:
  oidc:
    provider:
      issuer: "https://accounts.google.com"
    clientID: "your-client-id"
    scopes: ["openid", "email", "profile"]
```

---

### Use Case 2: Authelia for SSO

**NGINX Ingress**:

```yaml
annotations:
  nginx.ingress.kubernetes.io/auth-url: "http://authelia.auth.svc.cluster.local/api/verify"
  nginx.ingress.kubernetes.io/auth-signin: "https://auth.example.com/?rd=$escaped_request_uri"
  nginx.ingress.kubernetes.io/auth-response-headers: "Remote-User,Remote-Groups,Remote-Email"
```

**Kgateway**:

```yaml
apiVersion: gateway.kgateway.dev/v1alpha1
kind: ExtAuthPolicy
metadata:
  name: authelia-auth
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: protected-route
  config:
    server:
      name: authelia
      namespace: auth
      port: 9091
    requestPath: /api/verify
    failureMode: deny
    headerOptions:
      headersToForward:
      - Remote-User
      - Remote-Groups
      - Remote-Email
    redirectOptions:
      redirectUrl: "https://auth.example.com/"
      redirectParameters:
        rd: "$request_uri"
```

---

### Use Case 3: Custom Auth Service with JWT

**NGINX Ingress**:

```yaml
annotations:
  nginx.ingress.kubernetes.io/auth-url: "http://custom-auth.auth.svc.cluster.local/validate"
  nginx.ingress.kubernetes.io/auth-signin: "https://login.example.com/login?redirect=$scheme://$host$request_uri"
  nginx.ingress.kubernetes.io/auth-response-headers: "X-User-ID,X-User-Roles,X-Session-ID"
```

**Istio**:

```yaml
apiVersion: security.istio.io/v1
kind: RequestAuthentication
spec:
  jwtRules:
  - issuer: "https://auth.example.com"
    jwksUri: "https://auth.example.com/.well-known/jwks.json"
```

---

## Important Considerations

### Security

- **Header Injection**: Be careful which headers you forward to avoid header injection attacks
- **Token Exposure**: Avoid forwarding sensitive tokens unless necessary
- **Validation**: Always validate auth service responses
- **TLS**: Use HTTPS for auth service communication in production

### Performance

- **Latency**: External auth adds latency to every request
- **Caching**: Implement caching in auth service when possible
- **Connection Pooling**: Configure connection pooling to auth service
- **Timeouts**: Set appropriate timeouts to avoid cascading failures

### Gateway Implementation Differences

- **Native OIDC**: Envoy Gateway has built-in OIDC support
- **JWT-Only**: Istio focuses on JWT-based authentication
- **External Auth**: Kgateway supports external auth services
- **Standardization**: GEP-2994 is working on standardizing external auth in Gateway API

### Testing

Test your migration thoroughly:

1. **Unauthenticated access**: Verify users are redirected to login
2. **Authentication flow**: Test complete OAuth2/OIDC flow
3. **Header forwarding**: Verify correct headers reach backend
4. **Session management**: Test session expiration and renewal
5. **Error handling**: Test auth service failures

---

## References

- [Gateway API GEP-2994: External Authorization](https://gateway-api.sigs.k8s.io/geps/gep-2994/)
- [Envoy Gateway Security Policy](https://gateway.envoyproxy.io/docs/api/extension_types/#securitypolicy)
- [Istio Request Authentication](https://istio.io/latest/docs/reference/config/security/request_authentication/)
- [NGINX Ingress External Authentication](https://kubernetes.github.io/ingress-nginx/examples/auth/external-auth/)
- [OAuth2 Proxy Documentation](https://oauth2-proxy.github.io/oauth2-proxy/)
- [Authelia Documentation](https://www.authelia.com/integration/kubernetes/nginx-ingress/)
