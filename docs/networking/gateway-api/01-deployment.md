# Deployment

In order to deploy gateway api we need to deploy different components

## Gateway API CRDs

We need to deploy the official gateway api CRDs. We have all the releases in the official repository.

<https://github.com/kubernetes-sigs/gateway-api/releases>

We have 2 options here:

### Standard

The standard installation, includes CRDs in GA or beta status

- GatewayClass
- Gateway
- HTTPRoute
- ReferenceGrant

### Experimental

The experimental installation add some experimental CRDs:

- TCPRoute
- TLSRoute
- UDPRoute

## Gateway Api Controller

Here we have a have a lot of implementations with different ways to be deployed.

- [Implementation list from Gateway API doc](https://gateway-api.sigs.k8s.io/implementations/)
- [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/gateway/gateway/)
- [Ingate (nginx ingress controller replacement)](https://github.com/kubernetes-sigs/ingate)

## Gateway Api Controller CDRs

The Gateway Api controller usually need to deploy its own CRDs. Read the documentation when deploying the controller.
This CRDs permits to configure different aspects of the controller, sometime directly related with exclusive settings of its implementation.

## Notes

- Check the deployment of the chosen gateway controller if it includes the Gateway API CRDs and the Gateway Api Controller CDRs
- If planning to use only a gateway api controller, it can be a good idea to install the Gateway API CRDs concrete version found in its documentation
- Mixing different controllers in the same k8s cluster adds a decision about what version of the Gateway API CRDs deploy
