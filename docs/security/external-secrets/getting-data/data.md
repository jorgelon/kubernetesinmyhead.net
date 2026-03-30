# spec.data in ExternalSecret

`spec.data` defines an explicit list of key mappings between the external provider
and the resulting Kubernetes Secret. Each entry fetches exactly one key.

> If multiple entries produce the same `secretKey`, the last one wins.

## Structure per entry

Each entry in the `spec.data` array has:

- `secretKey` (mandatory) — the key name in the resulting Kubernetes Secret
- `remoteRef` (mandatory) — reference to the secret in the external provider
- `sourceRef` (optional) — override the secret store for this specific entry

### remoteRef fields

| Field                | Required | Description                                                       |
|----------------------|----------|-------------------------------------------------------------------|
| `key`                | Yes      | The key (path/name) of the secret in the provider                 |
| `property`           | No       | Sub-field within the secret (e.g. a JSON property)                |
| `version`            | No       | Specific version of the secret to fetch                           |
| `metadataPolicy`     | No       | Whether to fetch metadata alongside the value (`None` or `Fetch`) |
| `conversionStrategy` | No       | How to convert the fetched value (`Default` or `Unicode`)         |
| `decodingStrategy`   | No       | How to decode the value (`None`, `Base64`, `Base64URL`, `Auto`)   |

### sourceRef fields

Overrides `spec.secretStoreRef` for this specific entry. Useful when keys come
from different stores within the same ExternalSecret.

| Field           | Required | Description                                     |
|-----------------|----------|-------------------------------------------------|
| `storeRef.name` | Yes      | Name of the SecretStore or ClusterSecretStore   |
| `storeRef.kind` | No       | `SecretStore` (default) or `ClusterSecretStore` |

## Examples

### Basic key mapping

```yaml
spec:
  data:
  - secretKey: db-password
    remoteRef:
      key: prod/myapp/database
      property: password
```

### Multiple keys from the same secret

```yaml
spec:
  data:
  - secretKey: db-user
    remoteRef:
      key: prod/myapp/database
      property: username
  - secretKey: db-password
    remoteRef:
      key: prod/myapp/database
      property: password
```

### Fetching a specific version

```yaml
spec:
  data:
  - secretKey: api-key
    remoteRef:
      key: prod/myapp/api
      version: "2"
```

### Fetching with metadata

```yaml
spec:
  data:
  - secretKey: api-key
    remoteRef:
      key: prod/myapp/api
      metadataPolicy: Fetch
```

### Per-entry store override with sourceRef

```yaml
spec:
  data:
  - secretKey: db-password
    remoteRef:
      key: prod/myapp/database
      property: password
    sourceRef:
      storeRef:
        name: another-secretstore
        kind: ClusterSecretStore
```

### Decoding a base64-encoded value

```yaml
spec:
  data:
  - secretKey: tls-cert
    remoteRef:
      key: prod/myapp/tls
      property: cert
      decodingStrategy: Base64
```

## Links

- ExternalSecret API spec: <https://external-secrets.io/latest/api/spec/#external-secrets.io/v1beta1.ExternalSecretData>
- ExternalSecretDataRemoteRef: <https://external-secrets.io/latest/api/spec/#external-secrets.io/v1beta1.ExternalSecretDataRemoteRef>
