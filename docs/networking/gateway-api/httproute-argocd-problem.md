# Httproute argocd problems

## Situation

- Argocd server

Argocd by default uses secure mode. This means the argocd-server service has 80 and 443 ports configured with 8080 as target port in the container. And this 8080 port serves https with a self signed certificate. The ca is not written in a secret or configmap.

- Gateway

We have a gateway tha terminates the TLS connection with a certificate in a secret

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: mygateway
spec:
  gatewayClassName: myclass
  listeners:
    - protocol: HTTPS
      port: 443
      hostname: "whatever.fqdn.com"
      ...
      tls:
        mode: Terminate
        certificateRefs:
          - kind: Secret
            name: XXXX
```

- HTTPRoute

And a HTTPRoute using the 443 or 80 port as backend

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

## Problem

Accessing  <https://whatever.fqdn.com> gives ERR_TOO_MANY_REDIRECTS error

```shell
kubectl port-forward svc/argocd-server 9443:443 -n argocd
curl http://127.0.0.1:9443 # gives Temporary Redirect
curl -L http://127.0.0.1:9443  # works
```

## Reason

The ERR_TOO_MANY_REDIRECTS error occurs because of a redirect loop between the Gateway and ArgoCD. Here's what's happening:

- Gateway receives HTTPS request from client
- Gateway forwards HTTP request to ArgoCD backend (port 443, but without TLS)
- ArgoCD receives plain HTTP but expects/serves HTTPS
- ArgoCD redirects to HTTPS (back to the same URL)
- Loop repeats infinitely

The core issue is that the Gateway is sending an HTTP request to ArgoCD's HTTPS port 443, but ArgoCD is configured to serve HTTPS on that port. ArgoCD sees the plain HTTP request and redirects it to HTTPS, creating the loop.

## Solutions

- Insecure mode

Change argocd settings to use insecure mode and use port 80 in the httproute

- Use a BackendTLSPolicy

The problem here is the argocd certificate is selfsigned and we dont have the CA in a secret/configmap to do the validation. Gateway api does not support skip certificate verification. We should extract the ca, write it in a configmap/secret and use it in the BackendTLSPolicy

- Use Backend approach (insecure)

Example using envoy gateway. First enable at controller level

```yaml
    extensionApis:
      enableBackend: true
```

Create a backend

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: argocd-backend
  namespace: argocd
spec:
  endpoints:
    - fqdn:
        hostname: whatever.fqdn.com
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
