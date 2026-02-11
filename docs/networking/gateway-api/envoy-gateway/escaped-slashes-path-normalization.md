# Escaped slashes and path normalization

Envoy's default behavior for URLs containing `%2F` (URL-encoded `/`) is `UnescapeAndRedirect`. This means Envoy decodes `%2F` back to `/`, normalizes the path, and issues a 307 redirect with the decoded URL.

This breaks applications that rely on `%2F` as a literal value in the path rather than a path separator.

## RabbitMQ Management API example

RabbitMQ Management API uses `%2F` to represent the default vhost `/` in URL paths:

```text
GET /api/permissions/%2F/agent_2048
```

With the default Envoy behavior:

1. Envoy receives `/api/permissions/%2F/agent_2048`
2. Decodes `%2F` to `/`, resulting in `/api/permissions//agent_2048`
3. Merges the double slash `//` into `/`, resulting in `/api/permissions/agent_2048`
4. Issues a 307 redirect with the normalized path
5. RabbitMQ API receives the wrong path and the call fails

## Fix: ClientTrafficPolicy

Apply a `ClientTrafficPolicy` targeting the Gateway listener with two settings:

- **`escapedSlashesAction: KeepUnchanged`**: Preserves `%2F` as-is without decoding
- **`disableMergeSlashes: true`**: Prevents `//` from being collapsed to `/`

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: ClientTrafficPolicy
metadata:
  name: https
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: eg-web
    sectionName: https
  path:
    escapedSlashesAction: KeepUnchanged
    disableMergeSlashes: true
```

The `targetRef.sectionName` field scopes the policy to a specific listener. If omitted, it applies to all listeners on the Gateway.

## Other escapedSlashesAction values

| Value                 | Behavior                                  |
|-----------------------|-------------------------------------------|
| `UnescapeAndRedirect` | Decode `%2F` and 307 redirect (default)   |
| `UnescapeAndForward`  | Decode `%2F` and forward without redirect |
| `KeepUnchanged`       | Preserve `%2F` as-is                      |
| `RejectRequest`       | Return 400 Bad Request                    |
