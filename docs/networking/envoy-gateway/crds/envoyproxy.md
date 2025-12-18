# EnvoyProxy

EnvoyProxy configures the Envoy Proxy data plane infrastructure, including deployment strategy, resource allocation, networking, observability, and bootstrap configuration. It controls how Envoy proxies are deployed and managed.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `EnvoyProxy`
- **Purpose**: Configure Envoy proxy infrastructure
- **Scope**: Cluster-wide or per-Gateway configuration

## Key Features

- Deployment strategy (Deployment, DaemonSet)
- Resource requests and limits
- Pod template customization
- Service configuration (LoadBalancer, NodePort, ClusterIP)
- Bootstrap configuration
- Telemetry and logging
- Shutdown behavior
- Envoy admin interface

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
```

## Deployment Configuration

### Replicas

```yaml
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyDeployment:
        replicas: 3
        strategy:
          type: RollingUpdate
          rollingUpdate:
            maxSurge: 1
            maxUnavailable: 0
```

### DaemonSet Mode

```yaml
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyDaemonSet:
        pod:
          annotations:
            prometheus.io/scrape: "true"
```

## Resource Configuration

### CPU and Memory

```yaml
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyDeployment:
        pod:
          resources:
            requests:
              cpu: 500m
              memory: 512Mi
            limits:
              cpu: 2000m
              memory: 2Gi
```

### Node Selection

```yaml
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyDeployment:
        pod:
          nodeSelector:
            node-role.kubernetes.io/worker: "true"
          tolerations:
            - key: dedicated
              operator: Equal
              value: envoy
              effect: NoSchedule
          affinity:
            podAntiAffinity:
              preferredDuringSchedulingIgnoredDuringExecution:
                - weight: 100
                  podAffinityTerm:
                    labelSelector:
                      matchLabels:
                        app: envoy-proxy
                    topologyKey: kubernetes.io/hostname
```

## Service Configuration

### LoadBalancer Service

```yaml
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyService:
        type: LoadBalancer
        annotations:
          service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
          service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
```

### NodePort Service

```yaml
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyService:
        type: NodePort
        nodePort: 30080
```

### ClusterIP with External IPs

```yaml
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyService:
        type: ClusterIP
        externalIPs:
          - 192.168.1.100
```

## Telemetry Configuration

### Metrics

```yaml
spec:
  telemetry:
    metrics:
      prometheus:
        disable: false
      sinks:
        - type: OpenTelemetry
          openTelemetry:
            host: otel-collector.observability.svc.cluster.local
            port: 4317
            protocol: grpc
```

### Access Logging

```yaml
spec:
  telemetry:
    accessLog:
      settings:
        - format:
            type: JSON
            json:
              timestamp: "%START_TIME%"
              method: "%REQ(:METHOD)%"
              path: "%REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%"
              protocol: "%PROTOCOL%"
              response_code: "%RESPONSE_CODE%"
              duration: "%DURATION%"
              bytes_sent: "%BYTES_SENT%"
              bytes_received: "%BYTES_RECEIVED%"
              user_agent: "%REQ(USER-AGENT)%"
              x_forwarded_for: "%REQ(X-FORWARDED-FOR)%"
              upstream_host: "%UPSTREAM_HOST%"
          sinks:
            - type: File
              file:
                path: /dev/stdout
```

### Tracing

```yaml
spec:
  telemetry:
    tracing:
      provider:
        type: OpenTelemetry
        host: jaeger-collector.observability.svc.cluster.local
        port: 4317
      samplingRate: 100  # 100% sampling
```

## Bootstrap Configuration

### Custom Bootstrap

```yaml
spec:
  bootstrap:
    type: Replace
    value: |
      admin:
        address:
          socket_address:
            address: 0.0.0.0
            port_value: 19000
      static_resources:
        listeners: []
        clusters: []
```

### Merge Bootstrap

```yaml
spec:
  bootstrap:
    type: Merge
    value: |
      stats_config:
        stats_tags:
          - tag_name: "cluster_name"
            regex: "^cluster\\.(.+?)\\."
```

## Shutdown Configuration

```yaml
spec:
  shutdown:
    drainTimeout: 30s
    minDrainDuration: 5s
