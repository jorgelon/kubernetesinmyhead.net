# TLSRoute (experimental)

## Purpose

The TLSRoute resource is similar to TCPRoute, but can be configured to match against TLS-specific metadata. This allows more flexibility in matching streams for a given TLS listener.

TLSRoute provides TLS-aware traffic routing capabilities within the Kubernetes Gateway API. It allows you to:

- **Route TLS traffic** based on SNI (Server Name Indication) without terminating encryption
- **Preserve end-to-end encryption** by passing through encrypted traffic to backend services
- **Handle TLS passthrough** for services that need to manage their own TLS termination
- **Route encrypted protocols** like HTTPS, secure databases, and other TLS-wrapped services
- **Support SNI-based routing** for multiple domains sharing the same IP address
- **Maintain certificate control** at the backend service level

TLSRoute operates at the TLS layer, inspecting only the SNI information in the TLS handshake to make routing decisions while keeping the payload encrypted. This makes it ideal for scenarios where backend services need direct control over TLS termination and certificate management, or when compliance requirements mandate end-to-end encryption.

## Reference

- Spec

<https://gateway-api.sigs.k8s.io/reference/spec/#tlsroute>
