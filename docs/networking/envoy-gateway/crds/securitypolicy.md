# SecurityPolicy

SecurityPolicy provides security controls for routes including CORS, authentication (JWT, OIDC, Basic Auth), authorization, and rate limiting. It implements defense-in-depth security patterns at the gateway level.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `SecurityPolicy`
- **Attachment**: Gateway or HTTPRoute via `targetRef`
- **Purpose**: Implement security controls and policies

## Key Features

- CORS (Cross-Origin Resource Sharing)
- JWT authentication
- OIDC (OpenID Connect) authentication
- Basic authentication
- Authorization policies
- Rate limiting (local and global)
- IP allow/deny lists

## Basic Example

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: api-security
  namespace: default
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: api-route
  cors:
    allowOrigins:
      - "https://example.com"
    allowMethods:
      - GET
      - POST
    allowHeaders:
      - Content-Type
      - Authorization
```

## CORS Configuration

### Simple CORS

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: cors-policy
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: my-route
  cors:
    allowOrigins:
      - "https://app.example.com"
    allowMethods:
      - GET
      - POST
      - PUT
      - DELETE
    allowHeaders:
      - Content-Type
      - Authorization
    maxAge: 86400
```

### Wildcard CORS

```yaml
spec:
  cors:
    allowOrigins:
      - "*"
    allowMethods:
      - GET
      - POST
    allowHeaders:
      - "*"
    exposeHeaders:
      - X-Custom-Header
    allowCredentials: true
    maxAge: 3600
```

### Pattern-Based CORS

```yaml
spec:
  cors:
    allowOrigins:
      - "https://*.example.com"
      - "https://app.*.com"
    allowMethods:
      - GET
      - POST
    allowHeaders:
      - Content-Type
      - Authorization
      - X-API-Key
```

## JWT Authentication

### Basic JWT

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: jwt-auth
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: api-route
  jwt:
    providers:
      - name: auth0
        issuer: https://example.auth0.com/
        audiences:
          - my-api
        remoteJWKS:
          uri: https://example.auth0.com/.well-known/jwks.json
```

### JWT with Multiple Providers

```yaml
spec:
  jwt:
    providers:
      - name: auth0
        issuer: https://example.auth0.com/
        audiences:
          - my-api
        remoteJWKS:
          uri: https://example.auth0.com/.well-known/jwks.json
      - name: okta
        issuer: https://example.okta.com
        audiences:
          - api://default
        remoteJWKS:
          uri: https://example.okta.com/oauth2/default/v1/keys
```

### JWT with Custom Claims

```yaml
spec:
  jwt:
    providers:
      - name: custom-auth
        issuer: https://auth.example.com
        audiences:
          - my-service
        remoteJWKS:
          uri: https://auth.example.com/.well-known/jwks.json
        claimToHeaders:
          - claim: sub
            header: X-User-ID
          - claim: email
            header: X-User-Email
          - claim: roles
            header: X-User-Roles
```

## OIDC Authentication

### Basic OIDC

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: oidc-auth
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: app-route
  oidc:
    provider:
      issuer: https://accounts.google.com
    clientID: my-client-id
    clientSecret:
      name: oidc-client-secret
      key: client-secret
    redirectURL: https://app.example.com/oauth2/callback
    scopes:
      - openid
      - email
      - profile
```

### OIDC with Keycloak

```yaml
spec:
  oidc:
    provider:
      issuer: https://keycloak.example.com/realms/myrealm
      authorizationEndpoint: https://keycloak.example.com/realms/myrealm/protocol/openid-connect/auth
      tokenEndpoint: https://keycloak.example.com/realms/myrealm/protocol/openid-connect/token
    clientID: my-app
    clientSecret:
      name: keycloak-secret
      key: secret
    redirectURL: https://app.example.com/callback
    scopes:
      - openid
      - email
      - profile
      - roles
```

## Basic Authentication

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: basic-auth
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: admin-route
  basicAuth:
    users:
      name: basic-auth-users
      key: .htpasswd
```

Create the secret:

```bash
# Generate password hash
htpasswd -nbB admin secretpassword > .htpasswd