```

## Logging Configuration

```yaml
spec:
  logging:
    level:
      default: info
      admin: warn
      connection: debug
```

## Use Cases

### Production High-Availability Setup

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyProxy
metadata:
  name: production-proxy
  namespace: envoy-gateway-system
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyDeployment:
        replicas: 5
        strategy:
          type: RollingUpdate
          rollingUpdate:
            maxSurge: 1
            maxUnavailable: 0
        pod:
          resources:
            requests:
              cpu: 1000m
              memory: 1Gi
            limits:
              cpu: 2000m
              memory: 2Gi
          affinity:
            podAntiAffinity:
              requiredDuringSchedulingIgnoredDuringExecution:
                - labelSelector:
                    matchLabels:
                      app: envoy-proxy
                  topologyKey: kubernetes.io/hostname
      envoyService:
        type: LoadBalancer
        annotations:
          service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
  telemetry:
    accessLog:
      settings:
        - format:
            type: JSON
          sinks:
            - type: File
              file:
                path: /dev/stdout
    metrics:
      prometheus:
        disable: false
  shutdown:
    drainTimeout: 60s
    minDrainDuration: 10s
```

### Edge Proxy with DaemonSet

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyProxy
metadata:
  name: edge-proxy
  namespace: envoy-gateway-system
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyDaemonSet:
        pod:
          nodeSelector:
            node-role.kubernetes.io/edge: "true"
          hostNetwork: true
          resources:
            requests:
              cpu: 2000m
              memory: 2Gi
            limits:
              cpu: 4000m
              memory: 4Gi
      envoyService:
        type: ClusterIP
```

### Development Setup

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyProxy
metadata:
  name: dev-proxy
  namespace: envoy-gateway-system
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyDeployment:
        replicas: 1
        pod:
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 500m
              memory: 512Mi
  logging:
    level:
      default: debug
  telemetry:
    accessLog:
      settings:
        - format:
            type: Text
          sinks:
            - type: File
              file:
                path: /dev/stdout
```

### Observability-Focused Setup

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyProxy
metadata:
  name: observability-proxy
  namespace: envoy-gateway-system
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyDeployment:
        replicas: 3
  telemetry:
    metrics:
      prometheus:
        disable: false
      sinks:
        - type: OpenTelemetry
          openTelemetry:
            host: otel-collector.observability.svc.cluster.local
            port: 4317
            protocol: grpc
    accessLog:
      settings:
        - format:
            type: JSON
            json:
              timestamp: "%START_TIME%"
              method: "%REQ(:METHOD)%"
              path: "%REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%"
              protocol: "%PROTOCOL%"
              response_code: "%RESPONSE_CODE%"
              duration: "%DURATION%"
              upstream_service_time: "%RESP(X-ENVOY-UPSTREAM-SERVICE-TIME)%"
              request_id: "%REQ(X-REQUEST-ID)%"
              trace_id: "%REQ(X-B3-TRACEID)%"
          sinks:
            - type: OpenTelemetry
              openTelemetry:
                host: otel-collector.observability.svc.cluster.local
                port: 4317
                protocol: grpc
    tracing:
      provider:
        type: OpenTelemetry
        host: jaeger-collector.observability.svc.cluster.local
        port: 4317
      samplingRate: 10  # 10% sampling
```

### Multi-Zone Deployment

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyProxy
metadata:
  name: multi-zone-proxy
  namespace: envoy-gateway-system
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyDeployment:
        replicas: 6
        pod:
          affinity:
            podAntiAffinity:
              preferredDuringSchedulingIgnoredDuringExecution:
                - weight: 100
                  podAffinityTerm:
                    labelSelector:
                      matchLabels:
                        app: envoy-proxy
                    topologyKey: topology.kubernetes.io/zone
          topologySpreadConstraints:
            - maxSkew: 1
              topologyKey: topology.kubernetes.io/zone
              whenUnsatisfiable: DoNotSchedule
              labelSelector:
                matchLabels:
                  app: envoy-proxy
```

### Custom Bootstrap for Advanced Features

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyProxy
metadata:
  name: custom-bootstrap-proxy
  namespace: envoy-gateway-system
