# AWS NLB SNI Routing Limitations

## Overview

AWS Network Load Balancer (NLB) does not support SNI (Server Name Indication) routing, which has important implications when using Gateway API with the AWS Load Balancer Controller. This limitation affects TLSRoute implementation and requires specific architectural patterns.

## What is SNI Routing?

**SNI (Server Name Indication)** is a TLS extension that allows clients to specify the hostname they're connecting to during the TLS handshake, before the encrypted connection is established.

**SNI Routing** refers to a load balancer's ability to:

1. Inspect the SNI field in the TLS ClientHello message (without decrypting the payload)
2. Route traffic to different backend targets based on the hostname in the SNI field
3. Pass through the encrypted TLS connection to the backend

### Example Use Case

```
Client → Load Balancer (inspects SNI) → Backend
  |            |
  |            ├─ app1.example.com → Service A
  |            └─ app2.example.com → Service B
  |
  TLS handshake includes hostname
```

## Why NLB Cannot Support SNI Routing

### Layer 4 Operation

Network Load Balancers operate at **Layer 4 (TCP/UDP)**:

- They forward TCP/UDP streams without inspecting application-layer data
- They work with raw packets, IP addresses, and port numbers
- No visibility into TLS handshake details

### Routing Capabilities

NLB can only route based on:

- Source/destination IP addresses
- Source/destination ports
- Protocol (TCP/UDP)

NLB **cannot** route based on:

- Hostnames in SNI field
- HTTP headers
- TLS certificate names
- Application-layer content

### TLS Support in NLB

While NLB supports TLS, it operates in two modes:

1. **TLS Passthrough**: Forwards encrypted traffic without inspection (cannot see SNI)
2. **TLS Termination**: Decrypts traffic but still cannot route based on SNI (single certificate per listener)

## Gateway API Implications

### TLSRoute Non-Conformance

