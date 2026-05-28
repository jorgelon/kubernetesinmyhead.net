# TLS and Cipher Configuration

## TLS Protocol Versions

| Version       | Status        | Notes                                                          |
|---------------|---------------|----------------------------------------------------------------|
| SSL 2.0 / 3.0 | **Disabled**  | Broken, CVE-2014-3566 (POODLE)                                 |
| TLS 1.0       | **Disabled**  | Deprecated by RFC 8996 (2021), BEAST attack                    |
| TLS 1.1       | **Disabled**  | Deprecated by RFC 8996 (2021)                                  |
| TLS 1.2       | Supported     | Still widely required for legacy clients                       |
| TLS 1.3       | **Preferred** | Faster handshake, stronger defaults, forward secrecy mandatory |

**Minimum recommendation:** TLS 1.2. Prefer TLS 1.3 only where client compatibility allows.

---

## TLS 1.3

TLS 1.3 removes all negotiation of weak primitives. Key improvements over TLS 1.2:

- Handshake reduced from 2 round-trips to 1 (0-RTT resumption possible)
- All cipher suites provide **forward secrecy** by default
- RSA key exchange removed entirely
- Static DH removed
- MD5 and SHA-1 removed from signatures
- Only 3 cipher suites defined (all AEAD):
  - `TLS_AES_256_GCM_SHA384`
  - `TLS_AES_128_GCM_SHA256`
  - `TLS_CHACHA20_POLY1305_SHA256`

TLS 1.3 cipher suites are not configurable in the same way as TLS 1.2 — the protocol enforces strong choices.

---

## TLS 1.2 Cipher Suites

TLS 1.2 requires careful configuration because it allows many weak options.

### Recommended cipher suites (TLS 1.2)

Order matters — the server should prefer stronger ciphers first:

```text
ECDHE-ECDSA-AES256-GCM-SHA384
ECDHE-RSA-AES256-GCM-SHA384
ECDHE-ECDSA-CHACHA20-POLY1305
ECDHE-RSA-CHACHA20-POLY1305
ECDHE-ECDSA-AES128-GCM-SHA256
ECDHE-RSA-AES128-GCM-SHA256
```

### What to avoid in TLS 1.2

| Pattern                                          | Reason                                            |
|--------------------------------------------------|---------------------------------------------------|
| `NULL` ciphers                                   | No encryption                                     |
| `EXPORT` ciphers                                 | Intentionally weakened, exploited by FREAK/Logjam |
| `RC4`                                            | Biased keystream, broken                          |
| `DES` / `3DES`                                   | SWEET32 birthday attack                           |
| `MD5` MAC                                        | Collision attacks                                 |
| Non-`ECDHE` key exchange (static RSA, static DH) | No forward secrecy                                |
| `aNULL` (no authentication)                      | No server identity verification                   |

### Properties to require

- **ECDHE** key exchange — ephemeral Diffie-Hellman, provides forward secrecy
- **GCM** or **POLY1305** — AEAD modes, authenticated encryption
- **AES-128/256** or **ChaCha20** — symmetric ciphers
- **SHA-256 or higher** — MAC/HMAC/PRF

---

## Certificate Recommendations

### Key type and size

| Algorithm       | Minimum  | Recommended                          |
|-----------------|----------|--------------------------------------|
| RSA             | 2048-bit | 4096-bit or switch to ECDSA          |
| ECDSA           | P-256    | P-256 or P-384                       |
| EdDSA (Ed25519) | —        | Excellent choice for new deployments |

ECDSA P-256 certificates are smaller, faster to handshake, and offer equivalent security to RSA-3072.

### Signature algorithm

Use `SHA-256` or higher for the certificate signature. Reject certificates signed with `MD5` or `SHA-1`.

### HSTS (HTTP Strict Transport Security)

Force browsers to use HTTPS for all future connections to the domain:

```http
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
```

- `max-age`: 2 years (`63072000` seconds) is the standard for preload eligibility
- `includeSubDomains`: applies to all subdomains
- `preload`: submit to [hstspreload.org](https://hstspreload.org) to be baked into browsers

---

## Where TLS is configured

| Layer                     | Tool / Component                                              | What to set                                                                   |
|---------------------------|---------------------------------------------------------------|-------------------------------------------------------------------------------|
| **Ingress controller**    | NGINX Ingress (ConfigMap `nginx-configuration`)               | `ssl-protocols`, `ssl-ciphers`, `ssl-prefer-server-ciphers`, `hsts`           |
| **Ingress controller**    | Contour (`HTTPProxy` + `EnvoyTLSContext` or global ConfigMap) | `minimumProtocolVersion`, cipher list delegated to Envoy                      |
| **Cloud load balancer**   | AWS ALB (`alb.ingress.kubernetes.io/ssl-policy` annotation)   | Named Security Policy (e.g. `ELBSecurityPolicy-TLS13-1-2-2021-06`)            |
| **Cloud CDN**             | AWS CloudFront (distribution settings)                        | Security policy — minimum `TLSv1.2_2021`                                      |
| **Certificate lifecycle** | cert-manager                                                  | Issues/renews certificates; cipher config stays at the ingress layer          |
| **Application server**    | NGINX, HAProxy, Caddy (when directly exposed)                 | `ssl_protocols`, `ssl_ciphers`, `ssl_prefer_server_ciphers`, session settings |
| **Service mesh**          | Istio / Linkerd (mTLS between pods)                           | `PeerAuthentication`, `DestinationRule` TLS settings                          |

---

## Testing and Validation

### Online tools

- **SSL Labs** (`ssllabs.com/ssltest`) — comprehensive grading, checks protocol versions, ciphers, cert chain, HSTS
- **testssl.sh** — CLI tool for internal/non-public endpoints

### testssl.sh quick scan

```bash
docker run --rm drwetter/testssl.sh --fast --parallel https://example.com
```

Key things to check:

- Grade A or A+
- TLS 1.0 and 1.1 not offered
- No weak ciphers (RC4, DES, EXPORT, NULL)
- Forward secrecy on all supported cipher suites
- HSTS header present with long `max-age`
- Certificate: valid chain, not expiring soon, strong key

---

## Summary: minimum recommended configuration

| Setting           | Value                                              |
|-------------------|----------------------------------------------------|
| TLS versions      | TLS 1.2 + TLS 1.3                                  |
| TLS 1.2 ciphers   | ECDHE + ECDSA/RSA + AES-GCM or CHACHA20            |
| Key exchange      | ECDHE only (forward secrecy)                       |
| Certificate       | ECDSA P-256 or RSA 2048+ with SHA-256              |
| HSTS              | `max-age=63072000; includeSubDomains`              |
| Session tickets   | Off (prevents forward secrecy from being weakened) |
| TLS session cache | Shared, server-side only                           |
