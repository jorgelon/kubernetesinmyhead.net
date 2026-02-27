# Endpoints

Keycloak exposes endpoints across 4 groups. The base URL for each group impacts token
issuance, redirect link generation, and OIDC discovery.

## Frontend group

Publicly accessible. Used for browser-based flows and user interaction.

| Path                                                  | Description                            |
|-------------------------------------------------------|----------------------------------------|
| `/realms/{realm}/protocol/openid-connect/auth`        | OIDC Authorization / Login             |
| `/realms/{realm}/protocol/saml`                       | SAML SSO                               |
| `/realms/{realm}/protocol/openid-connect/auth/device` | Device Authorization                   |
| `/realms/{realm}/login-actions/...`                   | Consent / Registration actions         |
| `/realms/{realm}/account/`                            | Account management (user self-service) |
| `/realms/{realm}/.well-known/openid-configuration`    | OIDC Discovery Document                |

## Backend group

Programmatic client-to-server communication. Handles token operations without user interaction.

| Path                                                       | Description                |
|------------------------------------------------------------|----------------------------|
| `/realms/{realm}/protocol/openid-connect/token`            | Token Endpoint             |
| `/realms/{realm}/protocol/openid-connect/token/introspect` | Token Introspection        |
| `/realms/{realm}/protocol/openid-connect/logout`           | End Session (Logout)       |
| `/realms/{realm}/protocol/openid-connect/revoke`           | Token Revocation           |
| `/realms/{realm}/protocol/openid-connect/userinfo`         | Userinfo                   |
| `/realms/{realm}/protocol/openid-connect/certs`            | JWKS URI                   |
| `/realms/{realm}/clients-registrations/...`                | Client Registration        |
| `/realms/{realm}/protocol/saml/descriptor`                 | SAML Descriptor (metadata) |

## Administration group

Not exposed publicly.

| Path                        | Description                               |
|-----------------------------|-------------------------------------------|
| `/admin/`                   | Administration Console (web UI)           |
| `/admin/realms/{realm}/...` | Admin REST API                            |
| `/resources/`               | Static assets (CSS, JS for admin console) |

## Management interface

Dedicated port 9000 (separate from the main server). Health is enabled by default; metrics
require opt-in via `KC_METRICS_ENABLED` or `spec.additionalOptions`.

| Path              | Purpose            |
|-------------------|--------------------|
| `/health/ready`   | Readiness probe    |
| `/health/live`    | Liveness probe     |
| `/health/started` | Startup probe      |
| `/metrics`        | Prometheus metrics |

Port: `KC_HTTP_MANAGEMENT_PORT` / `spec.httpManagement.port` (default 9000).

## Exposure recommendations

Only expose HTTPS (port 8443 via `KC_HTTPS_PORT`). Do not enable HTTP.

| Path          | Exposure      | Notes                                           |
|---------------|---------------|-------------------------------------------------|
| `/realms/`    | Public        | Core OIDC/SAML endpoints                        |
| `/resources/` | Public        | Static assets for login pages and admin console |
| `/js/`        | Public        | Keycloak JS adapter                             |
| `/admin/`     | Internal only | Admin UI and REST API                           |
| `/health`     | Internal only | Management interface — port 9000                |
| `/metrics`    | Internal only | Management interface — port 9000                |

### Admin console access

The admin web UI (`/admin/`) should be exposed on a **separate hostname** using
`--hostname-admin` / `KC_HOSTNAME_ADMIN` / `spec.hostname.admin`. The admin console also
needs `/resources/` for its static assets (already public).

> Never expose `/admin/` on the same public hostname as the frontend. Restrict it to a VPN,
> internal network, or a separate ingress with IP allowlisting.

### Internal pod calls via the Kubernetes service

When a pod calls Keycloak using the internal Kubernetes service DNS name
(e.g., `keycloak-service.keycloak.svc.cluster.local`), the `Host` header contains that name
— not the configured `KC_HOSTNAME`.

With `hostname-strict: true` (default), Keycloak **rejects** these requests. Two solutions:

#### Option 1 - backchannel dynamic resolution (`KC_HOSTNAME_BACKCHANNEL_DYNAMIC` / `spec.hostname.backchannelDynamic`)

Keycloak accepts requests from any hostname on the backchannel. Issued tokens still carry the
public `KC_HOSTNAME` in the `iss` claim, so token validation against the JWKS URI is
unaffected.

#### Option 2 - split-horizon DNS

Configure in-cluster DNS so the public hostname resolves to the internal service ClusterIP.
Pods use the public hostname; `Host` headers match; tokens are fully consistent. More complex
to set up but behaviorally identical to external traffic.

## Links

- Configuring the hostname (v2): <https://www.keycloak.org/server/hostname>
- Management Interface: <https://www.keycloak.org/server/management-interface>
- Configuring a reverse proxy: <https://www.keycloak.org/server/reverseproxy>
- Configuring Keycloak for production: <https://www.keycloak.org/server/configuration-production>
