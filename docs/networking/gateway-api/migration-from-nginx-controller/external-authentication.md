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

## Gateway API Migration

In Gateway API, external authentication is achieved using implementation-specific policies. The exact approach varies by Gateway implementation:

### Envoy Gateway (Recommended)

Envoy Gateway provides native OIDC authentication through **SecurityPolicy**, eliminating the need for external authentication proxies.

#### Key Concepts

- Uses **SecurityPolicy** resource for OIDC configuration
- Supports OIDC providers: Google, Azure AD, Keycloak, Auth0, etc.
- Can target HTTPRoute or Gateway resources
- Cookie-based session management
- Automatic token refresh

#### Basic Configuration

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: oidc-auth
spec:
  targetRefs:
    - kind: HTTPRoute
      name: myapp
  oidc:
    provider:
      issuer: "https://accounts.google.com"
    clientID: "your-client-id"
    clientSecret:
      name: "client-secret"
    redirectURL: "https://myapp.example.com/oauth2/callback"
    logoutPath: "/oauth2/logout"
    scopes: [openid, email, profile]
```

#### Advanced Features

- **Gateway-wide auth**: Target Gateway resource to protect all routes
- **Cookie domains**: Use `cookieDomain` for subdomain sharing
- **Header forwarding**: Use BackendTrafficPolicy to forward claims

See [Envoy Gateway OIDC docs](https://gateway.envoyproxy.io/docs/tasks/security/oidc) for complete examples.

---

### Istio

Istio does **not** have native OIDC authentication. Instead, it focuses on **JWT validation** and requires external services for OIDC flows.

#### Approach 1: JWT Validation (Recommended)

Use **RequestAuthentication** and **AuthorizationPolicy** for JWT validation:

```yaml
apiVersion: security.istio.io/v1
kind: RequestAuthentication
metadata:
  name: jwt-auth
spec:
  selector:
    matchLabels:
      app: myapp
  jwtRules:
    - issuer: "https://accounts.google.com"
      jwksUri: "https://www.googleapis.com/.well-known/jwks.json"
      audiences: ["myapp.example.com"]
      outputClaimToHeaders:
        - header: x-auth-request-email
          claim: email
---
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: require-jwt
spec:
  selector:
    matchLabels:
      app: myapp
  action: ALLOW
  rules:
    - from:
        - source:
            requestPrincipals: ["*"]  # Require valid JWT
```

**Features**:

- Validates JWT tokens from Authorization header
- Can forward claims to backend via headers
- Supports claim-based authorization rules
- High-performance native validation

#### Approach 2: Full OIDC with OAuth2-Proxy

For complete OIDC flow (login/logout), deploy OAuth2-Proxy and configure via **EnvoyFilter**:

- Deploy OAuth2-Proxy service
- Create EnvoyFilter with ExtAuthz configuration
- Point ExtAuthz to OAuth2-Proxy endpoint

#### Approach 3: Authservice (Istio Ecosystem)

Use [istio-ecosystem/authservice](https://github.com/istio-ecosystem/authservice) for OIDC within the mesh:

- Provides transparent OIDC login/logout
- Token acquisition and refresh
- Session management

**Key Points**:

- No native OIDC: Requires external services
- Best for: JWT validation scenarios
- Complex setup: Multiple components needed for full OIDC

See [Istio RequestAuthentication docs](https://istio.io/latest/docs/reference/config/security/request_authentication/) for details.

---

### Kgateway

Kgateway (from Solo.io) provides OIDC authentication through **ExtAuthPolicy** with advanced features.

#### Key Concepts

- Uses **ExtAuthPolicy** resource (API: `security.policy.gloo.solo.io/v2`)
- Requires ext-auth-server component (included with Kgateway)
- Supports OIDC providers: Google, Azure AD, Keycloak, Okta, Auth0
- Apply to routes via label selectors
- Session storage: Cookie-based or Redis

#### Basic OIDC Configuration

```yaml
apiVersion: security.policy.gloo.solo.io/v2
kind: ExtAuthPolicy
metadata:
  name: oidc-auth
spec:
  applyToRoutes:
    - route:
        labels:
          oauth: "true"
  config:
    server:
      name: ext-auth-server
      namespace: gloo-system
    glooAuth:
      configs:
        - oauth2:
            oidcAuthorizationCode:
              appUrl: "https://myapp.example.com"
              callbackPath: /oauth2/callback
              clientId: "your-client-id"
              clientSecretRef:
                name: oauth-secret
              issuerUrl: "https://accounts.google.com"
              scopes: [openid, email, profile]
              headers:
                idTokenHeader: jwt
              logoutPath: /logout
