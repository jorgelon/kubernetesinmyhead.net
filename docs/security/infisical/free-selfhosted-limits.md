# Free Self-Hosted Limits

## Community Edition (Free)

The self-hosted Community Edition (CE) has no enforced limits on:

- Number of users and machine identities
- Number of projects and environments
- Number of secrets stored and retrieved
- Secret versioning and history
- Dynamic secrets
- Secret rotation
- Audit logs (basic)
- Native integrations (AWS, GCP, Azure, GitHub, etc.)
- Kubernetes operator (InfisicalSecret CRD)
- CLI and SDKs
- SMTP and webhook support

## Enterprise Features

Some features require a paid Enterprise license applied to the self-hosted instance.

### Pro vs Enterprise comparison

| Feature                         | Pro | Enterprise |
|---------------------------------|-----|------------|
| SAML SSO (Okta, Azure AD, etc.) | Yes | Yes        |
| LDAP / Active Directory         | No  | Yes        |
| SCIM provisioning               | No  | Yes        |
| Custom roles (RBAC)             | Yes | Yes        |
| IP allowlisting                 | Yes | Yes        |
| Secret approval policies        | Yes | Yes        |
| Access requests                 | Yes | Yes        |
| Audit log streaming             | No  | Yes        |
| HSM encryption                  | No  | Yes        |
| Custom rate limits              | No  | Yes        |
| Priority support and SLA        | No  | Yes        |

> Feature availability may change with new releases. Check the official self-hosting EE page for the current list.

## Rate Limits

Self-hosted Community Edition instances ship with default hardcoded rate limits at the application layer (Express middleware). These limits are not configurable without an Enterprise license.

**Custom rate limit configuration is an Enterprise-only feature.** The Server Admin Console exposes a Rate Limit tab, but modifying it requires a paid license. Without an Enterprise license, you are bound by the default limits baked into the server.

> This is distinct from Infisical Cloud, which enforces separate per-plan rate limits.

### Infisical Kubernetes operator and resyncInterval

The Infisical Kubernetes operator syncs secrets using the `resyncInterval` field on the `InfisicalSecret` CRD (default: 60 seconds).

**Short `resyncInterval` values can trigger rate limit errors on self-hosted CE.** The official documentation explicitly warns: *"Shorter time between re-syncs will require higher rate limits only available on paid plans."* A high volume of `InfisicalSecret` CRDs all polling at the default 60-second interval simultaneously is a common cause of `429 Too Many Requests` / `RateLimitExceeded` errors.

To reduce rate limit pressure without an Enterprise license:

- Increase `resyncInterval` on all `InfisicalSecret` CRDs (e.g., `300` or `600` seconds)
- Avoid deploying many CRDs with the same short interval in the same namespace or cluster
- Monitor `API_errors_count` in Prometheus to detect throttling

### External Secrets Operator (ESO) and refreshInterval

When using [External Secrets Operator](https://external-secrets.io) with Infisical as a backend (`ClusterSecretStore` / `SecretStore` of type `infisical`), each `ExternalSecret` resource polls the Infisical API independently on its `refreshInterval` (default: `1h`).

**A large number of `ExternalSecret` resources with short `refreshInterval` values will multiply API calls and can exhaust the default CE rate limits**, producing `429 Too Many Requests` errors in the ESO controller logs.

Estimate your request rate: `number of ExternalSecrets × (3600 / refreshInterval_in_seconds)` requests per hour.

To reduce rate limit pressure without an Enterprise license:

- Increase `refreshInterval` on `ExternalSecret` resources (e.g., `5m` or `10m` instead of the default `1h` if you reduced it)
- Avoid setting very short intervals (e.g., `30s`) on many resources simultaneously
- Use a single `ClusterSecretStore` for all namespaces to avoid duplicated connections
- Monitor ESO controller logs and the `externalsecrets_sync_calls_error_total` Prometheus metric to detect throttling

## Links

- <https://infisical.com/pricing>
- <https://infisical.com/docs/self-hosting/ee>
- <https://infisical.com/docs/api-reference/overview/introduction>
- <https://questions.infisical.com/kb/t/self-hosting-limits-and-team-members/2Mc7>
- <https://external-secrets.io/latest/provider/infisical/>
- <https://external-secrets.io/latest/api/externalsecret/>
