# HTTPS_ENABLED environment variable

`HTTPS_ENABLED` is a backend environment variable that controls whether Infisical sets **secure cookies**.

| Value   | Behaviour                                                                                                                                                  |
|---------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `true`  | Cookies are flagged as `Secure`. The browser only sends them over HTTPS. Required for production with TLS.                                                 |
| `false` | Cookies are not flagged as `Secure`, allowing them to work over plain HTTP. Without this, refreshing any page will log you out if you are not using HTTPS. |

> **It does not enable TLS on the Infisical server itself.** TLS must be handled externally, e.g. via ingress or reverse proxy.

## Practical implications

- When doing a `kubectl port-forward` to the service, the pod still serves plain HTTP regardless of this variable.
- `http://127.0.0.1:<port>` will work; `https://127.0.0.1:<port>` will fail with a TLS handshake error.

## Internal service traffic is not encrypted

Any client inside the cluster calling `http://infisical:8080` sends traffic unencrypted over the pod network. This is the standard Kubernetes pattern — TLS terminates at the Ingress, and internal traffic is plain HTTP.

```text
Browser → HTTPS → Ingress (TLS termination) → HTTP → Infisical pod
Internal client → HTTP → Infisical pod  (trusted network, NetworkPolicy restricted)
```

The security boundary for internal traffic is the cluster network itself, enforced by NetworkPolicies — not encryption.

To encrypt intra-cluster traffic you need **mTLS**, provided by a service mesh such as Cilium (WireGuard or Envoy mTLS), Istio, or Linkerd.

- For production, terminate TLS at the Ingress layer (e.g. cert-manager + nginx-ingress) and set `HTTPS_ENABLED=true` so cookies are marked `Secure`.

## Example

```yaml
infisical:
  extraEnv:
    - name: HTTPS_ENABLED
      value: "true"
```
