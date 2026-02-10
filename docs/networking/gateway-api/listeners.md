# Listeners

Listeners are logical endpoints associated in a gateway resource (spec.listeners).
In a listener we define how the Gateway accepts incoming network traffic. A simple analogy can be as different doors a to building.

We can specify different things here

- Protocol
- Port
- Hostname
- TLS configuration
- AllowedRoutes

> The listeners must be distinct in a gateway, this is a unique combination of Port, Protocol, and hostname (if supported by the protocol)

## About protocols

Hostname specifies the virtual hostname to match for protocol types that

define this concept. When unspecified, all hostnames are matched. This

field is ignored for protocols that don't require hostname based

matching.

Implementations MUST apply Hostname matching appropriately for each of

the following protocols:

- TLS: The Listener Hostname MUST match the SNI.

- HTTP: The Listener Hostname MUST match the Host header of the request.

- HTTPS: The Listener Hostname SHOULD match both the SNI and Host head

### HTTP

If we expect plain HTTP traffic.

- Usually port 80
- HTTPRoute resources as AllowedRoutes
- We can define a hostname. It must match the host header of the requests. If no hostname is defined, all hostnames are matched.

### HTTPS

If we expect HTTP traffic with TLS termination. We usually define:

- Usually port 443
- HTTPRoute resources as AllowedRoutes
- TLS section must be added in Terminate mode (the gateway terminates the TLS downstream connection)
- We can define a hostname. It should match both the SNI and Host header of the requests. This does not require the SNI and Host header to be the same. If no hostname is defined, all hostnames are matched.

## TLS

If we expect generic TLS traffic

- Any port can be configured
- A hostname can be defined. The Listener Hostname MUST match the SNI.
- A TLS section must be defined
- If we use Terminate mode, the gateway terminates the TLS downstream connection

> The gapi documentation tells the route type supported is TLSRoute resources as an extended feature so it will be supported depending of the implementation. But I have TCPRoute resources working here as AllowedRoutes

- If we use Passthrough mode, the service (pod) terminates the TLS downstream connection. TLSRoute resources as AllowedRoutes

### TCP and UDP

If we expect raw TCP connections or UDP traffic

- Any port can be configured
- TCPRoute and UDPRoute resources as AllowedRoutes
- Hostname is ignored

## GRPC

- GRPC - gRPC over HTTP/2 with TLS → connects to GRPCRoute

## Table

This table shows the relation between the protocol, routes supported, if hostname matching is available and TLS section

| Protocol | hostname match              | TLS section   | Routes                                 |
|----------|-----------------------------|---------------|----------------------------------------|
| HTTP     | Must: hostname header       | Not supported | HTTPRoute                              |
| HTTPS    | Should: SNI and host header | Terminate     | HTTPRoute                              |
| TLS      | Must: SNI                   | Passthrough   | TLSRoute                               |
| TLS      | Must: SNI                   | Terminate     | TLSRoute (supported by implementation) |
| TLS      | Must: SNI                   | Terminate     | TCPRoute                               |
| TCP      | Ignored                     | Not supported | TCPRoute                               |
| UDP      | Ignored                     | Not supported | UDPRoute                               |
| GRPC     |                             |               | GRPCRoute                              |

## Listener status

The listener status can be obtained from the gateway resource status field

- Type Accepted

The listener is accepted or not

- Type Conflicted

There are conflicts with this listener

- Type ResolvedRefs

- Type Programmed
