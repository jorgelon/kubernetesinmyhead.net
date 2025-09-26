# GRPCRoute (standard)

## Purpose

GRPCRoute provides gRPC-specific routing capabilities within the Kubernetes Gateway API. It allows you to:

- **Route gRPC traffic** based on service names, method names, and header matching
- **Load balance** gRPC calls across multiple backend services with protocol awareness
- **Handle streaming RPCs** for both unary and streaming gRPC communication patterns
- **Apply gRPC-specific filters** for request/response transformation and middleware integration
- **Support service mesh integration** with advanced gRPC features like retries and circuit breaking
- **Enable microservices communication** with type-safe, high-performance RPC calls
- **Manage API versioning** through service and method-level routing rules

GRPCRoute operates at the application layer with deep understanding of gRPC protocols, providing sophisticated routing for modern microservices architectures. It's ideal for internal service-to-service communication, API gateways serving gRPC clients, and hybrid environments mixing HTTP and gRPC traffic in your Kubernetes cluster.

## Reference

- Info

<https://gateway-api.sigs.k8s.io/guides/grpc-routing/>
<https://gateway-api.sigs.k8s.io/api-types/grpcroute/>

- Spec

<https://gateway-api.sigs.k8s.io/reference/spec/#grpcroute>
