# Providers

## AWS

Under AWS ew can use this solutions with gateway api

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

- How to use it with kgateway

<https://kgateway.dev/docs/main/setup/customize/aws-elb/>

- Envoy gateway is done via EnvoyProxy resource

<https://gateway.envoyproxy.io/latest/tasks/operations/customize-envoyproxy/>

### AWS Gateway API Controller

The official AWS controller for Amazon VPC Lattice

See <https://www.gateway-api-controller.eks.aws.dev/latest/>
