# nginx.ingress.kubernetes.io/backend-protocol

**Purpose**: Specifies the protocol used to communicate with the backend service. For example, it is a common behaviour to use HTTPS for backends using that protocol.

**Valid values**: `HTTP` (default), `HTTPS`, `GRPC`, `GRPCS`, `FCGI`, `AUTO_HTTP`

## At service level

We can specify the protocol at service level with `spec.ports.[].appProtocol` in the backend kubernetes service resource. This works as a hint for be treated by different implementations, like gateway api or service mesh solutions.

Valid values are:

- IANA standard service names (http, https, tcp, grpc, http2,...)
- kubernetes.io/h2c (HTTP/2 over cleartext)
- kubernetes.io/ws (WebSocket over cleartext)
- kubernetes.io/wss (WebSocket over TLS)
- Custom implementations

**Important**: Gateway API implementations **SHOULD** honor the `appProtocol` field (per GEP-1911), but it's not a MUST requirement. So take care how every gateway api implementation uses or not appProtocol

> If a Route cannot use the specified protocol, implementations MUST set `ResolvedRefs` condition to `False` with reason `UnsupportedProtocol`

See this:

- GEP-1911: Backend Protocol Selection

<https://gateway-api.sigs.k8s.io/geps/gep-1911/>

## At gateway api implementation level

The protocol can be specified at implementation crd level

- Envoy gateway:

It provides spec.appProtocols under its **Backend** resource (gateway.envoyproxy.io/v1alpha1)

- Kgateway

It provides appProtocol under spec.static in its *Backend** resource (gateway.kgateway.dev/v1alpha1)

- Istio

It uses appProtocol or the port name

## Note about web certificates in HTTPS backends

When the backend service uses HTTPS and we want to validate the certificates we need to use a `BackendTLSPolicy` resource

But if we want to ignore that backends certificate we must use the implementation crd. Currently there is not a native gateway api implementation

- Envoy gateway:

It provides spec.tls.insecureSkipVerify under its **Backend** resource (gateway.envoyproxy.io/v1alpha1)

- Kgateway

It provides spec.tls.insecureSkipVerify under its **BackendConfigPolicy** resource (gateway.kgateway.dev/v1alpha1)
