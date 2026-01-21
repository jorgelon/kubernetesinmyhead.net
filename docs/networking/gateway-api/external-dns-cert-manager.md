# External DNS and cert manager

This document explains how to use gateway api with external-dns and cert-manager. It assumes a gateway api implementation and the gateway api crds and are installed

> The document is based on external-dns v0.20.0 and 1.19 cert-manager releases

## external-dns

We assume external-dns is well configured to work with the provider. Then we need to enable gateway api features in cert-manager. If we deployed it using the helm chart, must must add extraArgs for every route type we need to manage via external-dns

```yaml
extraArgs:
  - "--source=gateway-httproute" # Enables Gateway API HTTPRoute source
  - "--source=gateway-grpcroute" # Enables Gateway API GRPCRoute source
  - "--source=gateway-tlsroute" # Enables Gateway API TLSRoute source
  - "--source=gateway-tcproute" # Enables Gateway API TCPRoute source
  - "--source=gateway-udproute" # Enables Gateway API UDPRoute source
```

> It is possible to filter what routes are being watched for every external dns instance

The we can start using external-dns with gateway api.

### Annotations

The following table shows the relations between the gateway api resources and external-dns supported and recommneded annotations

The format of the annotations is:

```txt
external-dns.alpha.kubernetes.io/annotation
```

|           | target | hostname         | ttl | controller | provider specific |
|-----------|--------|------------------|-----|------------|-------------------|
| Gateway   | YES    | NO               | NO  | NO         | NO                |
| HTTPRoute | NO     | use listener     | YES | YES        | YES               |
| TLSRoute  | NO     | use listener     | YES | YES        | YES               |
| TCPRoute  | YES    | YES, recommended | YES | YES        | YES               |
| UDPRoute  | YES    | YES, recommended | YES | YES        | YES               |
| GRPCRoute | ?      | ?                | ?   | ?          | ?                 |

> Provider specific annotations can be cloudflare-*, aws-*, scw-*

## cert-manager

We need to enable gateway api features in cert-manager. If we deployed it using the helm chart, we need

```yaml
config:
  apiVersion: controller.config.cert-manager.io/v1alpha1
  kind: ControllerConfiguration
  enableGatewayAPI: true
```

In order to get a certificates we need to:

- Annotate a Gateway resource with an issuer or cluster issuer

```txt
cert-manager.io/issuer: foo
cert-manager.io/cluster-issuer: foo
```

> The certificate generation is considered to be managed by a sre team, so annotations in route resources are ignored

- Enable a HTTPS listener

The spec.dnsNames field in the generated certificate is taken from the hostname in the listener

> It must have a tls section in Terminate mode and certificateRefs must be a secret in the same namespace as the gateway

## Links

- External DNS: Gateway API Route Sources

<https://kubernetes-sigs.github.io/external-dns/latest/docs/sources/gateway-api/>

- External DNS: Gateway sources

<https://kubernetes-sigs.github.io/external-dns/latest/docs/sources/gateway/>

- External DNS: Annotations

<https://kubernetes-sigs.github.io/external-dns/latest/docs/annotations/annotations/>

- Cert manager: Annotated Gateway resource

<https://cert-manager.io/docs/usage/gateway/>

- Cert manager: HTTP-01 solver

<https://cert-manager.io/docs/configuration/acme/http01/>
