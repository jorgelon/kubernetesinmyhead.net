# Enable Gateway API

## Gateway API CRDs

We must deploy the gateway api CRDs. We can choose between the standard and the experimental install.

The standard installation, includes CRDs in GA or beta status

- GatewayClass
- Gateway
- HTTPRoute
- ReferenceGrant

The experimental installation add some experimental CRDs:

- TCPRoute
- TLSRoute
- UDPRoute

Things to consider

- Some implementations include the Gateway API CRDs. Other need to be installed separetly. Check what version the implementation suggest in this case.
- Mixing different implementations in the same k8s cluster adds a decision about how to deploy them and what version to choose

## Implementations

Here we have a have a lot of implementations with different ways to be deployed.

- [Implementation list from Gateway API doc](https://gateway-api.sigs.k8s.io/implementations/)
- [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/gateway/gateway/)

### AWS Load Balancer Controller

We need the helm chart 3.0.0 at least and in the values file

```yaml
controllerConfig:
  featureGates:
    NLBGatewayAPI: true
    ALBGatewayAPI: true
```

## External DNS

We need a recent version of the external-dns helm chart and add the desired routes as sources in the values file

```yaml
sources:
  <...>
  - gateway-httproute
  - gateway-tcproute
  - gateway-udproute
  - gateway-tlsroute
  - gateway-grpcroute
```

## Cert-Manager

We need a recent version of cert-manager and and enable gateway api in the values file

```yaml
config:
  apiVersion: controller.config.cert-manager.io/v1alpha1
  kind: ControllerConfiguration
  enableGatewayAPI: true
```
