# SecurityPolicy

SecurityPolicy is an EnvoyGateway CRD that implements security controls at the gateway or route level. It enforces access policies, authentication, and traffic management.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `SecurityPolicy`
- **Scope**: Gateway or HTTPRoute via `targetRef`
- **Purpose**: Enforce security policies and access controls

## What SecurityPolicy Permits

### Authentication Methods

- **JWT**: Validate JSON Web Tokens from configured issuers (Auth0, Okta, custom providers)
- **OIDC**: OpenID Connect-based authentication with providers like Google, Keycloak
- **Basic Auth**: Username/password authentication with htpasswd-stored credentials
- **mTLS**: Client certificate validation

### Authorization Controls

- Role-based access control (RBAC) using JWT claims
- Method-based rules (allow specific HTTP verbs per role)
- Deny-by-default with explicit allow rules
- Claim-to-header mapping for downstream services

### Cross-Origin Resource Sharing (CORS)

- Restrict origins (specific hosts, wildcards, patterns)
- Control allowed HTTP methods
- Manage request/response headers
- Configure preflight caching and credentials

### Rate Limiting

- **Local**: Per-Envoy-instance rate limiting
- **Global**: Distributed rate limiting via external service
- Client selection by source IP, headers, or query parameters
- Flexible time units (minute, hour, day)

### IP-Based Access Control

- Allowlists: Restrict to specific CIDR ranges
- Denylists: Block specific IP ranges
- Support for IPv4 and IPv6

## Attachment

Policies attach to either:

- Gateway (applies to all routes)
- HTTPRoute (specific route)

HTTPRoute policies override Gateway policies.

## Official Documentation

- [JWT Authentication](https://gateway.envoyproxy.io/docs/tasks/security/jwt-authentication/)
- [JWT Claim-Based Authorization](https://gateway.envoyproxy.io/docs/tasks/security/jwt-claim-authorization/)
- [OIDC Authentication](https://gateway.envoyproxy.io/docs/tasks/security/oidc/)
- [Basic Authentication](https://gateway.envoyproxy.io/docs/tasks/security/basic-auth/)
- [API Key Authentication](https://gateway.envoyproxy.io/docs/tasks/security/apikey-auth/)
- [CORS](https://gateway.envoyproxy.io/docs/tasks/security/cors/)
- [IP Allowlist/Denylist](https://gateway.envoyproxy.io/docs/tasks/security/restrict-ip-access/)
- [External Authorization](https://gateway.envoyproxy.io/docs/tasks/security/ext-auth/)
- [HTTP Header and Method Based Authorization](https://gateway.envoyproxy.io/docs/tasks/security/http-header-method-auth/)
- [Credential Injection](https://gateway.envoyproxy.io/docs/tasks/security/credential-injection/)
- [Local Rate Limit](https://gateway.envoyproxy.io/docs/tasks/traffic/local-rate-limit/)
- [Global Rate Limit](https://gateway.envoyproxy.io/docs/tasks/traffic/global-rate-limit/)

## Related Resources

- [ClientTrafficPolicy](clienttrafficpolicy.md) - Connection management
- [EnvoyExtensionPolicy](envoyextensionpolicy.md) - External services
- [HTTPRouteFilter](httproutefilter.md) - Request/response modification
