# BackendTrafficPolicy

BackendTrafficPolicy configures how Envoy Gateway handles traffic to backend services. It allows fine-tuning of connection behavior, load balancing, health checks, circuit breaking, and resilience patterns.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `BackendTrafficPolicy`
- **Attachment**: Gateway or HTTPRoute via `targetRef`

## Key Features

- Load balancing algorithms
- Connection limits and timeouts
- Circuit breaking
- Health checks (active and passive)
- Retry policies
- Timeout configurations
- TCP keep-alive settings
- HTTP/2 configuration

## Basic Example

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: BackendTrafficPolicy
metadata:
  name: backend-policy
  namespace: default
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: my-route
  loadBalancer:
    type: RoundRobin
  timeout:
    tcp:
      connectTimeout: 10s
    http:
      requestTimeout: 30s
```

## Load Balancing

### Available Algorithms

```yaml
spec:
  loadBalancer:
    type: RoundRobin  # RoundRobin, LeastRequest, Random, Maglev, ConsistentHash
```

### Consistent Hash Example

```yaml
spec:
  loadBalancer:
    type: ConsistentHash
    consistentHash:
      type: SourceIP  # SourceIP, Header, Cookie
```

### Least Request Load Balancing

```yaml
spec:
  loadBalancer:
    type: LeastRequest
    slowStart:
      window: 30s
```

## Circuit Breaking

```yaml
spec:
  circuitBreaker:
    maxConnections: 1024
    maxPendingRequests: 1024
    maxRequests: 1024
    maxRetries: 3
    maxConnectionPools: 512
```

## Health Checks

### Active Health Checks

```yaml
spec:
  healthCheck:
    active:
      timeout: 1s
      interval: 5s
      unhealthyThreshold: 3
      healthyThreshold: 2
      http:
        path: /healthz
        expectedStatuses:
          - 200
          - 204
        expectedResponse:
          text: "ok"
```

### Passive Health Check (Outlier Detection)

```yaml
spec:
  healthCheck:
    passive:
      consecutive5xxErrors: 5
      interval: 10s
      baseEjectionTime: 30s
      maxEjectionPercent: 50
      splitExternalLocalOriginErrors: true
```

## Connection Settings

### TCP Settings

```yaml
spec:
  tcpKeepalive:
    probes: 3
    idleTime: 300s
    interval: 60s
  connection:
    bufferLimit: 32768  # 32KB
    connectionLimit:
      value: 100
      closeDelay: 5s
```

### HTTP/2 Settings

```yaml
spec:
  http2:
    initialStreamWindowSize: 65536
    initialConnectionWindowSize: 1048576
    maxConcurrentStreams: 100
```

## Retry Policy

```yaml
spec:
  retry:
    numRetries: 3
    retryOn:
      triggers:
        - 5xx
        - reset
        - connect-failure
        - retriable-4xx
    perRetryTimeout: 5s
    backoff:
      baseInterval: 100ms
      maxInterval: 10s
```

## Timeout Configuration

```yaml
spec:
  timeout:
    tcp:
      connectTimeout: 10s
    http:
      requestTimeout: 30s
      connectionIdleTimeout: 300s
      maxConnectionDuration: 3600s
      streamIdleTimeout: 300s
```

## Proxy Protocol

Enable PROXY protocol for backend connections:

```yaml
spec:
  proxyProtocol:
    version: V1  # V1 or V2
```

## DNS Configuration

```yaml
spec:
  dns:
    dnsRefreshRate: 30s
    respectDnsTtl: true
```

## Use Cases

### High-Availability Backend

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: BackendTrafficPolicy
metadata:
  name: ha-backend
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: api-route
  loadBalancer:
    type: LeastRequest
  circuitBreaker:
    maxConnections: 2048
    maxPendingRequests: 1024
    maxRequests: 2048
  healthCheck:
    active:
      interval: 5s
      timeout: 2s
      unhealthyThreshold: 2
      healthyThreshold: 2
      http:
        path: /health
        expectedStatuses: [200]
    passive:
      consecutive5xxErrors: 5
      baseEjectionTime: 30s
      maxEjectionPercent: 50
  retry:
    numRetries: 3
    retryOn:
      triggers:
        - 5xx
        - reset
        - connect-failure
    perRetryTimeout: 3s
```

### Session Affinity with Consistent Hashing

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: BackendTrafficPolicy
metadata:
  name: session-affinity
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: webapp-route
  loadBalancer:
    type: ConsistentHash
    consistentHash:
      type: Cookie
      cookie:
        name: session-cookie
        ttl: 3600s
        path: /
```

### Long-Lived Connections

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: BackendTrafficPolicy
metadata:
  name: websocket-backend
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: websocket-route
  timeout:
    http:
      requestTimeout: 0s  # Disable timeout
      connectionIdleTimeout: 3600s
      streamIdleTimeout: 3600s
  tcpKeepalive:
    probes: 3
    idleTime: 300s
    interval: 60s
```

## Policy Precedence

1. HTTPRoute-level policies override Gateway-level policies
2. More specific targetRef takes precedence
3. Conflicting policies: most specific wins

## Best Practices

1. **Always enable health checks** for production backends
2. **Set appropriate timeouts** based on application requirements
3. **Use circuit breakers** to prevent cascading failures
4. **Configure retries carefully** to avoid amplification
5. **Monitor backend connection metrics** to tune settings
6. **Use consistent hashing** for stateful applications
7. **Enable passive health checks** for faster failure detection
8. **Set connection limits** to protect backends

## Common Patterns

### API Gateway Backend

```yaml
spec:
  loadBalancer:
    type: LeastRequest
  timeout:
    http:
      requestTimeout: 30s
  retry:
    numRetries: 2
    retryOn:
      triggers: [5xx, reset]
  healthCheck:
    active:
      interval: 10s
      http:
        path: /health
```

### Database Proxy Backend

```yaml
spec:
  loadBalancer:
    type: ConsistentHash
    consistentHash:
      type: SourceIP
  connection:
    connectionLimit:
      value: 50
  timeout:
    tcp:
      connectTimeout: 5s
  tcpKeepalive:
    probes: 3
    idleTime: 600s
    interval: 75s
```

### Microservice Backend

```yaml
spec:
  loadBalancer:
    type: RoundRobin
  circuitBreaker:
    maxConnections: 1024
    maxRequests: 1024
  retry:
    numRetries: 3
    retryOn:
      triggers: [5xx, reset, connect-failure]
    perRetryTimeout: 2s
  healthCheck:
    passive:
      consecutive5xxErrors: 5
      interval: 30s
```

## Related Resources

- [ClientTrafficPolicy](clienttrafficpolicy.md) - Client-facing traffic policies
- [SecurityPolicy](securitypolicy.md) - Security controls
- [EnvoyProxy](envoyproxy.md) - Proxy infrastructure configuration
