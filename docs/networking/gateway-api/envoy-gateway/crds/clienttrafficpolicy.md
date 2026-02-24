# ClientTrafficPolicy

ClientTrafficPolicy configures how Envoy Gateway handles incoming client connections, including TLS, protocol settings, client IP detection, and connection management.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `ClientTrafficPolicy`
- **Attachment**: Gateway via `targetRef`

## Key Features

- TCP keep-alive configuration
- Connection limits and buffer sizes
- Request and idle timeouts
- HTTP/1.1, HTTP/2, and HTTP/3 (QUIC) settings
- Client IP detection via X-Forwarded-For or custom header
- TLS minimum/maximum version and cipher suites
- Client certificate validation (mTLS)
- Path normalization

## Basic Example

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: ClientTrafficPolicy
metadata:
  name: client-policy
  namespace: default
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  tcpKeepalive:
    probes: 3
    idleTime: 300s
    interval: 60s
  timeout:
    http:
      requestReceivedTimeout: 30s
      idleTimeout: 300s
  tls:
    minVersion: "1.2"
  clientIPDetection:
    xForwardedFor:
      numTrustedHops: 1
  connection:
    connectionLimit:
      value: 10000
```

## Key Configuration Sections

| Section                             | Purpose                                                                            |
|-------------------------------------|------------------------------------------------------------------------------------|
| `tcpKeepalive`                      | Keep-alive probes, idle time, and probe interval                                   |
| `timeout.http`                      | `requestReceivedTimeout`, `requestTimeout`, `idleTimeout`, `maxConnectionDuration` |
| `connection.connectionLimit`        | Max concurrent connections with optional close delay                               |
| `connection.bufferLimit`            | Per-connection buffer size                                                         |
| `http1`                             | Trailers, header case preservation, HTTP/1.0 handling                              |
| `http2`                             | Stream/connection window sizes, max concurrent streams                             |
| `http3`                             | Enable QUIC/HTTP3 on the listener                                                  |
| `tls.minVersion` / `tls.maxVersion` | Accepted TLS versions (`1.2`, `1.3`)                                               |
| `tls.ciphers`                       | Allowed cipher suites list                                                         |
| `tls.clientValidation`              | CA refs and optional flag for mTLS                                                 |
| `clientIPDetection.xForwardedFor`   | Number of trusted proxy hops                                                       |
| `clientIPDetection.customHeader`    | Use a custom header for client IP                                                  |
| `path`                              | Slash merging and escaped slash handling                                           |
| `headers.enableEnvoyHeaders`        | Add `X-Envoy-*` headers to requests                                                |

## Official Documentation

- [Client Traffic Policy](https://gateway.envoyproxy.io/docs/tasks/traffic/client-traffic-policy/)
- [HTTP3](https://gateway.envoyproxy.io/docs/tasks/traffic/http3/)
- [Connection Limit](https://gateway.envoyproxy.io/docs/tasks/traffic/connection-limit/)
- [Secure Gateways](https://gateway.envoyproxy.io/docs/tasks/security/secure-gateways/)
- [Mutual TLS: External Clients to the Gateway](https://gateway.envoyproxy.io/docs/tasks/security/mutual-tls/)
- [TLS Passthrough](https://gateway.envoyproxy.io/docs/tasks/security/tls-passthrough/)
- [TLS Termination for TCP](https://gateway.envoyproxy.io/docs/tasks/security/tls-termination/)
- [Using cert-manager For TLS Termination](https://gateway.envoyproxy.io/docs/tasks/security/tls-cert-manager/)
- [Accelerating TLS Handshakes using Private Key Provider](https://gateway.envoyproxy.io/docs/tasks/security/private-key-provider/)

## Related Resources

- [BackendTrafficPolicy](backendtrafficpolicy.md) - Backend traffic policies
- [SecurityPolicy](securitypolicy.md) - Security controls
- [EnvoyProxy](envoyproxy.md) - Proxy infrastructure configuration
