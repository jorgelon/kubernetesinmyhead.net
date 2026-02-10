# Backend Security Risks

The Backend CRD extends Gateway API routing beyond standard Kubernetes Services. While this flexibility is useful, it introduces a significant attack surface that must be understood and mitigated. Envoy Gateway ships with Backend support **disabled by default** for this reason.

## Overview

- **CRD**: `Backend` (`gateway.envoyproxy.io/v1alpha1`)
- **Risk category**: Routing boundary bypass
- **Default state**: Disabled -- must be explicitly enabled in the `EnvoyGateway` configuration
- **Core concern**: A Backend resource can route traffic to destinations that would otherwise be unreachable or restricted

## Why Backend Is Disabled by Default

The Backend API can be misused to allow traffic to be sent to otherwise restricted destinations. Unlike standard Kubernetes Service references, which are bound by namespace boundaries and `ReferenceGrant` controls, a Backend resource can target arbitrary FQDNs, IPs, and Unix domain sockets.

Enabling it requires an explicit opt-in via the `extensionApis.enableBackend` field in the `EnvoyGateway` configuration.

## Risk Assessment

### ReferenceGrant Bypass

Gateway API uses `ReferenceGrant` to control cross-namespace references. This is a fundamental security boundary -- a route in namespace `A` cannot reference a Service in namespace `B` without an explicit grant.

Backend resources circumvent this model. A Backend with an FQDN or IP endpoint does not require a `ReferenceGrant`, because the target is not a namespaced Kubernetes resource. This effectively breaks the trust model that Gateway API provides.

**Severity**: Medium

**Impact**: Routes can reach services in namespaces they were never authorized to access, without the target namespace owner's consent.

### Envoy Proxy Localhost Exposure

A Backend resource pointing to `127.0.0.1` or the Envoy proxy's own address can expose internal management interfaces, most critically the **Envoy admin endpoint** (typically on port `19000`).

The admin endpoint exposes full configuration dumps, cluster and listener statistics, runtime modification capabilities, server shutdown, heap profiling, and logging level changes.

**Severity**: High

**Impact**: Configuration leak, runtime manipulation, potential denial of service via the admin interface.

**Built-in mitigation**: Loopback addresses (`127.0.0.1`, `::1`) and `localhost` are explicitly forbidden in Backend endpoints. However, this guardrail may not cover all edge cases (e.g., a pod IP that resolves to the proxy itself).

### Open Proxy via DynamicResolver

The `DynamicResolver` Backend type allows Envoy to act as a forward proxy, dynamically resolving hostnames at request time without prior configuration. This effectively makes Envoy an **open proxy** that can route traffic to any destination reachable from the cluster network.

**Severity**: High

**Impact**: All network-reachable endpoints become accessible through the gateway. This includes internal services, cloud metadata endpoints (e.g., `169.254.169.254`), and external systems. It disables all routing controls that the Gateway API was designed to enforce.

### Internal Service Exposure

A Backend with a static IP or FQDN can expose cluster-internal services that were never meant to receive external traffic. Any user with permission to create a Backend resource can target sensitive internal infrastructure such as `kube-dns`, the Kubernetes API server, databases, or monitoring systems.

**Severity**: Medium to High (depends on network policies in place)

**Impact**: Unauthorized access to internal services, cloud provider metadata endpoints, or other sensitive infrastructure.

### Unix Domain Socket Risks

Backend resources can target Unix domain sockets on the Envoy proxy pod filesystem. Envoy Gateway does **not** manage the lifecycle of Unix sockets -- administrators must manually create and mount them into the Envoy proxy pods. A misconfigured socket path could expose unintended local services.

**Severity**: Low to Medium

**Impact**: Depends on what is listening on the socket. Could expose sidecar processes, local agents, or other sensitive endpoints.

## Risk Summary

| Risk                         | Severity    | Mitigated By                  |
|------------------------------|-------------|-------------------------------|
| ReferenceGrant bypass        | Medium      | RBAC on Backend CRD           |
| Envoy admin exposure         | High        | Built-in loopback prohibition |
| Open proxy (DynamicResolver) | High        | RBAC, avoid DynamicResolver   |
| Internal service exposure    | Medium-High | RBAC, network policies        |
| Unix socket exposure         | Low-Medium  | Pod security, RBAC            |

## Mitigation Strategies

### Restrict Access with Kubernetes RBAC

This is the primary and most important control. Only cluster administrators should be able to create, modify, or delete Backend resources. Create a dedicated `ClusterRole` that grants Backend management and bind it exclusively to trusted platform admin groups.

### Enforce with Policy Engines

Use Kyverno or OPA/Gatekeeper to enforce additional constraints on Backend resources, such as denying endpoints that target internal CIDRs (`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, `169.254.0.0/16`) or blocking `DynamicResolver` backends entirely.

### Apply Network Policies

Network policies on the Envoy proxy pods limit the blast radius even if a Backend resource is misconfigured. Restrict egress from the gateway namespace to only the CIDRs and ports that are legitimately needed.

### Audit Backend Resources Regularly

Monitor for Backend resource creation and modification. Periodically list all Backend resources across namespaces and inspect them for `DynamicResolver` usage or IP-based endpoints targeting internal ranges.

## When to Use Backend Despite the Risks

Backend resources are appropriate when:

1. **External FQDN routing** is needed and the target is a well-known, controlled external service
2. **Legacy IP-based services** exist that cannot be represented as Kubernetes Services
3. **Unix domain sockets** are required for sidecar communication patterns

In all cases, pair with RBAC restrictions and network policies.

## When to Avoid Backend

- Do not use Backend when a standard Kubernetes Service reference would work
- Do not enable `DynamicResolver` unless you have a specific forward-proxy use case with strong compensating controls
- Do not use Backend to work around `ReferenceGrant` requirements -- fix the grants instead

## Related Resources

- [Backend](backend.md) - Backend CRD functional documentation
- [SecurityPolicy](securitypolicy.md) - Gateway security controls
- [Envoy Gateway Backend Documentation](https://gateway.envoyproxy.io/docs/tasks/traffic/backend/) - Official documentation
- [Gateway API Security Model](https://gateway-api.sigs.k8s.io/concepts/security-model/) - ReferenceGrant and trust boundaries
