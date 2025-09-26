# HTTPRoute (standard)

## Purpose

HTTPRoute provides HTTP-specific routing capabilities within the Kubernetes Gateway API. It allows you to:

- **Route HTTP traffic** based on hostnames, paths, headers, and query parameters
- **Load balance** traffic across multiple backend services
- **Transform requests** through header manipulation, URL rewriting, and redirects
- **Split traffic** for A/B testing, canary deployments, and gradual rollouts
- **Mirror traffic** to additional backends for testing and monitoring
- **Apply filters** for request/response modification and middleware integration

HTTPRoute acts as the configuration layer that defines how HTTP requests should be processed and forwarded to backend services, providing fine-grained control over HTTP traffic routing within your Kubernetes cluster.

## Reference

- Spec
<https://gateway-api.sigs.k8s.io/api-types/httproute/>
<https://gateway-api.sigs.k8s.io/reference/spec/#httproute>

- Info
<https://gateway-api.sigs.k8s.io/guides/http-routing/>
<https://gateway-api.sigs.k8s.io/guides/http-redirect-rewrite/>
<https://gateway-api.sigs.k8s.io/guides/http-header-modifier/>
<https://gateway-api.sigs.k8s.io/guides/traffic-splitting/>
<https://gateway-api.sigs.k8s.io/guides/http-request-mirroring/>
