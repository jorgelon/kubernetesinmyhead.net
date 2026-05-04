# HTTP Timeouts in Envoy Gateway

Envoy Gateway exposes three timeout settings across two resources: `HTTPRoute` and
`BackendTrafficPolicy`. Each controls a different slice of the request lifecycle. Understanding
the boundary between them prevents under- or over-constraining traffic at the wrong layer.

## The three settings

### HTTPRoute — `timeouts.request`

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
spec:
  rules:
    - timeouts:
        request: 60s
```

The end-to-end budget for a single client transaction: from the moment the gateway receives the
request until the last byte of the response is sent back to the client. This includes all retry
attempts combined.

If this timeout expires, the gateway returns `504 Gateway Timeout` to the client.

### HTTPRoute — `timeouts.backendRequest`

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
spec:
  rules:
    - timeouts:
        request: 60s
        backendRequest: 20s
```

The per-attempt budget for a single upstream call from the gateway to the backend. If the route
has retries configured, each individual attempt gets this full budget independently.

Constraint: `backendRequest` must not exceed `request`. Envoy Gateway rejects configurations
that violate this.

### BackendTrafficPolicy — `timeout.http.requestTimeout`

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: BackendTrafficPolicy
spec:
  targetRefs:
    - group: gateway.networking.k8s.io
      kind: HTTPRoute
      name: my-route
  timeout:
    http:
      requestTimeout: 60s
```

The time Envoy waits for the upstream to deliver the complete response on a single request
attempt. Semantically equivalent to `backendRequest` on the HTTPRoute: it controls the
gateway-to-backend leg only, not the total client-facing duration.

## Comparison

| Setting                       | Resource             | Controls                                        | Scope             |
|-------------------------------|----------------------|-------------------------------------------------|-------------------|
| `timeouts.request`            | HTTPRoute rule       | Total client-facing duration (includes retries) | Per route rule    |
| `timeouts.backendRequest`     | HTTPRoute rule       | Single backend attempt                          | Per route rule    |
| `timeout.http.requestTimeout` | BackendTrafficPolicy | Single backend attempt                          | Per policy target |

The key distinction between `timeouts.request` and the other two: only `request` caps the total
time visible to the client. If a backend is slow and retries are enabled, multiple `backendRequest`
cycles can accumulate — `request` is the hard ceiling that stops that accumulation.

`BackendTrafficPolicy` applies at the target level (an HTTPRoute or Gateway), so one policy can
cover all rules in a route. `HTTPRoute.timeouts` is per rule, allowing different timeouts for
different paths or methods within the same route.

## When to use each

Use `timeouts.request` on `HTTPRoute` when you need to guarantee a maximum response latency
to clients regardless of retries or backend slowness.

Use `timeouts.backendRequest` on `HTTPRoute` when you want per-attempt control at the rule
level, especially when different rules in the same route need different backend budgets.

Use `BackendTrafficPolicy` `requestTimeout` when the timeout policy should be managed
independently from the routing rules — for example, when routing is owned by one team and
traffic policies by another, or when a single policy should consistently apply across multiple
routes targeting the same backend.

## Known gap

The interaction when both `HTTPRoute.timeouts.backendRequest` and
`BackendTrafficPolicy.timeout.http.requestTimeout` are configured on the same route simultaneously
is not documented. Avoid configuring both on the same target until precedence behavior is
clarified upstream.

## References

- [Envoy Gateway — HTTP Timeouts task](https://gateway.envoyproxy.io/docs/tasks/traffic/http-timeouts/)
- [Envoy Gateway API — BackendTrafficPolicy](https://gateway.envoyproxy.io/docs/api/extension_types/#backendtrafficpolicy)
- [Gateway API — HTTPRouteTimeouts](https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io/v1.HTTPRouteTimeouts)
