# Management interface

The management interface in Keycloak is a dedicated HTTP interface that exposes the health checks and metrics.

If the health checks and metrics are disabled, the management inteface is automatically turned off.

## Health checks

THe health check can be controlled by this setting:

```txt
via cli: --health-enabled parameter
via environment variable: KC_HEALTH_ENABLED
```

> The health check is enabled by default in the operator. Disabling it will make the kubernetes probes fail.

## Metrics endpoint

THe metrics endpoint can be controlled by this setting:

```txt
via cli: --metrics-enabled parameter
via environment variable: KC_METRICS_ENABLED
```

In the operator we can use the additionalOptions key.

```yaml
apiVersion: k8s.keycloak.org/v2alpha1
kind: Keycloak
metadata:
  name: keycloak
spec:
  additionalOptions:
    - name: metrics-enabled
      value: "true"
```

## Port

The default management interface port is 9000. We can change it this way:

```txt
via cli: --http-management-port
via environement variable: KC_HTTP_MANAGEMENT_PORT
via operator: spec.httpManagement.port
```

## Notes

- In old releases, the management interface was enabled in the default server, but this behaviour, that can be enabled, it is not recommended and it will be deprecated.

- The management interface has its own settings like relative path or certificates but, if they are not specified, they are inherited from the default server

## Links

- Configuring the Management Interface

<https://www.keycloak.org/server/management-interface>

- Configuring the Management Interface (Redhat)

<https://docs.redhat.com/en/documentation/red_hat_build_of_keycloak/26.2/html/server_configuration_guide/management-interface->

- All management interface settings

<https://www.keycloak.org/server/all-config#category-management>

- Configuring a reverse proxy

<https://www.keycloak.org/server/reverseproxy>
