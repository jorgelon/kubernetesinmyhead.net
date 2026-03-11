# Authentication

## How kubectl Locates Credentials

When kubectl runs, it resolves authentication configuration in the following order:

1. `--kubeconfig` flag — explicitly specified path on the command line
2. `KUBECONFIG` environment variable — single path or colon-separated list of paths
3. `~/.kube/config` — default location in the user's home directory
4. In-cluster configuration — when running inside a Kubernetes pod

When `KUBECONFIG` contains multiple files, kubectl merges them into a single configuration at runtime.

## Kubeconfig Structure

A kubeconfig file has four main sections:

| Section           | Description                                                     |
|-------------------|-----------------------------------------------------------------|
| `clusters`        | API server URLs and their CA certificates                       |
| `users`           | Authentication credentials (tokens, client certs, exec plugins) |
| `contexts`        | Named combinations of cluster + user + namespace                |
| `current-context` | The active context used by default                              |

## Authentication Methods

### Client Certificates

The user presents an X.509 certificate signed by the cluster CA. The `CN` field becomes the username and `O` fields become the groups.

```yaml
users:
- name: admin
  user:
    client-certificate: /path/to/client.crt
    client-key: /path/to/client.key
```

### Bearer Tokens

A static token sent in the `Authorization: Bearer <token>` HTTP header.

```yaml
users:
- name: ci-bot
  user:
    token: whatever...
```

### OIDC (OpenID Connect)

Delegates authentication to an external identity provider (Dex, Keycloak, Azure AD, etc.).
kubectl obtains an ID token from the provider and sends it as a bearer token. The API server
validates it against the configured OIDC issuer.

> The built-in `oidc` auth-provider is deprecated since Kubernetes 1.26. Use exec plugins (e.g., `kubelogin`) instead.

### Exec Plugins

The recommended approach for external auth systems. kubectl calls an external binary that
returns credentials dynamically. The binary output must conform to the
`client.authentication.k8s.io` API.

Common plugins:

- **`kubelogin`** — OIDC login flow for Azure AD, Dex, Keycloak
- **`aws eks get-token`** — AWS IAM-based authentication for EKS clusters

```yaml
users:
- name: eks-user
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
      - eks
      - get-token
      - --cluster-name
      - my-cluster
```

kubectl re-executes the plugin automatically when the returned token expires.

## In-Cluster Authentication

When a workload runs inside a pod, it uses the mounted service account token. The API server
validates this token against the TokenReview API.

| File                                                      | Purpose                |
|-----------------------------------------------------------|------------------------|
| `/var/run/secrets/kubernetes.io/serviceaccount/token`     | JWT bearer token       |
| `/var/run/secrets/kubernetes.io/serviceaccount/ca.crt`    | Cluster CA certificate |
| `/var/run/secrets/kubernetes.io/serviceaccount/namespace` | Current namespace      |

Since Kubernetes 1.21, **projected service account tokens** are the default. They are
short-lived, audience-bound, and automatically rotated by the kubelet.

## Authentication Flow

```text
kubectl
  └─ resolves kubeconfig
       └─ selects context (cluster + user + namespace)
            └─ applies auth method (cert / token / exec plugin)
                 └─ sends HTTPS request to API server
                          │
                          ▼
                 API server authenticators (tried in order)
                          │
                          ▼
                 RBAC authorization
                          │
                          ▼
                 Admission controllers
                          │
                          ▼
                 Request processed
```

The API server tries each enabled authenticator in order and uses the first one that
succeeds. Requests that match no authenticator are treated as `system:anonymous`.
