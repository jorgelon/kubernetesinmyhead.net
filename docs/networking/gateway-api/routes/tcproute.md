# TCPRoute

`TCPRoute` provides Layer 4 TCP routing: it load-balances raw TCP connections to
backend services by **port**, with no protocol-specific knowledge. Ideal for
databases (PostgreSQL, MySQL), brokers (Redis, RabbitMQ) and other TCP services.

It attaches only to `TCP` listeners; the `hostname` field does not apply (routing
is by port). See the [routes overview](00-routes.md) for status and channel.

## Exposing a TCP service

For the full listener-protocol / TLS-termination decision (plain `TCP`, `TLS`
Passthrough, `TLS` Terminate) and example manifests, see
[Expose a TCP service](expose-tcp-service.md).

## Reference

- Guide: <https://gateway-api.sigs.k8s.io/guides/user-guides/tcp/>
- Spec: <https://gateway-api.sigs.k8s.io/reference/spec/#tcproute>
