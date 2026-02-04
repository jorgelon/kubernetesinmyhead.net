# TCPRoute and AWS Certificate Manager

This document provides a way to expose a TCPRoute to the internet with this features:

- We are using AWS Load Balancer controller as gateway api implementation
- The Gateway is up and exposed as network load balancer
- We have pre deployed certificate in AWS Certificate Manager (ACM) for the myroute.my-domain.com domain
- We want to terminate the TLS connection in the gateway
- The final pod has a self signed certificate

It seems this cannot be achieved using a TLSRoute so we must use a TCPRoute (no hostname verification)

- [Gateway API] gateway.k8s.aws/nlb listeners with protocol: TLS and tls.mode: Passthrough appear to build a TLS listener

<https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/4556>

## Gateway Class

We deploy the GatewayClass with optional LoadBalancerConfiguration via spec.parametersRef

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: nlb
spec:
  controllerName: gateway.k8s.aws/nlb
  parametersRef:
    group: gateway.k8s.aws
    kind: LoadBalancerConfiguration
    name: mylbc
    namespace: whatever
```

## Gateway

Then we must deploy the gateway using our gateway class. The listener:

- must have TLS as protocol
- the hostname must MUST match the SNI
- we only permit TCPRoute resources attached to this listener
- the tls mode must be Terminate. The secret will be ignored

> Additional settings can be specified via spec.infrastructure

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: mygateway
spec:
  gatewayClassName: nlb
  listeners:
    - name: mylistener
      protocol: TLS
      port: 5432
      hostname: "myroute.my-domain.com"
      allowedRoutes:
        namespaces:
          from: All
        kinds:
          - kind: TCPRoute
            group: gateway.networking.k8s.io
      tls:
        mode: Terminate
        certificateRefs:
          - name: fake
```

### LoadBalancerConfiguration (gateway)

We can configure the gateway with the loadbalancer name and a listener with the protocol, port, and default certificate

```yaml
apiVersion: gateway.k8s.aws/v1beta1
kind: LoadBalancerConfiguration
metadata:
  name: mygateway
spec:
  loadBalancerName: mygateway
  listenerConfigurations:
    - protocolPort: "TLS:5432"
      defaultCertificate: <ARN OF our ACM certificate>
```

## TCPRoute

The TCPRoute will match this listener.

> If using external-secrets operator with gateway api features enabled, we can create the dns entry

```yaml
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: TCPRoute
metadata:
  name: myroute
  annotations:
    external-dns.alpha.kubernetes.io/hostname: myroute.my-domain.com
spec:
  parentRefs:
    - name: mygateway
      sectionName: mylistener
      namespace: wherethegatewayis
  rules:
    - backendRefs:
        - name: myservice
          port: 5432
```

### TargetGroupConfiguration

Finally the TargetGroupConfiguration uses ip as targetType and specifies the connection as TLS

```yaml
apiVersion: gateway.k8s.aws/v1beta1
kind: TargetGroupConfiguration
metadata:
  name: myroute
spec:
  targetReference:
    name: myservice
  defaultConfiguration:
    targetType: ip
    protocol: TLS
```

## Links
