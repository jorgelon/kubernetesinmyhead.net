# Providers

## AWS

Under AWS ew can use this solutions with gateway api

### AWS Gateway API Controller

The official AWS controller for Amazon VPC Lattice

See <https://www.gateway-api-controller.eks.aws.dev/latest/>

### AWS Load Balancer Controller

In version v2.13 "Using the LBC and Gateway API together is not suggested for production workloads"
See <https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/gateway/gateway/> for updated info

> To make it work it is neccesary to enable it via feature gates

With an AWS NLB:

- TCPRoute
- UDPRoute
- TLSRoute

With an AWS ALB:

- HTTPRoute
- GRPCRoute

Implementation

- kgateway

<https://kgateway.dev/docs/main/integrations/aws-elb/alb/>
<https://kgateway.dev/docs/main/integrations/aws-elb/nlb/>

- Envoy gateway (via EnvoyProxy resource

<https://gateway.envoyproxy.io/latest/tasks/operations/customize-envoyproxy/>
