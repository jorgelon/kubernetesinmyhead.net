# Exposing the endpoints

## Ports

By default keycloak is exposed with https enabled in the port 8443. We can change this behaviour with the following setting:

change the https port (default 8443)

```txt
via cli: --https-port
via environement variable: KC_HTTPS_PORT
via operator: spec.http.httpsPort
```

enable http (default disabled)

```txt
via cli: --http-enabled
via environement variable: KC_HTTP_ENABLED
via operator: spec.http.httpEnabled
```

change http port (defalt 8080)

```txt
via cli: --http-port
via environement variable: KC_HTTP_PORT
via operator: spec.http.httpPort
```

The management interface port is 9000. We can change it this way:

```txt
via cli: --http-management-port
via environement variable: KC_HTTP_MANAGEMENT_PORT
via operator: spec.httpManagement.port
```

## Some best practices

## About ports

Only expose the https port and do not enable the http port

## Management interface

Dot not expose the management interface

## Move the administration REST API and admin UI

Expose the administration REST API and admin UI (--hostname-admin) in a different hostname or context-path than the one used for the public frontend URLs that are used.

We only need to expose /realms and /resources in the public frontend URLs

## Links

- Configuring a reverse proxy

<https://www.keycloak.org/server/reverseproxy>

- Configuring Keycloak for production

<https://www.keycloak.org/server/configuration-production>

- All configuration

<https://www.keycloak.org/server/all-config>

- Configuring the hostname (v2)

<https://www.keycloak.org/server/hostname>
