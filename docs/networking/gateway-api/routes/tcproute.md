# TCPRoute (experimental)

## Purpose

TCPRoute provides Layer 4 TCP traffic routing capabilities within the Kubernetes Gateway API. It allows you to:

- **Route TCP traffic** based on port and destination matching
- **Load balance** TCP connections across multiple backend services
- **Proxy TCP streams** for non-HTTP protocols like databases, message queues, and custom applications
- **Handle persistent connections** for stateful services requiring session affinity
- **Bridge network protocols** for legacy applications and services that don't use HTTP

TCPRoute operates at the transport layer, providing simple but powerful routing for any TCP-based service without requiring protocol-specific knowledge, making it ideal for databases (PostgreSQL, MySQL), message brokers (Redis, RabbitMQ), and other TCP services in your Kubernetes cluster.

## Reference

- Info

<https://gateway-api.sigs.k8s.io/guides/tcp/>

- Spec

<https://gateway-api.sigs.k8s.io/reference/spec/#tcproute>
