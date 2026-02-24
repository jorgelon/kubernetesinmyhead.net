# BackendTrafficPolicy

BackendTrafficPolicy configures how Envoy Gateway handles traffic to backend services, including load balancing, timeouts, circuit breaking, health checks, and retry policies.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `BackendTrafficPolicy`
- **Attachment**: Gateway or HTTPRoute via `targetRef`

## Key Features

- Load balancing algorithms (RoundRobin, LeastRequest, Random, Maglev, ConsistentHash)
- Circuit breaking (connection/request/retry limits)
- Active and passive health checks
- Retry policies with backoff
- Connection and request timeouts
- TCP keep-alive settings
- HTTP/2 configuration
- Proxy protocol
- DNS refresh settings

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
    type: LeastRequest
  timeout:
    http:
      requestTimeout: 30s
  circuitBreaker:
    maxConnections: 1024
    maxRequests: 1024
  retry:
    numRetries: 3
    retryOn:
      triggers: [5xx, reset, connect-failure]
    perRetryTimeout: 5s
  healthCheck:
    active:
      interval: 5s
      timeout: 2s
      unhealthyThreshold: 2
      http:
        path: /health
        expectedStatuses: [200]
    passive:
      consecutive5xxErrors: 5
      baseEjectionTime: 30s
      maxEjectionPercent: 50
```

## Key Configuration Sections

| Section                       | Purpose                                                               |
|-------------------------------|-----------------------------------------------------------------------|
| `loadBalancer`                | Algorithm selection; ConsistentHash supports SourceIP, Header, Cookie |
| `circuitBreaker`              | Max connections, pending requests, retries, and connection pools      |
| `healthCheck.active`          | Periodic HTTP/TCP probe with thresholds                               |
| `healthCheck.passive`         | Outlier detection based on consecutive errors                         |
| `retry`                       | Retry triggers, count, per-retry timeout, and backoff interval        |
| `timeout.tcp.connectTimeout`  | Max time to establish upstream connection                             |
| `timeout.http.requestTimeout` | Max time for a complete request/response cycle                        |
| `tcpKeepalive`                | Keep-alive probes, idle time, and interval                            |
| `proxyProtocol`               | PROXY protocol version V1 or V2 for upstream connections              |
| `dns`                         | DNS refresh rate and TTL respect                                      |

## Policy Precedence

HTTPRoute-level policies override Gateway-level policies. The most specific `targetRef` wins.

## Official Documentation

- [Circuit Breakers](https://gateway.envoyproxy.io/docs/tasks/traffic/circuit-breaker/)
- [Load Balancing](https://gateway.envoyproxy.io/docs/tasks/traffic/load-balancing/)
- [HTTP Timeouts](https://gateway.envoyproxy.io/docs/tasks/traffic/http-timeouts/)
- [Retry](https://gateway.envoyproxy.io/docs/tasks/traffic/retry/)
- [Connection Limit](https://gateway.envoyproxy.io/docs/tasks/traffic/connection-limit/)
- [Local Rate Limit](https://gateway.envoyproxy.io/docs/tasks/traffic/local-rate-limit/)
- [Global Rate Limit](https://gateway.envoyproxy.io/docs/tasks/traffic/global-rate-limit/)
- [Session Persistence](https://gateway.envoyproxy.io/docs/tasks/traffic/session-persistence/)
- [Response Compression](https://gateway.envoyproxy.io/docs/tasks/traffic/response-compression/)
- [Request Buffering](https://gateway.envoyproxy.io/docs/tasks/traffic/request-buffering/)
- [Zone Aware Routing](https://gateway.envoyproxy.io/docs/tasks/traffic/zone-aware-routing/)
- [Response Override](https://gateway.envoyproxy.io/docs/tasks/traffic/response-override/)
- [Direct Response](https://gateway.envoyproxy.io/docs/tasks/traffic/direct-response/)
- [Backend TLS: Gateway to Backend](https://gateway.envoyproxy.io/docs/tasks/security/backend-tls/)
- [Backend Mutual TLS: Gateway to Backend](https://gateway.envoyproxy.io/docs/tasks/security/backend-mtls/)
- [Backend TLS: Skip TLS Verification](https://gateway.envoyproxy.io/docs/tasks/security/backend-skip-tls-verification/)

## Related Resources

- [ClientTrafficPolicy](clienttrafficpolicy.md) - Client-facing traffic policies
- [SecurityPolicy](securitypolicy.md) - Security controls
- [EnvoyProxy](envoyproxy.md) - Proxy infrastructure configuration
