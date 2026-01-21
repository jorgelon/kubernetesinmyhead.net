# EnvoyPatchPolicy

EnvoyPatchPolicy provides low-level control over Envoy's xDS configuration through JSON patches. It's an escape hatch for advanced customization when standard CRDs don't provide the needed functionality.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `EnvoyPatchPolicy`
- **Attachment**: Gateway via `targetRef`
- **Use Case**: Advanced Envoy configuration, emergency fixes, experimental features

## ⚠️ Warnings

- **Use as last resort**: Standard CRDs should be preferred
- **Breaking changes**: Direct xDS patches may break across Envoy Gateway versions
- **Complexity**: Requires deep knowledge of Envoy's xDS API
- **Validation**: Limited validation compared to standard policies
- **Maintenance**: Harder to maintain and troubleshoot

## Key Features

- JSON Patch (RFC 6902) operations
- Patch any xDS resource (Listener, Route, Cluster, Endpoint)
- Multiple patch operations per policy
- Patch ordering and priority
- Target specific resources by name

## Basic Example

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyPatchPolicy
metadata:
  name: custom-patch
  namespace: default
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  type: JSONPatch
  jsonPatches:
    - type: Listener
      name: default/my-gateway/http
      operation:
        op: add
        path: /filter_chains/0/filters/0/typed_config/common_http_protocol_options/idle_timeout
        value: "300s"
```

## xDS Resource Types

Available resource types for patching:

- `Listener` - Listener configuration
- `RouteConfiguration` - HTTP route configuration
- `Cluster` - Upstream cluster configuration
- `ClusterLoadAssignment` - Endpoint configuration (EDS)
- `Secret` - TLS certificate configuration

## JSON Patch Operations

### Add Operation

```yaml
jsonPatches:
  - type: Listener
    name: default/my-gateway/https
    operation:
      op: add
      path: /filter_chains/0/filters/0/typed_config/stat_prefix
      value: "custom_prefix"
```

### Remove Operation

```yaml
jsonPatches:
  - type: Listener
    name: default/my-gateway/http
    operation:
      op: remove
      path: /filter_chains/0/filters/0/typed_config/use_remote_address
```

### Replace Operation

```yaml
jsonPatches:
  - type: Cluster
    name: default/my-service
    operation:
      op: replace
      path: /connect_timeout
      value: "10s"
```

### Copy Operation

```yaml
jsonPatches:
  - type: RouteConfiguration
    name: default/my-route
    operation:
      op: copy
      from: /virtual_hosts/0/routes/0
      path: /virtual_hosts/0/routes/1
```

### Move Operation

```yaml
jsonPatches:
  - type: RouteConfiguration
    name: default/my-route
    operation:
      op: move
      from: /virtual_hosts/0/routes/1
      path: /virtual_hosts/0/routes/0
```

### Test Operation

```yaml
jsonPatches:
  - type: Cluster
    name: default/my-service
    operation:
      op: test
      path: /connect_timeout
      value: "5s"
```

## Use Cases

### Custom HTTP Filter

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyPatchPolicy
metadata:
  name: custom-http-filter
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  type: JSONPatch
  jsonPatches:
    - type: Listener
      name: default/my-gateway/http
      operation:
        op: add
        path: /filter_chains/0/filters/0/typed_config/http_filters/0
        value:
          name: envoy.filters.http.lua
          typed_config:
            "@type": type.googleapis.com/envoy.extensions.filters.http.lua.v3.Lua
            inline_code: |
              function envoy_on_request(request_handle)
                request_handle:headers():add("X-Custom-Header", "custom-value")
              end
```

### Modify Cluster Settings

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyPatchPolicy
metadata:
  name: cluster-patches
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  type: JSONPatch
  jsonPatches:
    # Increase connect timeout
    - type: Cluster
      name: default/backend-service/http
      operation:
        op: replace
        path: /connect_timeout
        value: "30s"
    # Add upstream connection pool settings
    - type: Cluster
      name: default/backend-service/http
      operation:
        op: add
        path: /upstream_connection_options
        value:
          tcp_keepalive:
            keepalive_probes: 3
            keepalive_time: 300
            keepalive_interval: 60
```

### Custom Access Log Format

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyPatchPolicy
metadata:
  name: custom-access-log
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  type: JSONPatch
  jsonPatches:
    - type: Listener
      name: default/my-gateway/http
      operation:
        op: add
        path: /filter_chains/0/filters/0/typed_config/access_log/-
        value:
          name: envoy.access_loggers.file
          typed_config:
            "@type": type.googleapis.com/envoy.extensions.access_loggers.file.v3.FileAccessLog
            path: /dev/stdout
            log_format:
              json_format:
                timestamp: "%START_TIME%"
                method: "%REQ(:METHOD)%"
                path: "%REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%"
                response_code: "%RESPONSE_CODE%"
                duration: "%DURATION%"
                client_ip: "%DOWNSTREAM_REMOTE_ADDRESS%"
```

