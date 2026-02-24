# EnvoyPatchPolicy

EnvoyPatchPolicy provides low-level control over Envoy's xDS configuration via JSON patches (RFC 6902). It is an escape hatch for cases where standard CRDs cannot express the required configuration.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `EnvoyPatchPolicy`
- **Attachment**: Gateway via `targetRef`
- **Use with caution**: Direct xDS patches may break across Envoy Gateway versions

## Key Features

- JSON Patch operations: `add`, `remove`, `replace`, `copy`, `move`, `test`
- Targets any xDS resource: `Listener`, `RouteConfiguration`, `Cluster`, `ClusterLoadAssignment`, `Secret`
- Multiple patches per policy
- Resource selection by name

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
    - type: Cluster
      name: default/backend-service/http
      operation:
        op: replace
        path: /connect_timeout
        value: "30s"
```

## Resource Naming Conventions

| Resource | Name format |
|----------|-------------|
| Listener | `<namespace>/<gateway-name>/<listener-name>` |
| RouteConfiguration | `<namespace>/<httproute-name>` |
| Cluster | `<namespace>/<service-name>/<port-name-or-number>` |

Use the Envoy admin API to discover current resource names:

```bash
kubectl port-forward -n envoy-gateway-system deploy/envoy-gateway 19000:19000
curl -s localhost:19000/config_dump | jq '.configs[] | select(.["@type"] | contains("Listener"))'
```

## When to Use

Prefer standard CRDs for all configuration. Use `EnvoyPatchPolicy` only when:

- A required Envoy feature has no equivalent CRD yet
- An emergency workaround is needed before an upstream fix
- Testing experimental Envoy capabilities

Always document why a patch is needed and plan to remove it once native CRD support is available.

## Official Documentation

- [Envoy Patch Policy](https://gateway.envoyproxy.io/docs/tasks/extensibility/envoy-patch-policy/)

## Related Resources

- [EnvoyProxy](envoyproxy.md) - Proxy infrastructure configuration
- [BackendTrafficPolicy](backendtrafficpolicy.md) - Backend traffic policies
- [ClientTrafficPolicy](clienttrafficpolicy.md) - Client traffic policies
- [Envoy Documentation](https://www.envoyproxy.io/docs/envoy/latest/) - xDS API reference
