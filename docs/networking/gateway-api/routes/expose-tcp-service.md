# Expose a TCP service

How you expose a raw TCP service depends on the **listener protocol** you pick
(`TCP` or `TLS`) and, when using `TLS`, on whether you terminate the session at
the Gateway or pass it through. That choice decides:

- Which **route** type you attach ([`TCPRoute`](tcproute.md) or
  [`TLSRoute`](tlsroute.md)).
- Whether **TLS** can be terminated, and where.
- Whether the **hostname** field (SNI) is used at all.

> Verified against Gateway API **v1.6.1**. See the
> [routes overview](00-routes.md) for the per-type status and channels.

## Decision table

| Listener protocol | TLS mode      | Route      | TLS terminated at | Hostname (SNI) | Support  |
|-------------------|---------------|------------|-------------------|----------------|----------|
| `TCP`             | *(none)*      | `TCPRoute` | not terminated    | ignored        | Core     |
| `TLS`             | `Passthrough` | `TLSRoute` | backend (pod)     | must match SNI | Core     |
| `TLS`             | `Terminate`   | `TLSRoute` | Gateway           | must match SNI | Extended |

- A `TCPRoute` can only attach to `TCP` listeners; TCP listeners have **no** TLS
  section, so TLS is never handled by the Gateway.
- A `TLS` listener always needs a `tls` section and attaches `TLSRoute`.

### When can TLS be terminated?

- **Only** on a `TLS` listener with `mode: Terminate` (or on `HTTPS`/`GRPC`
  listeners for L7 traffic). On a `TCP` listener TLS is never handled.
- `Terminate` requires `certificateRefs`; `Passthrough` must leave it empty.
- With `Passthrough`, TLS is **not** terminated at the Gateway — the backend does.
- The `TLS` + `Terminate` case needs an implementation reporting the
  `TLSRouteModeTerminate` feature.

## Plain TCP (no TLS)

The service speaks raw TCP. Routing is by **port only**; `hostname` is ignored
because there is no SNI to inspect.

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: tcp-gateway
spec:
  gatewayClassName: my-class
  listeners:
  - name: postgres
    protocol: TCP
    port: 5432
    allowedRoutes:
      kinds:
      - kind: TCPRoute
---
apiVersion: gateway.networking.k8s.io/v1
kind: TCPRoute
metadata:
  name: postgres
spec:
  parentRefs:
  - name: tcp-gateway
    sectionName: postgres
  rules:
  - backendRefs:
    - name: postgres
      port: 5432
```

## TLS Passthrough (backend terminates)

The encrypted stream flows through the Gateway untouched; the **backend** owns
the certificate and terminates TLS. No `certificateRefs` needed. The Gateway
inspects only the SNI, so `hostname` **must** match it. Uses `TLSRoute`.

```yaml
  listeners:
  - name: passthrough
    protocol: TLS
    port: 443
    hostname: db.example.com
    tls:
      mode: Passthrough
    allowedRoutes:
      kinds:
      - kind: TLSRoute
```

## TLS Terminate (Gateway terminates)

The Gateway decrypts the client TLS session and forwards **plaintext TCP** to the
backend. `certificateRefs` is **required** and `hostname` must match the SNI.
Uses `TLSRoute` (Extended support).

```yaml
  listeners:
  - name: terminate
    protocol: TLS
    port: 443
    hostname: db.example.com
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        group: ""
        name: db-example-com-cert
    allowedRoutes:
      kinds:
      - kind: TLSRoute
```

> Per the spec a `TLS` listener attaches `TLSRoute`. Some implementations also
> accept a `TCPRoute` on a terminating TLS listener (raw TCP after decryption),
> but that is implementation-specific, not guaranteed by the API.

## References

- <https://gateway-api.sigs.k8s.io/guides/user-guides/tcp/>
- <https://gateway-api.sigs.k8s.io/guides/user-guides/tls/>
