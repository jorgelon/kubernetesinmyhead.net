# ClientTrafficPolicy

ClientTrafficPolicy configures how Envoy Gateway handles incoming client connections. It controls client-facing behavior such as TCP settings, HTTP protocol versions, TLS, client IP detection, and connection management.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `ClientTrafficPolicy`
- **Attachment**: Gateway via `targetRef`

## Key Features

- TCP keep-alive configuration
- Connection timeouts and limits
- HTTP/1.1, HTTP/2, and HTTP/3 settings
- Client IP detection (X-Forwarded-For, X-Real-IP)
- TLS configuration
- Connection buffer limits
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
    idleTime: 300s
    interval: 60s
    probes: 3
  timeout:
    http:
      requestReceivedTimeout: 30s
```

## TCP Keep-Alive

```yaml
spec:
  tcpKeepalive:
    probes: 3          # Number of keep-alive probes
    idleTime: 300s     # Time before sending keep-alive probes
    interval: 60s      # Interval between keep-alive probes
```

## Connection Settings

### Connection Limits

```yaml
spec:
  connection:
    bufferLimit: 32768  # 32KB buffer per connection
    connectionLimit:
      value: 10000      # Max concurrent connections
      closeDelay: 5s    # Delay before closing excess connections
```

### Timeouts

```yaml
spec:
  timeout:
    http:
      requestReceivedTimeout: 30s     # Max time to receive full request
      requestTimeout: 60s              # Max time for complete request/response
      idleTimeout: 300s                # Connection idle timeout
      connectionIdleTimeout: 300s      # HTTP/1.1 connection reuse timeout
      maxConnectionDuration: 3600s     # Max connection lifetime
```

## HTTP Protocol Configuration

### HTTP/1.1 Settings

```yaml
spec:
  http1:
    enableTrailers: true
    preserveHeaderCase: true
    http10Disabled: false
```

### HTTP/2 Settings

```yaml
spec:
  http2:
    initialStreamWindowSize: 65536        # 64KB
    initialConnectionWindowSize: 1048576  # 1MB
    maxConcurrentStreams: 100
```

### HTTP/3 (QUIC) Settings

```yaml
spec:
  http3:
    enabled: true
```

## Client IP Detection

### X-Forwarded-For Configuration

```yaml
spec:
  clientIPDetection:
    xForwardedFor:
      numTrustedHops: 1  # Number of trusted proxy hops
```

### Custom Header

```yaml
spec:
  clientIPDetection:
    customHeader:
      name: X-Real-IP
      failClosed: true  # Reject if header missing
```

## TLS Configuration

### Minimum TLS Version

```yaml
spec:
  tls:
    minVersion: "1.2"  # 1.0, 1.1, 1.2, 1.3
    maxVersion: "1.3"
```

### Cipher Suites

```yaml
spec:
  tls:
    ciphers:
      - ECDHE-RSA-AES128-GCM-SHA256
      - ECDHE-RSA-AES256-GCM-SHA384
      - ECDHE-ECDSA-AES128-GCM-SHA256
      - ECDHE-ECDSA-AES256-GCM-SHA384
```

### ALPN Protocols

```yaml
spec:
  tls:
    alpnProtocols:
      - h2
      - http/1.1
```

### Client Certificate Validation

```yaml
spec:
  tls:
    clientValidation:
      caCertificateRefs:
        - name: client-ca-secret
          kind: Secret
      optional: false  # Require client certificate
```

## Path Normalization

```yaml
spec:
  path:
    disableMergeSlashes: false       # Merge consecutive slashes
    escapedSlashesAction: KeepUnchanged  # KeepUnchanged, RejectRequest, UnescapeAndRedirect, UnescapeAndForward
```

## Headers

### Custom Headers

```yaml
spec:
  headers:
    enableEnvoyHeaders: true  # Add X-Envoy-* headers