According to AWS Load Balancer Controller maintainer zac-nixon ([source](https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/4561#issuecomment-3849169928)):

> "Our TLSRoute is not conformant to the Gateway API spec, AWS NLB does not support SNI routing."

The Gateway API TLSRoute specification expects:

```yaml
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: TLSRoute
metadata:
  name: example
spec:
  parentRefs:
  - name: tls-gateway
  hostnames:
  - "app1.example.com"  # SNI-based routing expected
  - "app2.example.com"  # SNI-based routing expected
  rules:
  - backendRefs:
    - name: backend-service
```

**This pattern does not work with AWS NLB** because it cannot route based on hostnames.

### Recommendation: Use TCPRoute

The AWS Load Balancer Controller team recommends using **TCPRoute** instead:

```yaml
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: TCPRoute
metadata:
  name: example
spec:
  parentRefs:
  - name: tcp-gateway
    sectionName: tcp-443
  rules:
  - backendRefs:
    - name: gateway-proxy-service
      port: 443
```

**Why TCPRoute is better:**

- Clear expectations: Simple TCP port forwarding
- Conformant to Gateway API spec
- Matches NLB actual capabilities
- No confusion about hostname-based routing

## Architectural Patterns

### Pattern 1: Two-Tier Gateway Architecture

The recommended architecture for SNI-based routing on AWS:

```
┌─────────┐
│ Client  │
└────┬────┘
     │ TLS (SNI: app1.example.com)
     ▼
┌─────────────────────────────────────┐
│ AWS NLB (via AWS LBC + TCPRoute)    │
│ - Simple TCP:443 forwarding         │
│ - No SNI inspection                 │
└────┬────────────────────────────────┘
     │ TLS passthrough
     ▼
┌─────────────────────────────────────┐
│ Gateway Proxy (Envoy/Nginx/etc)     │
│ - Inspects SNI field                │
│ - Routes based on hostname          │
│ - Uses its own Gateway API resources│
└────┬────────────────────────────────┘
     │
     ├─ app1.example.com → Service A
     └─ app2.example.com → Service B
```

### Pattern 2: TLS Termination at NLB

For single hostname scenarios:

```
┌─────────┐
│ Client  │
└────┬────┘
     │ TLS
     ▼
┌─────────────────────────────────────┐
│ AWS NLB (TLS Listener + TCPRoute)   │
│ - Terminates TLS                    │
│ - Uses ACM certificate              │
│ - Forwards to single backend        │
└────┬────────────────────────────────┘
     │ HTTP or TLS re-encryption
     ▼
┌─────────────────────────────────────┐
│ Backend Service                     │
└─────────────────────────────────────┘
```

See [tcproute-acm.md](./tcproute-acm.md) for implementation details.

## Implementation Example

### AWS Load Balancer Controller Layer

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: nlb-gateway
spec:
  gatewayClassName: aws-load-balancer-controller
  listeners:
  - name: tls-443
    protocol: TCP
    port: 443
---
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: TCPRoute
metadata:
  name: to-gateway-proxy
spec:
  parentRefs:
  - name: nlb-gateway
    sectionName: tls-443
  rules:
  - backendRefs:
    - name: envoy-gateway-service  # or nginx-gateway-fabric-service
      port: 443
```

### Gateway Implementation Layer (Envoy Gateway Example)

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: envoy-gateway
spec:
  gatewayClassName: envoy-gateway-class
  listeners:
  - name: https
    protocol: HTTPS
    port: 443
    hostname: "*.example.com"
    tls:
      mode: Terminate
      certificateRefs:
      - name: wildcard-cert
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: app1-route
spec:
  parentRefs:
  - name: envoy-gateway
  hostnames:
  - "app1.example.com"
  rules:
  - backendRefs:
    - name: app1-service
      port: 8080
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: app2-route
spec:
  parentRefs:
  - name: envoy-gateway
  hostnames:
  - "app2.example.com"
  rules:
  - backendRefs:
    - name: app2-service
      port: 8080
```

## Comparison: ALB vs NLB

### Application Load Balancer (ALB)

**Supports:**

- HTTP/HTTPS protocols
- Host-based routing
- Path-based routing
- TLS termination with SNI support
- Multiple certificates per listener

**Gateway API Support:**

- HTTPRoute: Full support
- TLSRoute: Not applicable (terminates TLS)

### Network Load Balancer (NLB)

**Supports:**

- TCP/UDP protocols
- IP-based routing
- Port-based routing
- TLS passthrough
- TLS termination (single cert per listener)

**Gateway API Support:**

- TCPRoute: Full support
- UDPRoute: Full support
- TLSRoute: Non-conformant (no SNI routing)

## Decision Matrix

| Requirement | Use ALB | Use NLB + Gateway Proxy |
|-------------|---------|-------------------------|
| HTTP/HTTPS routing | ✓ | - |
| SNI-based TLS routing | ✓ | ✓ (at proxy layer) |
| Non-HTTP protocols | - | ✓ |
| Static IP addresses | - | ✓ |
| Lowest latency | - | ✓ |
| WebSocket/gRPC | ✓ | ✓ |
| Custom TLS policies | - | ✓ (at proxy layer) |

## Common Issues and Solutions

### Issue: TLSRoute Listener Rejection

**Error:**

```
Listener does not allow route attachment, kind does not match between listener and route
```

**Cause:** Attempting to attach TLSRoute to an NLB Gateway expecting SNI routing functionality.

**Solution:** Use TCPRoute instead of TLSRoute.

### Issue: Multiple Hostnames with NLB

**Problem:** Need to route multiple hostnames (app1.example.com, app2.example.com) but using NLB.

**Solution:**

1. Use TCPRoute to forward to a gateway proxy (Envoy/Nginx)
2. Configure SNI routing at the proxy layer using Gateway API resources

### Issue: TLS Termination with Multiple Certificates

**Problem:** NLB listener can only have one certificate, need multiple domains.

**Solution:**

- Use a wildcard certificate (*.example.com)
- Use a certificate with multiple SANs
- Use ALB instead (supports SNI with multiple certificates)

## References

- [GitHub Issue #4561](https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/4561) - Discussion about TLSRoute limitations
- [Gateway API TLSRoute Spec](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1alpha2.TLSRoute)
- [AWS NLB Documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/)
- [AWS Load Balancer Controller Gateway API Guide](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/gateway/)

## See Also

- [Gateway vs AWS Listeners](./gateway-vs-aws-listeners.md) - Mapping between Gateway API and AWS ELB concepts
- [TCPRoute with ACM](./tcproute-acm.md) - TLS termination at NLB using ACM certificates
- [Protocols](./protocols.md) - Protocol support in AWS Load Balancer Controller
