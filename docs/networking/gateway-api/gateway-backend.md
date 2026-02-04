# Gateway to Backend (upstream)

The connection between the gateway and the final pods (via services) is known as **Upstream connections**.

## TLS

A typical situation is when we want to terminate the TLS connection in the gateway but the final pod also uses TLS.

In order to configure it we must use a gateway api resource called BackendTLSPolicy

### BackendTLSPolicy

This resource has 2 main fields:

#### spec.targetRefs
  
It permits to specify a list of kubernetes resources that will receive this policy. This usually is a kubernetes service, but it can be a Gateway or an HTTPRoute
Here we can specify the group, kind and name of the resource. An additional sectionName can be specify with different meaning depending of the targeted resource:

- Service: Port name
- Gateway: Listener name
- HTTPRoute: HTTPRouteRule name

#### spec.validation

Here we configure how the gateway validates the final certificate, providing:

- hostname and subjectAltNames
- if we want to use the system CAs or a custom one

## BackendTLSPolicy with self signed certificates

But this resource don't includes the possibility skip the verification of the pods certificate, required when working with self signed certificates. Then the upstream connection fails.

<https://github.com/kubernetes-sigs/gateway-api/issues/3761>

In order to handle it, we must use solutions provided by the gateway api implementation.

### Envoy Gateway

In Envoy Gateway implementations we can achieve this creating an Envoy Gateway Backend resource that specifies the tls verification must be skipped, and modify the route rule to use this backend resource as backendRefs.

> Backend resources must be enabled first in the envoy gateway deployment

### AWS Load Balancer Controller

In AWS Load Balancer Controller and a TCPRoute we can achieve this for example creating a TargetGroupConfiguration with a default configuration with TLS as protocol.

> AWS Load Balancer Controller seems to not verify by default the backend certificate

```yaml
apiVersion: gateway.k8s.aws/v1beta1
kind: TargetGroupConfiguration
metadata:
  name: broker-expose-85309-11170
spec:
  defaultConfiguration:
    protocol: TLS
```

## Links

- BackendTLSPolicy

<https://gateway-api.sigs.k8s.io/api-types/backendtlspolicy/>

- Upstream TLS

<https://gateway-api.sigs.k8s.io/guides/tls/#upstream-tls>

- Backend TLS: Gateway to Backend (envoy gateway)

<https://gateway.envoyproxy.io/docs/tasks/security/backend-tls/>

- Backend TLS: Skip TLS Verification (envoy gateway)

<https://gateway.envoyproxy.io/docs/tasks/security/backend-skip-tls-verification/>

- Target groups for your Network Load Balancers (AWS Load Balancer Controller)

<https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html>