spec:
  bootstrap:
    type: Merge
    value: |
      stats_config:
        stats_tags:
          - tag_name: "cluster_name"
            regex: "^cluster\\.(.+?)\\."
          - tag_name: "route_name"
            regex: "^route\\.(.+?)\\."
        use_all_default_tags: true
      overload_manager:
        refresh_interval: 0.25s
        resource_monitors:
          - name: "envoy.resource_monitors.fixed_heap"
            typed_config:
              "@type": type.googleapis.com/envoy.extensions.resource_monitors.fixed_heap.v3.FixedHeapConfig
              max_heap_size_bytes: 2147483648  # 2GB
        actions:
          - name: "envoy.overload_actions.shrink_heap"
            triggers:
              - name: "envoy.resource_monitors.fixed_heap"
                threshold:
                  value: 0.95
          - name: "envoy.overload_actions.stop_accepting_requests"
            triggers:
              - name: "envoy.resource_monitors.fixed_heap"
                threshold:
                  value: 0.98
```

## Attaching to Gateway

Reference EnvoyProxy from Gateway:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: my-gateway
  namespace: default
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

## Admin Interface

Access Envoy admin interface:

```bash
# Port-forward to admin port
kubectl port-forward -n envoy-gateway-system \
  deploy/envoy-gateway 19000:19000

# View configuration
curl localhost:19000/config_dump

# View stats
curl localhost:19000/stats

# View clusters
curl localhost:19000/clusters

# View listeners
curl localhost:19000/listeners
```

## Best Practices

1. **Set resource limits** - Prevent resource exhaustion
2. **Use anti-affinity** - Distribute pods across nodes
3. **Enable metrics** - Monitor proxy performance
4. **Configure graceful shutdown** - Prevent connection drops
5. **Use structured logging** - JSON format for better parsing
6. **Set appropriate replicas** - Based on traffic patterns
7. **Enable tracing** - For debugging and observability
8. **Test bootstrap changes** - Validate in non-production first
9. **Monitor memory usage** - Tune based on actual usage
10. **Use topology spread** - For multi-zone deployments

## Monitoring

### Key Metrics

- `envoy_http_downstream_rq_total` - Total requests
- `envoy_http_downstream_rq_xx` - Response codes
- `envoy_cluster_upstream_rq_time` - Upstream response time
- `envoy_server_memory_allocated` - Memory usage
- `envoy_cluster_health_check_failure` - Health check failures

### Prometheus ServiceMonitor

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: envoy-proxy
  namespace: envoy-gateway-system
spec:
  selector:
    matchLabels:
      app: envoy-proxy
  endpoints:
    - port: metrics
      path: /stats/prometheus
      interval: 30s
```

## Troubleshooting

### High Memory Usage

Check Envoy memory stats:

```bash
kubectl exec -n envoy-gateway-system deploy/envoy-gateway -- \
  curl -s localhost:19000/memory
```

### Connection Issues

Check listeners:

```bash
kubectl exec -n envoy-gateway-system deploy/envoy-gateway -- \
  curl -s localhost:19000/listeners
```

### Performance Issues

Review resource usage:

```bash
kubectl top pods -n envoy-gateway-system
```

Check connection pools:

```bash
kubectl exec -n envoy-gateway-system deploy/envoy-gateway -- \
  curl -s localhost:19000/clusters | grep -A 5 "circuit_breakers"
```

## Upgrade Considerations

1. **Test in staging** - Validate EnvoyProxy changes
2. **Rolling updates** - Use appropriate maxSurge/maxUnavailable
3. **Drain connections** - Configure adequate drainTimeout
4. **Monitor during rollout** - Watch for errors and latency
5. **Rollback plan** - Keep previous configuration

## Related Resources

- [ClientTrafficPolicy](clienttrafficpolicy.md) - Client-facing policies
- [BackendTrafficPolicy](backendtrafficpolicy.md) - Backend policies
- [EnvoyPatchPolicy](envoypatchpolicy.md) - Low-level configuration
- [Envoy Documentation](https://www.envoyproxy.io/docs/envoy/latest/) - Envoy Proxy docs
