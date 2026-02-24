# EnvoyExtensionPolicy

EnvoyExtensionPolicy extends Envoy Gateway functionality through external processing, WASM plugins, Lua scripts, and external authorization services.

## Overview

- **API Group**: `gateway.envoyproxy.io/v1alpha1`
- **Kind**: `EnvoyExtensionPolicy`
- **Attachment**: Gateway or HTTPRoute via `targetRef`
- **Purpose**: Add custom processing logic to the request/response path

## Key Features

- External authorization (ExtAuth) over HTTP or gRPC
- External Processing (ExtProc) for full request/response manipulation
- WASM extensions (HTTP URL, OCI image, or ConfigMap source)
- Lua script extensions
- Policy-based extension configuration per route or gateway

## ExtAuth Example

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: ext-auth-policy
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: my-route
  extAuth:
    http:
      backendRef:
        name: auth-service
        port: 9000
      path: /verify
      headersToBackend: [Authorization, Cookie]
      headersToDownstream: [X-Auth-User, X-Auth-Groups]
      failOpen: false
```

## WASM Example

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyExtensionPolicy
metadata:
  name: wasm-plugin
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: my-gateway
  wasm:
    - name: custom-filter
      code:
        image:
          url: oci://ghcr.io/myorg/wasm-filter:v1.0.0
          sha256: abcdef1234567890...
```

## Key Configuration Sections

| Section | Purpose |
|---------|---------|
| `extAuth.http` | HTTP-based external auth service |
| `extAuth.grpc` | gRPC-based external auth service |
| `extAuth.*.failOpen` | Allow traffic if auth service is unavailable |
| `extProc` | Full request/response external processing via gRPC |
| `extProc.processingMode` | Controls which parts (headers/body) are sent to the processor |
| `wasm[].code.http` | Load WASM from an HTTP URL with SHA256 verification |
| `wasm[].code.image` | Load WASM from an OCI registry |
| `wasm[].code.configMapRef` | Load WASM from a ConfigMap |
| `wasm[].config` | Arbitrary plugin configuration passed to the WASM filter |

## Policy Precedence

HTTPRoute-level policies override Gateway-level policies.

## Official Documentation

- [External Processing](https://gateway.envoyproxy.io/docs/tasks/extensibility/ext-proc/)
- [Wasm Extensions](https://gateway.envoyproxy.io/docs/tasks/extensibility/wasm/)
- [Build a Wasm Image](https://gateway.envoyproxy.io/docs/tasks/extensibility/build-wasm-image/)
- [Lua Extensions](https://gateway.envoyproxy.io/docs/tasks/extensibility/lua/)
- [OPA Sidecar with Unix Domain Socket](https://gateway.envoyproxy.io/docs/tasks/extensibility/opa-sidecar-unix-domain-socket/)
- [External Authorization](https://gateway.envoyproxy.io/docs/tasks/security/ext-auth/)
- [Envoy Gateway Extension Server](https://gateway.envoyproxy.io/docs/tasks/extensibility/extension-server/)

## Related Resources

- [SecurityPolicy](securitypolicy.md) - Built-in security features
- [BackendTrafficPolicy](backendtrafficpolicy.md) - Backend configuration
- [EnvoyProxy](envoyproxy.md) - Proxy infrastructure
- [Envoy ExtAuth Filter](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/ext_authz_filter) - Envoy documentation