```

## Use Cases

### Production Gateway with Security

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: ClientTrafficPolicy
metadata:
  name: production-gateway
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: prod-gateway
  tcpKeepalive:
    probes: 3
    idleTime: 300s
    interval: 60s
  timeout:
    http:
      requestReceivedTimeout: 30s
      requestTimeout: 60s
      idleTimeout: 300s
  tls:
    minVersion: "1.2"
    ciphers:
      - ECDHE-RSA-AES128-GCM-SHA256
      - ECDHE-RSA-AES256-GCM-SHA384
      - ECDHE-ECDSA-AES128-GCM-SHA256
      - ECDHE-ECDSA-AES256-GCM-SHA384
  clientIPDetection:
    xForwardedFor:
      numTrustedHops: 1
  connection:
    connectionLimit:
      value: 10000
```

### HTTP/2 Optimized Gateway

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: ClientTrafficPolicy
metadata:
  name: http2-gateway
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: api-gateway
  http2:
    initialStreamWindowSize: 262144      # 256KB
    initialConnectionWindowSize: 1048576 # 1MB
    maxConcurrentStreams: 200
  timeout:
    http:
      idleTimeout: 600s
      maxConnectionDuration: 3600s
```

### WebSocket Gateway

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: ClientTrafficPolicy
metadata:
  name: websocket-gateway
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: ws-gateway
  timeout:
    http:
      requestTimeout: 0s  # Disable for WebSocket
      idleTimeout: 3600s
      connectionIdleTimeout: 3600s
  tcpKeepalive:
    probes: 3
    idleTime: 300s
    interval: 60s
```

### CDN Behind Gateway

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: ClientTrafficPolicy
metadata:
  name: cdn-gateway
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: edge-gateway
  clientIPDetection:
    xForwardedFor:
      numTrustedHops: 2  # CDN + Load Balancer
  headers:
    enableEnvoyHeaders: false  # Don't expose internal headers
  http1:
    preserveHeaderCase: true
```

### Mutual TLS Gateway

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: ClientTrafficPolicy
metadata:
  name: mtls-gateway
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: secure-gateway
  tls:
    minVersion: "1.3"
    clientValidation:
      caCertificateRefs:
        - name: client-ca-bundle
          kind: Secret
      optional: false
    alpnProtocols:
      - h2
      - http/1.1
```

## Best Practices

1. **Always enable TCP keep-alive** for long-lived connections
2. **Set appropriate timeouts** based on application requirements
3. **Use TLS 1.2 or higher** for production environments
4. **Configure connection limits** to prevent resource exhaustion
5. **Properly configure X-Forwarded-For** when behind load balancers
6. **Enable HTTP/2** for better performance with modern clients
7. **Monitor connection metrics** to tune buffer and limit settings
8. **Use strong cipher suites** for TLS connections

## Common Patterns

### API Gateway

```yaml
spec:
  timeout:
    http:
      requestReceivedTimeout: 10s
      requestTimeout: 30s
      idleTimeout: 300s
  http2:
    maxConcurrentStreams: 100
  clientIPDetection:
    xForwardedFor:
      numTrustedHops: 1
```

### Public Web Application

```yaml
spec:
  timeout:
    http:
      requestReceivedTimeout: 30s
      idleTimeout: 300s
  tls:
    minVersion: "1.2"
  connection:
    connectionLimit:
      value: 50000
```

### Internal Service Gateway

```yaml
spec:
  timeout:
    http:
      idleTimeout: 600s
      maxConnectionDuration: 3600s
  tcpKeepalive:
    idleTime: 300s
    interval: 60s
  http2:
    maxConcurrentStreams: 200
```

## Troubleshooting

### Connection Timeouts

Check `requestReceivedTimeout` and `idleTimeout` settings if clients experience timeouts.

### WebSocket Issues

Set `requestTimeout: 0s` and increase `idleTimeout` for WebSocket connections.

### Client IP Detection

Verify `numTrustedHops` matches your infrastructure (load balancers, CDN, etc.).

### HTTP/2 Performance

Tune `initialStreamWindowSize` and `maxConcurrentStreams` based on traffic patterns.

## Related Resources

- [BackendTrafficPolicy](backendtrafficpolicy.md) - Backend traffic policies
- [SecurityPolicy](securitypolicy.md) - Security controls
- [EnvoyProxy](envoyproxy.md) - Proxy infrastructure configuration