# Create secret
kubectl create secret generic basic-auth-users \
  --from-file=.htpasswd=.htpasswd
```

## Authorization Policies

### Path-Based Authorization

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: authz-policy
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: api-route
  authorization:
    rules:
      - name: admin-only
        action: Allow
        principal:
          jwt:
            claims:
              - name: roles
                values:
                  - admin
```

### Method-Based Authorization

```yaml
spec:
  authorization:
    defaultAction: Deny
    rules:
      - name: read-access
        action: Allow
        principal:
          jwt:
            claims:
              - name: roles
                values:
                  - reader
                  - admin
        when:
          - key: request.method
            values:
              - GET
      - name: write-access
        action: Allow
        principal:
          jwt:
            claims:
              - name: roles
                values:
                  - admin
        when:
          - key: request.method
            values:
              - POST
              - PUT
              - DELETE
```

## Rate Limiting

### Local Rate Limiting

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: rate-limit
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: api-route
  rateLimit:
    type: Local
    local:
      rules:
        - limit:
            requests: 100
            unit: Minute
```

### Per-IP Rate Limiting

```yaml
spec:
  rateLimit:
    type: Local
    local:
      rules:
        - clientSelectors:
            - sourceIP: true
          limit:
            requests: 100
            unit: Minute
```

### Header-Based Rate Limiting

```yaml
spec:
  rateLimit:
    type: Local
    local:
      rules:
        - clientSelectors:
            - headers:
                - name: X-API-Key
                  type: Distinct
          limit:
            requests: 1000
            unit: Hour
```

### Global Rate Limiting

```yaml
spec:
  rateLimit:
    type: Global
    global:
      rules:
        - clientSelectors:
            - sourceIP: true
          limit:
            requests: 10000
            unit: Hour
      rateLimitService:
        backendRef:
          name: ratelimit-service
          port: 8081
```

## IP Allow/Deny Lists

### IP Allowlist

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: ip-allowlist
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: admin-route
  ipAllowList:
    - 10.0.0.0/8
    - 192.168.1.0/24
    - 172.16.0.100/32
```

### IP Denylist

```yaml
spec:
  ipDenyList:
    - 203.0.113.0/24
    - 198.51.100.10/32
```

## Use Cases

### Public API with Rate Limiting

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: public-api-security
  namespace: default
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: public-api
  cors:
    allowOrigins:
      - "*"
    allowMethods:
      - GET
      - POST
    allowHeaders:
      - Content-Type
      - X-API-Key
  rateLimit:
    type: Local
    local:
      rules:
        - clientSelectors:
            - headers:
                - name: X-API-Key
                  type: Distinct
          limit:
            requests: 1000
            unit: Hour
        - clientSelectors:
            - sourceIP: true
          limit:
            requests: 100
            unit: Hour
```

### Secure SPA Application

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: spa-security
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: spa-route
  cors:
    allowOrigins:
      - "https://app.example.com"
    allowMethods:
      - GET
      - POST
      - PUT
      - DELETE
    allowHeaders:
      - Content-Type
      - Authorization
    allowCredentials: true
  jwt:
    providers:
      - name: auth0
        issuer: https://example.auth0.com/
        audiences:
          - my-spa-api
        remoteJWKS:
          uri: https://example.auth0.com/.well-known/jwks.json
```

### Admin Panel Protection

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: admin-security
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: admin-route
  ipAllowList:
    - 10.0.0.0/8  # Internal network only
  basicAuth:
    users:
      name: admin-users
      key: .htpasswd
  rateLimit:
    type: Local
    local:
      rules:
        - limit:
            requests: 100
            unit: Minute
