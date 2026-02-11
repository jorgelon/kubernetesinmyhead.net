# OverlappingTLSConfig and ALPN fallback to HTTP/1.1

When two listeners on the same Gateway share a TLS certificate with
overlapping SANs, Envoy Gateway raises an
`OverlappingTLSConfig` condition with reason `OverlappingCertificates`.

A common scenario: a wildcard listener (`*.example.com`) and a bare domain
listener (`example.com`) both reference the same certificate. Since
cert-manager includes both `*.example.com` and `example.com` as SANs in a
single cert (because the wildcard does not cover the bare domain per RFC
6125), the overlap is triggered.

## Why it matters: HTTP/2 connection coalescing

HTTP/2 allows clients to **reuse a single TCP connection** for multiple
hostnames if the TLS certificate covers both (connection coalescing). This
becomes a problem with multiple listeners:

1. A client connects to `app.example.com` (matched by the wildcard listener)
2. The cert also covers `example.com` (matched by the bare domain listener)
3. The client reuses that connection for `example.com` requests
4. The proxy cannot distinguish which listener should handle the request
   since both arrive on the same connection

To prevent this, Envoy Gateway **disables HTTP/2 advertisement via
ALPN**. Without `h2` in the ALPN negotiation, clients fall back to HTTP/1.1
which does not support connection coalescing. Each hostname gets its own
connection and listener matching works correctly.

## Impact

- All traffic works, but over HTTP/1.1 (no multiplexing, no header compression)
- For internal tooling and admin UIs this is usually negligible

## Solutions if HTTP/2 is needed

- **Separate certificates**: Use a non-wildcard cert for the bare domain
  listener so SANs do not overlap
- **Explicit ALPN via policy**: Configure a
  `ClientTrafficPolicy` to force `h2` advertisement, accepting the
  coalescing risk

## Detecting the condition

```bash
kubectl get gateway <name> -n <namespace> -o json | \
  jq '.status.listeners[].conditions[] | select(.type == "OverlappingTLSConfig")'
```
