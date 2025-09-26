# UDPRoute (experimental)

## Purpose

UDPRoute provides Layer 4 UDP traffic routing capabilities within the Kubernetes Gateway API. It allows you to:

- **Route UDP traffic** based on port and destination matching
- **Load balance** UDP packets across multiple backend services
- **Handle stateless protocols** like DNS, DHCP, and logging services
- **Support connectionless communication** for services that don't maintain persistent connections
- **Route multimedia traffic** for streaming protocols and real-time applications
- **Manage fire-and-forget messaging** patterns common in distributed systems

UDPRoute operates at the transport layer for connectionless UDP traffic, providing simple packet forwarding without session tracking. This makes it ideal for services like DNS servers, syslog collectors, game servers, streaming media applications, and other UDP-based services that require fast, low-overhead packet delivery in your Kubernetes cluster.

## Reference

- Spec

<https://gateway-api.sigs.k8s.io/reference/spec/#udproute>
