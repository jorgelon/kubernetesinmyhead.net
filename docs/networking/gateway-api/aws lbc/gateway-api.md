# Gateway api

It is possible to use the Aws Load Balancer Controller as gateway api implementation. To us it, you need:

- A recent version of Aws Load Balancer Controller  (>= v2.13.0)
- Clusters with Amazon VPC CNI plugin or with native AWS VPC networking, like cilium with eni ipam mode
- The official gateway api crds
- The Aws Load Balancer Controller gateway api crds
- Enabling it via feature gates (NLBGatewayAPI and ALBGatewayAPI)

via helm chart

```yaml
controllerConfig:
  featureGates:
    NLBGatewayAPI: true
    ALBGatewayAPI: true
```

## Choose NLB or ALB

The L4 loadbalacing is done via AWS NLB and the L7 via AWS ALB. Choose what balancer to use is done when creating the gateway class:

```txt
spec.controllerName: gateway.k8s.aws/nlb
spec.controllerName: gateway.k8s.aws/alb
```

## Aws Load Balancer Controller gateway api crds

The Aws Load Balancer Controller gateway api crds are:

### LoadBalancerConfiguration

This CRD permits to configure the loadbalancer at 2 levels:

- the GatewayClass (global settings) via spec.parametersRef
- the Gateway (specific settings) via spec.infrastructure.parametersRef

> How to resolve conflicts in settings is controlled via "mergingMode" in the GatewayClass's configuration

### TargetGroupConfiguration

This CRD, binded to a kubernetss service, permits to configure the AWS Target Groups, for example, defining targetType and health checks with default settings or specific settings per route

### ListenerRuleConfiguration

This CRD permits to configure AWS ALB settings not implemented in the standard Gateway API CRDs.
