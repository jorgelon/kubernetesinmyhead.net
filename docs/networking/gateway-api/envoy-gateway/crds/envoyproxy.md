# EnvoyProxy

EnvoyProxy configures the Envoy Proxy data plane infrastructure: deployment strategy, resource allocation, networking, observability, and bootstrap configuration.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `EnvoyProxy`
- **Purpose**: Configure Envoy proxy deployment and runtime behaviour
- **Attachment**: Referenced from a `Gateway` via `infrastructure.parametersRef`

## Key Features

- Deployment strategy (Deployment or DaemonSet) with replicas and rolling update settings
- Resource requests/limits and node scheduling (affinity, tolerations, topology spread)
- Service type: `LoadBalancer`, `NodePort`, or `ClusterIP`
- Metrics export (Prometheus, OpenTelemetry)
- Structured access logging (File or OpenTelemetry sink)
- Distributed tracing (OpenTelemetry)
- Custom or merged bootstrap configuration
- Graceful shutdown drain timeout

## Basic Example

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyProxy
metadata:
  name: custom-proxy
  namespace: envoy-gateway-system
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyDeployment:
        replicas: 3
        pod:
          resources:
            requests:
              cpu: 500m
              memory: 512Mi
            limits:
              cpu: 1000m
              memory: 1Gi
      envoyService:
        type: LoadBalancer
  telemetry:
    metrics:
      prometheus:
        disable: false
  shutdown:
    drainTimeout: 30s
    minDrainDuration: 5s
```

## Attaching to a Gateway

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: my-gateway
spec:
  gatewayClassName: envoy
  infrastructure:
    parametersRef:
      group: gateway.envoyproxy.io
      kind: EnvoyProxy
      name: custom-proxy
      namespace: envoy-gateway-system
  listeners:
    - name: http
      protocol: HTTP
      port: 80
```

## Key Configuration Sections

| Section                               | Purpose                                                         |
|---------------------------------------|-----------------------------------------------------------------|
| `provider.kubernetes.envoyDeployment` | Replicas, rolling update strategy, pod template                 |
| `provider.kubernetes.envoyDaemonSet`  | DaemonSet mode pod template                                     |
| `provider.kubernetes.envoyService`    | Service type and annotations (e.g. cloud LB annotations)        |
| `telemetry.metrics`                   | Prometheus scrape endpoint and OTel metric sinks                |
| `telemetry.accessLog`                 | Log format (Text/JSON) and sinks (File, OTel)                   |
| `telemetry.tracing`                   | OTel tracing provider and sampling rate                         |
| `bootstrap.type`                      | `Replace` or `Merge` for custom Envoy bootstrap YAML            |
| `shutdown`                            | `drainTimeout` and `minDrainDuration` for hitless restarts      |
| `logging.level`                       | Per-component log level (`default`, `admin`, `connection`, ...) |

## Official Documentation

- [Customize EnvoyProxy](https://gateway.envoyproxy.io/docs/tasks/operations/customize-envoyproxy/)
- [Deployment Mode](https://gateway.envoyproxy.io/docs/tasks/operations/deployment-mode/)
- [Graceful Shutdown and Hitless Upgrades](https://gateway.envoyproxy.io/docs/tasks/operations/graceful-shutdown/)
- [Gateway Namespace Mode](https://gateway.envoyproxy.io/docs/tasks/operations/gateway-namespace-mode/)
- [Standalone Deployment Mode](https://gateway.envoyproxy.io/docs/tasks/operations/standalone-deployment-mode/)
- [Gateway Address](https://gateway.envoyproxy.io/docs/tasks/traffic/gateway-address/)

## Related Resources

- [ClientTrafficPolicy](clienttrafficpolicy.md) - Client-facing policies
- [BackendTrafficPolicy](backendtrafficpolicy.md) - Backend policies
- [EnvoyPatchPolicy](envoypatchpolicy.md) - Low-level configuration
- [Envoy Documentation](https://www.envoyproxy.io/docs/envoy/latest/) - Envoy Proxy docs
