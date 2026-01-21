# Backend routing to self signed

## Situation

- The argocd server is served with self signed certificate
- We have a pod that serves a process with a self signed certificate
- The CA of that self signed certificate is not under any kubernetes secret
- HTTPRoute

We have an HTTPRoute using the 443 or 80 port as backend

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: argocd
spec:
  parentRefs:
    - name: mygateway
  hostnames:
    - whatever.fqdn.com
  rules:
    - name: argocd-server
      backendRefs:
        - name: argocd-server
          port: 443
      matches:
        - path:
            type: PathPrefix
            value: /
```

One example is the argocd server. By default uses secure mode, this is the argocd-server service has 80 and 443 ports configured with 8080 as target port in the container. And this 8080 port serves https with a self signed certificate. The ca is not written in a secret or configmap.

## Problem

Accessing  <https://whatever.fqdn.com> gives ERR_TOO_MANY_REDIRECTS error

```shell
kubectl port-forward svc/argocd-server 9443:443 -n argocd
curl http://127.0.0.1:9443 # gives Temporary Redirect
curl -L http://127.0.0.1:9443  # works
```

### Reason

The ERR_TOO_MANY_REDIRECTS error occurs because of a redirect loop between the Gateway and ArgoCD. Here's what's happening:

- Gateway receives HTTPS request from client
- Gateway forwards HTTP request to ArgoCD backend (port 443, but without TLS)
- ArgoCD receives plain HTTP but expects/serves HTTPS
- ArgoCD redirects to HTTPS (back to the same URL)
- Loop repeats infinitely

The core issue is that the Gateway is sending an HTTP request to ArgoCD's HTTPS port 443, but ArgoCD is configured to serve HTTPS on that port. ArgoCD sees the plain HTTP request and redirects it to HTTPS, creating the loop.

### Other solutions

- Enable the insecure mode in argocd (less secure)
- Extract the ca, write it in a configmap/secret and use it in the BackendTLSPolicy (too much work)

## Solution: Backend and Skip TLS Verification

- We will tell the gateway it must communicate with the destination using tls via a BackendTLSPolicy
- The destination won't be a kubernetes service. We will use a Backend resource, an envoy gateway related CRD

> This is not recommended for production because of man in the middle attacks. Also it requires enabling the backend api.

### Enable the backend api

Enable at controller level. For example, via values,yaml

```yaml
config:
  envoyGateway:
    extensionApis:
      enableBackend: true
```

Create a backend

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: argocd-backend
spec:
  endpoints:
    - fqdn:
        hostname: argocd-server.argocd.svc.cluster.local
        port: 443
  tls:
    insecureSkipVerify: true
```

And change the backendref

```yaml
      backendRefs:
        - name: argocd-backend
          group: gateway.envoyproxy.io
          kind: Backend
```

## Links

- TLS Configuration

<https://gateway-api.sigs.k8s.io/guides/tls/>

- BackendTLSPolicy

<https://gateway-api.sigs.k8s.io/api-types/backendtlspolicy/>

- Backend Routing

<https://gateway.envoyproxy.io/docs/tasks/traffic/backend/>

- Backend TLS: Skip TLS Verification

<https://gateway.envoyproxy.io/docs/tasks/security/backend-skip-tls-verification/>