```

### Multi-Tenant API

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: multi-tenant-api
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: tenant-api
  jwt:
    providers:
      - name: tenant-auth
        issuer: https://auth.example.com
        audiences:
          - tenant-api
        remoteJWKS:
          uri: https://auth.example.com/.well-known/jwks.json
        claimToHeaders:
          - claim: tenant_id
            header: X-Tenant-ID
          - claim: roles
            header: X-User-Roles
  authorization:
    defaultAction: Deny
    rules:
      - name: tenant-access
        action: Allow
        principal:
          jwt:
            claims:
              - name: tenant_id
                values: ["*"]
  rateLimit:
    type: Local
    local:
      rules:
        - clientSelectors:
            - headers:
                - name: X-Tenant-ID
                  type: Distinct
          limit:
            requests: 10000
            unit: Hour
```

### Internal Service with mTLS

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: internal-mtls
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: internal-gateway
  ipAllowList:
    - 10.0.0.0/8
  clientCertificateAuth:
    caCertificateRefs:
      - name: internal-ca
        kind: Secret
```

### Progressive Rate Limiting

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: progressive-rate-limit
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: api-route
  rateLimit:
    type: Local
    local:
      rules:
        # Free tier - 10 requests per minute
        - clientSelectors:
            - headers:
                - name: X-API-Tier
                  value: free
          limit:
            requests: 10
            unit: Minute
        # Pro tier - 100 requests per minute
        - clientSelectors:
            - headers:
                - name: X-API-Tier
                  value: pro
          limit:
            requests: 100
            unit: Minute
        # Enterprise tier - 1000 requests per minute
        - clientSelectors:
            - headers:
                - name: X-API-Tier
                  value: enterprise
          limit:
            requests: 1000
            unit: Minute
        # Default - 50 requests per minute
        - limit:
            requests: 50
            unit: Minute
```

## Policy Precedence

1. HTTPRoute-level policies override Gateway-level policies
2. More specific targetRef takes precedence
3. Multiple SecurityPolicies on same target are merged
4. Rate limit rules are evaluated in order

## Best Practices

1. **Start with deny-by-default** - Explicitly allow what's needed
2. **Use JWT over Basic Auth** - Better security and scalability
3. **Implement rate limiting** - Prevent abuse and DoS
4. **Restrict CORS** - Don't use wildcard in production
5. **Combine multiple controls** - Defense in depth
6. **Monitor auth failures** - Track 401/403 responses
7. **Rotate secrets regularly** - JWT signing keys, client secrets
8. **Use IP allowlists carefully** - Consider NAT and proxies
9. **Test authorization rules** - Verify intended access patterns
10. **Log security events** - Audit authentication and authorization

## Troubleshooting

### CORS Issues

Check browser console for CORS errors and verify:
- `allowOrigins` includes the request origin
- `allowMethods` includes the request method
- `allowHeaders` includes all request headers
- `allowCredentials` set correctly

### JWT Authentication Failures

Common issues:
- Incorrect issuer URL
- Audience mismatch
- Expired tokens
- JWKS endpoint unreachable
- Clock skew

Check Envoy logs:

```bash
kubectl logs -n envoy-gateway-system \
  -l gateway.envoyproxy.io/owning-gateway-name=my-gateway | grep -i jwt
```

### Rate Limiting Not Working

Verify:
- Client selectors match traffic
- Limits are not too high
- Rate limit service (for global) is running
- Time units are correct

### IP Allowlist Issues

Consider:
- Traffic through proxies/load balancers
- X-Forwarded-For configuration
- CIDR notation correctness
- IPv4 vs IPv6

## Security Considerations

- **Never log secrets** - Avoid logging JWTs, API keys
- **Use HTTPS** - Always encrypt in production
- **Validate JWT claims** - Check issuer, audience, expiry
- **Rate limit authentication** - Prevent brute force
- **Monitor anomalies** - Unusual traffic patterns
- **Keep dependencies updated** - Security patches
- **Use strong secrets** - High entropy passwords/keys
- **Implement timeout** - For authentication checks

## Related Resources

- [ClientTrafficPolicy](clienttrafficpolicy.md) - Client connection settings
- [EnvoyExtensionPolicy](envoyextensionpolicy.md) - External authentication
- [HTTPRouteFilter](httproutefilter.md) - Request/response modification
- [OIDC Specification](https://openid.net/connect/) - OpenID Connect
- [JWT Specification](https://jwt.io/) - JSON Web Tokens
