# Protocols in Network Load Balancer

## Two Different Protocol Concepts

When working with AWS Load Balancer Controller and Gateway API, there are **two different protocol concepts** that serve different purposes:

1. **Gateway API Listener Protocol** (Kubernetes-level) - Defined in `Gateway.spec.listeners[].protocol`
2. **AWS NLB Listener Protocol** (AWS infrastructure-level) - Defined in the actual AWS Network Load Balancer listener

## Gateway API Listener Protocol

The Gateway API listener protocol tells the Gateway API:

- **What type of traffic pattern** to expect
- **Which Route types** can attach to this listener

Supported values: `HTTP`, `HTTPS`, `TLS`, `TCP`, `UDP`

## AWS NLB Listener Protocol

The AWS NLB listener protocol tells AWS **how to handle the connection** at the load balancer level.

Supported values: `TCP`, `TLS`, `UDP`, `TCP_UDP`, `QUIC`, `TCP_QUIC`

Critical AWS NLB behavior:

- **`TLS` protocol**: Load balancer **terminates TLS**, decrypts traffic, and forwards **plain TCP** to backends
- **`TCP` protocol on port 443**: Used for **TLS passthrough** - load balancer passes encrypted traffic through without decrypting

## How AWS Listener Protocol is Determined

The AWS listener protocol is **explicitly configured** via the `LoadBalancerConfiguration` resource using the `protocolPort` field.

The format is `<AWS_PROTOCOL>:<PORT>` where AWS_PROTOCOL is one of: TCP, TLS, UDP, TCP_UDP, QUIC, TCP_QUIC

## Common Scenarios

### Scenario 1: TLS Termination at NLB

Gateway listener with `TLS` protocol + LoadBalancerConfiguration with `TLS:443` protocolPort

**Result**: AWS NLB listener with `TLS` protocol → Terminates TLS, sends plain TCP to pods

### Scenario 2: TLS Passthrough (End-to-End Encryption)

Gateway listener with `TLS` protocol + LoadBalancerConfiguration with `TCP:443` protocolPort

**Result**: AWS NLB listener with `TCP` protocol → Passes encrypted traffic to pods, pods terminate TLS

### Scenario 3: Plain TCP (Database)

Gateway listener with `TCP` protocol + LoadBalancerConfiguration with `TCP:5432` protocolPort

**Result**: AWS NLB listener with `TCP` protocol → Plain TCP forwarding

## Protocol Mapping Table

| Gateway Listener Protocol | LoadBalancerConfiguration protocolPort | AWS NLB Listener Protocol | Behavior                                         |
|---------------------------|----------------------------------------|---------------------------|--------------------------------------------------|
| `TLS` (Terminate)         | `TLS:443`                              | `TLS`                     | NLB terminates TLS, sends plain TCP to backends  |
| `TLS` (Passthrough)       | `TCP:443`                              | `TCP`                     | NLB passes encrypted traffic through to backends |
| `TCP`                     | `TCP:port`                             | `TCP`                     | Plain TCP forwarding                             |
| `UDP`                     | `UDP:port`                             | `UDP`                     | Plain UDP forwarding                             |

## Key Takeaways

1. **Gateway listener protocol** determines which Route types can attach (TCPRoute, TLSRoute, UDPRoute, etc.)
2. **AWS listener protocol** (configured via LoadBalancerConfiguration) determines the actual AWS NLB behavior
3. For **TLS termination**: Use AWS protocol `TLS` in LoadBalancerConfiguration
4. For **TLS passthrough**: Use AWS protocol `TCP` on port 443 in LoadBalancerConfiguration
5. Each L4 Gateway listener can handle traffic for **exactly one** L4 Route resource
6. Certificates for TLS termination are discovered from ACM via hostname matching
