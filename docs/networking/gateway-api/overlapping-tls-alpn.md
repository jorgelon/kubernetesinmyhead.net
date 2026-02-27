# Overlapping TLS and ALPN

When two listeners on the same Gateway share a TLS certificate with overlapping
SANs, Gateway API requires implementations to raise an `OverlappingTLSConfig`
condition with reason `OverlappingCertificates`. This behavior is standardized
in [GEP-3567](https://gateway-api.sigs.k8s.io/geps/gep-3567/), which graduated
to **Standard conformance** in Gateway API v1.5.0.

A common scenario: a wildcard listener (`*.example.com`) and a bare domain
listener (`example.com`) both reference the same certificate. Since cert-manager
includes both `*.example.com` and `example.com` as SANs in a single cert
(because the wildcard does not cover the bare domain per RFC 6125), the overlap
is triggered.

## Why it matters: HTTP/2 connection coalescing

HTTP/2 allows clients to **reuse a single TCP connection** for multiple
hostnames if the TLS certificate covers both (connection coalescing). This
becomes a problem with multiple listeners:

1. A client connects to `app.example.com` (matched by the wildcard listener)
2. The cert also covers `example.com` (matched by the bare domain listener)
3. The client reuses that connection for `example.com` requests
4. The proxy cannot distinguish which listener should handle the request
   since both arrive on the same connection

## How Gateway API addresses this

### OverlappingTLSConfig condition (Part A)

All conformant implementations **MUST** report the `OverlappingTLSConfig`
condition on affected listeners. This is a Standard conformance requirement
since Gateway API v1.5.0 — not an implementation-specific extension.

### HTTP 421 Misdirected Request (Part B)

The spec **RECOMMENDS** that implementations return HTTP 421 (Misdirected
Request, RFC 9110 §15.5.20) instead of disabling HTTP/2 entirely. This is
tracked as the `GatewayReturn421` conformance feature.

With 421 support, when a client sends a coalesced request to the wrong
listener, the server responds with 421 and the client self-corrects by opening
a new connection to the correct endpoint. HTTP/2 stays active for correctly
routed traffic.

### Gateway-level TLS config (Part C)

GEP-91 moves mutual TLS (mTLS) client certificate validation to the Gateway
level. This mitigates coalescing security risks by ensuring cert validation
happens before listener routing rather than after.

## Impact

| Scenario                            | HTTP/2                 | Behaviour                                                |
|-------------------------------------|------------------------|----------------------------------------------------------|
| Implementation supports 421         | Stays active           | Misdirected requests bounce with 421; clients reconnect  |
| Implementation disables h2 (legacy) | Downgraded to HTTP/1.1 | All traffic works, no multiplexing or header compression |

## Solutions

### Spec-level (portable across implementations)

- **Separate certificates**: Use a non-wildcard cert for the bare domain
  listener so SANs do not overlap. This eliminates the condition entirely.
- **Rely on 421 responses**: If the implementation supports `GatewayReturn421`,
  no action is needed — misdirected requests self-correct automatically.

### Implementation-specific

- **Envoy Gateway**: Configure a
  [`ClientTrafficPolicy`](envoy-gateway/crds/clienttrafficpolicy.md) to force
  `h2` ALPN advertisement, accepting the coalescing risk explicitly.

## Detecting the condition

```bash
kubectl get gateway <name> -n <namespace> -o json | \
  jq '.status.listeners[].conditions[] | select(.type == "OverlappingTLSConfig")'
```

## Links

- [GEP-3567: Overlapping TLS Config](https://gateway-api.sigs.k8s.io/geps/gep-3567/)
- [GEP-91: Client Certificate Validation](https://gateway-api.sigs.k8s.io/geps/gep-91/)
- [RFC 9110 §15.5.20 — 421 Misdirected Request](https://httpwg.org/specs/rfc9110.html#status.421)
- [Gateway API v1.5.0 release notes](https://gateway-api.sigs.k8s.io/blog/2025/gateway-api-v1-5/)
