# nginx.ingress.kubernetes.io/force-ssl-redirect: "true"

**Purpose**: Forces HTTP traffic to redirect to HTTPS automatically.

In Gateway API, you need to create:

1. A Gateway with both HTTP (port 80) and HTTPS (port 443) listeners
2. An HTTPRoute attached to the HTTP listener that redirects to HTTPS
3. An HTTPRoute attached to the HTTPS listener that routes to your backend

**2. HTTPRoute for HTTP to HTTPS Redirect:**

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: example-redirect
spec:
  parentRefs:
  - name: eg
    sectionName: http  # Attach to HTTP listener
  hostnames:
  - "www.example.com"
  rules:
  - filters:
    - type: RequestRedirect
      requestRedirect:
        scheme: https
        statusCode: 301  # Permanent redirect (default)
```

**References:**

- [Envoy Gateway HTTP Redirects](https://gateway.envoyproxy.io/docs/tasks/traffic/http-redirect/)
- [Gateway API HTTP Redirect/Rewrite Guide](https://gateway-api.sigs.k8s.io/guides/http-redirect-rewrite/)
