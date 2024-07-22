# Start modes using the operator

## Development mode

- HTTP is enabled
- Strict hostname resolution is disabled
- Cache is set to local (No distributed cache mechanism used for high availability)
- Theme-caching and template-caching is disabled

```yaml
apiVersion: k8s.keycloak.org/v2alpha1
kind: Keycloak
metadata:
  name: keycloak
spec:
  unsupported:
    podTemplate:
      spec:
        containers:
          - name: keycloak
            args:
              - start-dev
```

## Production mode

In the production mode we assume by default

- HTTP is disabled as transport layer security (HTTPS) is essential
- Hostname configuration is expected
- HTTPS/TLS configuration is expected

### Production mode disabling tls and change cache to local

```yaml
apiVersion: k8s.keycloak.org/v2alpha1
kind: Keycloak
metadata:
  name: keycloak
spec:
  http:
    httpEnabled: true
  hostname:
    strict: false
  additionalOptions:
    - name: cache
      value: local
```

## Links

- Starting Keycloak  
<https://www.keycloak.org/server/configuration#_starting_keycloak>
