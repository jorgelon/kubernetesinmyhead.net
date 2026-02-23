# External dns and cert manager

This is how external dns and cert manager works with gateway api

## External DNS

> Based on external-dns v0.20.0

We assume external-dns is well configured to work with the provider. Then we need to enable gateway api sources. If we deployed it using the helm chart, we must add the desired routes as sources in the values file

```yaml
sources:
  - service
  - ingress
  - gateway-httproute
  - gateway-tcproute
  - gateway-tlsroute
  - gateway-grpcroute
  - gateway-udproute
  - crd # Enable creation of individual DNSRecords
```

> It is possible to filter what routes are being watched for every external dns instance

> **Future: ListenerSet support** — [GEP-1713](https://gateway-api.sigs.k8s.io/geps/gep-1713) introduces `ListenerSet` (currently experimental as `XListenerSet`, `gateway.networking.x-k8s.io/v1alpha1`), which allows attaching multiple sets of listeners to a parent Gateway. External-dns does not yet support `XListenerSet` as a source. Once the resource graduates from experimental to stable and is renamed to `ListenerSet`, a dedicated source entry is expected to be added alongside the existing route sources.

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

## Cert-Manager

> Based on cert-manager 1.19

We need a recent version of cert-manager and enable gateway api in the values file

```yaml
config:
  apiVersion: controller.config.cert-manager.io/v1alpha1
  kind: ControllerConfiguration
  enableGatewayAPI: true
```

In order to get a certificate we need to:

- Annotate a Gateway resource with an issuer or cluster issuer

```txt
cert-manager.io/issuer: foo
cert-manager.io/cluster-issuer: foo
```

> The certificate generation is considered to be managed by a sre team, so annotations in route resources are ignored

- Enable a HTTPS listener

The spec.dnsNames field in the generated certificate is taken from the hostname in the listener

> It must have a tls section in Terminate mode and certificateRefs must be a secret in the same namespace as the gateway

> **Future: ListenerSet support** — [GEP-1713](https://gateway-api.sigs.k8s.io/geps/gep-1713) defines `ListenerSet` (currently `XListenerSet`, experimental) to allow independent teams to attach their own listeners with separate certificates to a shared parent Gateway. Cert-manager does not yet support annotating `XListenerSet` resources directly. When the resource graduates to stable, cert-manager support will likely extend to reading issuer annotations from `ListenerSet` objects, enabling per-team certificate provisioning without granting write access to the parent Gateway.

### Migration

- Creating a gateway with DNS challenge will create a temporary TXT record with challenge token until the secret is created. It must not offer conflicts with existing ingress certificates / DNS entries.

- For creating a gateway with HTTP-01 challenge see the links section below

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