```

#### Advanced Features

**Redis Session Storage** (production):

```yaml
session:
  failOnFetchFailure: true
  redis:
    cookieName: oidc-session
    options:
      host: redis.gloo-system.svc.cluster.local:6379
```

**JWT Validation**:

```yaml
glooAuth:
  configs:
    - oauth2:
        accessTokenValidation:
          jwt:
            remoteJwks:
              url: https://www.googleapis.com/.well-known/jwks.json
              refreshInterval: 60s
```

**Combined Auth** (OIDC OR JWT):

```yaml
glooAuth:
  configs:
    - oauth2:
        oidcAuthorizationCode: {...}
    - oauth2:
        accessTokenValidation: {...}
  booleanExpr: "configs[0] || configs[1]"  # Either succeeds
```

**Key Points**:

- Most feature-rich OIDC implementation
- Commercial support available (Solo.io Enterprise)
- Requires ext-auth-server deployment
- Best for: Complex auth scenarios, multi-method auth

See [Solo.io ExtAuthPolicy docs](https://docs.solo.io/gloo-mesh-gateway/latest/security/external-auth/oauth/examples/) for complete examples.

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

| Feature                   | Envoy Gateway               | Istio                               | Kgateway                             |
|---------------------------|-----------------------------|-------------------------------------|--------------------------------------|
| **Native OIDC**           | ✅ Built-in (SecurityPolicy) | ❌ Requires OAuth2-Proxy/Authservice | ✅ Built-in (ExtAuthPolicy)           |
| **JWT Validation**        | ✅ Via SecurityPolicy        | ✅ Native (RequestAuthentication)    | ✅ Via ExtAuthPolicy                  |
| **Session Management**    | ✅ Cookie-based              | ⚠️ Via external proxy               | ✅ Cookie or Redis                    |
| **External Proxy Needed** | ❌ No                        | ✅ Yes (for OIDC flow)               | ❌ No                                 |
| **Complexity**            | 🟢 Low (single resource)    | 🔴 High (multiple components)       | 🟡 Medium (requires ext-auth server) |
| **Production Maturity**   | 🟡 Growing                  | 🟢 Very mature                      | 🟢 Mature (Solo.io)                  |
| **Combined Auth Methods** | ⚠️ Limited                  | ✅ Flexible (EnvoyFilter)            | ✅ Boolean expressions                |
| **Commercial Support**    | ❌ Community only            | ✅ Available                         | ✅ Solo.io Enterprise                 |

**Recommendations:**

- **Choose Envoy Gateway** if: You want native OIDC with minimal complexity and are okay with a newer project
- **Choose Istio** if: You only need JWT validation, already use Istio mesh, or need maximum production maturity
- **Choose Kgateway** if: You need advanced auth features, commercial support, or complex auth scenarios (multi-method, API gateway use cases)

**Future:** GEP-2994 is working on standardizing external auth in Gateway API

### Testing

Test your migration thoroughly:

1. **Unauthenticated access**: Verify users are redirected to login
2. **Authentication flow**: Test complete OAuth2/OIDC flow
3. **Header forwarding**: Verify correct headers reach backend
4. **Session management**: Test session expiration and renewal
5. **Error handling**: Test auth service failures

---

## References

### Gateway API

- [Gateway API GEP-2994: External Authorization](https://gateway-api.sigs.k8s.io/geps/gep-2994/)

### Envoy Gateway

- [Envoy Gateway SecurityPolicy API](https://gateway.envoyproxy.io/docs/api/extension_types/#securitypolicy)
- [Envoy Gateway OIDC Authentication](https://gateway.envoyproxy.io/docs/tasks/security/oidc)

### Istio

- [Istio RequestAuthentication](https://istio.io/latest/docs/reference/config/security/request_authentication/)
- [Istio AuthorizationPolicy](https://istio.io/latest/docs/reference/config/security/authorization-policy/)
- [Istio Authservice (OIDC for Istio)](https://github.com/istio-ecosystem/authservice)

### Kgateway

- [Kgateway API Reference](https://kgateway.dev/docs/main/reference/api/)
- [Solo.io ExtAuthPolicy Documentation](https://docs.solo.io/gloo-mesh-gateway/latest/security/external-auth/oauth/examples/)
- [Kgateway OAuth with Keycloak](https://docs.solo.io/gloo-mesh-gateway/latest/security/external-auth/oauth/keycloak/)

### External Auth Tools

- [NGINX Ingress External Authentication](https://kubernetes.github.io/ingress-nginx/examples/auth/external-auth/)
- [OAuth2 Proxy Documentation](https://oauth2-proxy.github.io/oauth2-proxy/)
- [Authelia Documentation](https://www.authelia.com/integration/kubernetes/nginx-ingress/)
