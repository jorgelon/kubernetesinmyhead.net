# Gateway Listener vs AWS Load Balancer Listener

## The Name Conflict

There is a **name conflict** between two different concepts that both use the term "listener":

1. **Gateway API Listener** - A logical endpoint defined in a Gateway resource (Kubernetes concept)
2. **AWS Load Balancer Listener** - An actual listener on the AWS Load Balancer that handles incoming connections (AWS infrastructure concept)

This naming overlap can cause confusion when working with the AWS Load Balancer Controller.

## Gateway API Listener (Kubernetes Concept)

A Gateway API listener is defined in the `Gateway.spec.listeners[]` section of a Gateway resource.

**Purpose**: Defines a logical endpoint that:

- Specifies what protocol and port the Gateway accepts traffic on
- Defines which Route resources can attach to it
- Configures hostname matching rules
- Sets up TLS configuration

**Important**: Creating a Gateway with listeners **does NOT** create AWS listeners in the load balancer.

## AWS Load Balancer Listener (AWS Infrastructure)

An AWS listener is an actual component on the AWS Load Balancer (NLB or ALB) that:

- Listens for connection requests on a specific protocol and port
- Forwards requests to target groups
- Handles TLS termination (for TLS listeners)

**Important**: AWS listeners are **created when Route resources are deployed**, not when the Gateway is created.

## Lifecycle Flow

### Step 1: Create Gateway

When you create a Gateway resource:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: my-gateway
spec:
  gatewayClassName: aws-nlb-gateway-class
  listeners:
  - name: tcp-app
    protocol: TCP
    port: 8080
```

**What happens**:

- ✅ AWS Load Balancer (NLB or ALB) is created
- ❌ AWS listeners are **NOT** created yet
- The Gateway resource defines the load balancer type:
  - `gateway.k8s.aws/nlb` → Creates Network Load Balancer (NLB)
  - `gateway.k8s.aws/alb` → Creates Application Load Balancer (ALB)

### Step 2: Create Route

When you create a Route resource that references the Gateway:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: TCPRoute
metadata:
  name: my-tcp-route
spec:
  parentRefs:
  - name: my-gateway
    sectionName: tcp-app
  rules:
  - backendRefs:
    - name: my-service
      port: 9000
```

**What happens**:

- ✅ AWS listener is **NOW created** on the load balancer
- The AWS listener is configured based on the Route and LoadBalancerConfiguration settings

## Configuring AWS Listener Settings

Although AWS listeners are created when Routes are deployed, you can **pre-configure** their settings using a `LoadBalancerConfiguration` resource.

### LoadBalancerConfiguration

Settings are located under `spec.listenerConfigurations` in the LoadBalancerConfiguration resource:

```yaml
apiVersion: gateway.k8s.aws/v1beta1
kind: LoadBalancerConfiguration
metadata:
  name: example-config
spec:
  listenerConfigurations:
    - protocolPort: TCP:8080
      defaultCertificate: arn:aws:acm:...
      certificates: [arn-1, arn-2]
      sslPolicy: ELBSecurityPolicy-TLS13-1-2-Res-2021-06
      alpnPolicy: HTTP2Preferred
      targetGroupStickiness:
        enabled: true
        durationSeconds: 3600
      mutualAuthentication:
        mode: verify
        trustStoreArn: arn:aws:...
      listenerAttributes:
        - key: tcp.idle_timeout.seconds
          value: "350"
```

Available configuration options:

- **protocolPort** - Protocol + port combination (e.g., `TCP:8080`, `TLS:443`)
- **defaultCertificate** - Default SSL certificate ARN
- **certificates** - List of additional certificate ARNs
- **sslPolicy** - TLS security policy
- **alpnPolicy** - ALPN policy for protocol negotiation
- **targetGroupStickiness** - Session stickiness configuration
- **mutualAuthentication** - mTLS authentication settings
- **quicEnabled** - Enable QUIC protocol for UDP
- **listenerAttributes** - Other AWS listener attributes

## Where LoadBalancerConfiguration is Used

The LoadBalancerConfiguration can be referenced at two levels:

### 1. GatewayClass Level (Global Settings)

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: aws-nlb-gateway-class
spec:
  controllerName: gateway.k8s.aws/nlb
  parametersRef:
    group: gateway.k8s.aws
    kind: LoadBalancerConfiguration
    name: global-config
```

### 2. Gateway Level (Specific Settings)

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: my-gateway
spec:
  gatewayClassName: aws-nlb-gateway-class
  infrastructure:
    parametersRef:
      group: gateway.k8s.aws
      kind: LoadBalancerConfiguration
      name: gateway-specific-config
```

### Configuration Merging

When both GatewayClass and Gateway have LoadBalancerConfiguration:

- Both configurations are **merged**
- The merge behavior is controlled by `spec.mergingMode` in the GatewayClass's LoadBalancerConfiguration

## Summary

| Concept                       | What It Is                           | When Created            | Purpose                                                          |
|-------------------------------|--------------------------------------|-------------------------|------------------------------------------------------------------|
| **Gateway Listener**          | Logical endpoint in Gateway resource | When Gateway is created | Defines what traffic Gateway accepts and which Routes can attach |
| **AWS Listener**              | Actual AWS Load Balancer listener    | When Route is deployed  | Handles incoming connections on AWS infrastructure               |
| **LoadBalancerConfiguration** | Settings resource                    | Before Gateway/Route    | Pre-configures how AWS listeners will be set up                  |

## Key Takeaways

1. **Gateway listener** ≠ **AWS listener** - they are different concepts despite the naming overlap
2. Creating a Gateway creates the **AWS Load Balancer only**, not AWS listeners
3. AWS listeners are created when **Route resources are deployed**
4. Use **LoadBalancerConfiguration** to pre-configure AWS listener settings before Routes are created
5. LoadBalancerConfiguration can be applied at GatewayClass level (global) or Gateway level (specific)
6. Each L4 Gateway listener supports **exactly one** L4 Route resource
