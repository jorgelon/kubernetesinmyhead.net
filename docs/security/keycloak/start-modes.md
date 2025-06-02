# Start modes

There are 2 ways to start keycloak, development and production mode

## Development mode

In development mode we assume by default:

- HTTP is enabled
- Strict hostname resolution is disabled
- Cache is set to local (No distributed cache mechanism used for high availability)
- Theme-caching and template-caching is disabled

If we want to start keycloak in development mode using the binary, we must use this

```txt
bin/kc.[sh|bat] start-dev
```

If we want to start keycloak in development mode using the operator, we must use this

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

In the logs we can read:

```txt
Hostname settings: Base URL: <unset>, Hostname: <request>, Strict HTTPS: false, Path: <request>, Strict BackChannel: false, Admin URL: <unset>, Admin: <request>, Port: -1, Proxied: true
Running the server in development mode. DO NOT use this configuration in production.
```

## Production mode

In the production mode we assume by default:

- HTTP is disabled as transport layer security (HTTPS) is essential
- Hostname configuration is expected
- HTTPS/TLS configuration is expected

If we want to start keycloak in production mode using the binary, we must use this

```txt
bin/kc.[sh|bat] start
```

The production mode is the default mode in the keycloak operator. The minimun setup to make it work is

```yaml
apiVersion: k8s.keycloak.org/v2alpha1
kind: Keycloak
metadata:
  name: keycloak
spec:
  http:
    tlsSecret: MYSECRET_CONTAINING_CERTIFICATE
  hostname:
    hostname: MY.DOMAIN.COM
```

If we dont provide this values, we can get some errors

```txt
Key material not provided to setup HTTPS. Please configure your keys/certificates or start the server in development mode.
```

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