### Enable TCP Stats

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyPatchPolicy
metadata:
  name: tcp-stats
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  type: JSONPatch
  jsonPatches:
    - type: Listener
      name: default/my-gateway/tcp
      operation:
        op: add
        path: /filter_chains/0/filters/0/typed_config/stat_prefix
        value: "ingress_tcp"
```

### Add Custom Listener Filter

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyPatchPolicy
metadata:
  name: tls-inspector
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  type: JSONPatch
  jsonPatches:
    - type: Listener
      name: default/my-gateway/https
      operation:
        op: add
        path: /listener_filters/-
        value:
          name: envoy.filters.listener.tls_inspector
          typed_config:
            "@type": type.googleapis.com/envoy.extensions.filters.listener.tls_inspector.v3.TlsInspector
```

### Modify Route Configuration

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyPatchPolicy
metadata:
  name: route-patches
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  type: JSONPatch
  jsonPatches:
    # Add request mirroring
    - type: RouteConfiguration
      name: default/my-route
      operation:
        op: add
        path: /virtual_hosts/0/routes/0/route/request_mirror_policies
        value:
          - cluster: mirror-cluster
            runtime_fraction:
              default_value:
                numerator: 10
                denominator: HUNDRED
```

### Enable Original Source IP

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyPatchPolicy
metadata:
  name: original-src-ip
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  type: JSONPatch
  jsonPatches:
    - type: Cluster
      name: default/backend-service/http
      operation:
        op: add
        path: /upstream_bind_config
        value:
          source_address:
            address: "0.0.0.0"
            port_value: 0
```

## Resource Naming Conventions

### Listener Names

Format: `<namespace>/<gateway-name>/<listener-name>`

Example: `default/my-gateway/http`

### Route Names

Format: `<namespace>/<httproute-name>`

Example: `default/my-route`

### Cluster Names

Format: `<namespace>/<service-name>/<port-name-or-number>`

Example: `default/backend-service/http` or `default/backend-service/8080`

## Finding Resource Names

Use Envoy Admin API to discover resource names:

```bash
# Port-forward to Envoy proxy
kubectl port-forward -n envoy-gateway-system \
  deploy/envoy-gateway 19000:19000

# List listeners
curl -s localhost:19000/config_dump | jq '.configs[] | select(.["@type"] | contains("Listener"))'

# List routes
curl -s localhost:19000/config_dump | jq '.configs[] | select(.["@type"] | contains("Route"))'

# List clusters
curl -s localhost:19000/config_dump | jq '.configs[] | select(.["@type"] | contains("Cluster"))'
```

## Best Practices

1. **Avoid if possible** - Use standard CRDs first
2. **Document thoroughly** - Explain why the patch is needed
3. **Test extensively** - Patches can break in unexpected ways
4. **Version carefully** - Test patches across Envoy Gateway upgrades
5. **Use specific paths** - Avoid broad wildcards
6. **Monitor closely** - Watch for rejected patches
7. **Validate offline** - Test patches in non-production first
8. **Keep simple** - Multiple simple patches better than one complex patch

## Troubleshooting

### Patch Not Applied

Check Envoy Gateway logs:

```bash
kubectl logs -n envoy-gateway-system deploy/envoy-gateway -f
```

### Finding the Correct Path

Use `config_dump` to inspect current configuration:

```bash
kubectl port-forward -n envoy-gateway-system \
  deploy/envoy-gateway 19000:19000
curl localhost:19000/config_dump | jq '.'
```

### Validation Errors

Patches must conform to Envoy's protobuf definitions. Check Envoy documentation for the specific filter or configuration.

## Migration Path

When Envoy Gateway adds native support for a feature:

1. Test the native CRD in non-production
2. Compare behavior with patch-based implementation
3. Gradually migrate to native CRD
4. Remove EnvoyPatchPolicy after validation

## Related Resources

- [EnvoyProxy](envoyproxy.md) - Proxy infrastructure configuration
- [BackendTrafficPolicy](backendtrafficpolicy.md) - Backend traffic policies
- [ClientTrafficPolicy](clienttrafficpolicy.md) - Client traffic policies
- [Envoy Documentation](https://www.envoyproxy.io/docs/envoy/latest/) - xDS API reference
