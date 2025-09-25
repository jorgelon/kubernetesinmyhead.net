# Linking Apps

## External DNS

### Gateways

- Gateway sources

<https://kubernetes-sigs.github.io/external-dns/latest/docs/sources/gateway/>

### Routes

- Gateway API Route Sources

<https://kubernetes-sigs.github.io/external-dns/latest/docs/sources/gateway-api/>

## Cert-Manager

First we need to enable Gateway Api Support in our controller

```yaml
config:
  apiVersion: controller.config.cert-manager.io/v1alpha1
  kind: ControllerConfiguration
  enableGatewayAPI: true
```

Then we can annotate a gateway to generate the certificates

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: example
  annotations:
    cert-manager.io/issuer: foo
```

- Annotated Gateway resource

<https://cert-manager.io/docs/usage/gateway/>

- Envoy Proxy

<https://gateway.envoyproxy.io/docs/tasks/security/tls-cert-manager/>
