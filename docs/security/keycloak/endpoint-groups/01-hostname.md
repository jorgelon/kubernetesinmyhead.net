# Hostname

In order to make Keycloak accessible via the frontend URL, we must configure the hostname option:

```txt
via cli: --hostname parameter
via environment variable: KC_HOSTNAME
via operator: spec.hostname.hostname
```

The parts of the base URL we dont specify will be resolved dynamically with the request.
Some hostname examples:

```txt
my.keycloak.org  < hostname only
<https://my.keycloak.org>  < scheme, hostname
<https://my.keycloak.org:123/auth>  < scheme, hostname, port, path
```

## Dynamic resolution for frontchannel

The hostname option is mandatory by default because of security reasons and this behaviour is
controlled with the following setting:

```txt
via cli: --hostname-strict parameter
via environment variable: KC_HOSTNAME_STRICT
via operator: spec.hostname.strict
```

This option is enabled by default and disables dynamically resolving the hostname from request headers.

> It should always be set to true in production, unless your reverse proxy overwrites the Host
> header. If enabled, the hostname option needs to be specified.

If don't want to specify the hostname and make it fully dynamic we must change it to false.

## Dynamic resolution for backchannel

It is possible to permit dynamic resolution for backchannel communications, then this baseURL is
dynamically resolved based on incoming headers (hostname, scheme, port and context path).
This permits applications and clients using an internal URL for communication while maintaining
the use of a public URL for frontchannel requests.

By default is set to false.

```txt
via cli: --hostname-backchannel-dynamic parameter
via environment variable: KC_HOSTNAME_BACKCHANNEL_DYNAMIC
via operator: spec.hostname.backchannelDynamic
```

## Administration url

We can also use a different base URL for the administration console. This is done with the
following setting:

```txt
via cli: --hostname-admin parameter
via environment variable: KC_HOSTNAME_ADMIN
via operator: spec.hostname.admin
```

This parameter accepts a full url. Example:

<https://admin.my.keycloak.org:8443>

### Administration REST API endpoints

This option only applies to the administration console. The Administration REST API endpoints are
accesible via the frontend URL specified by the hostname option.

If you want to restrict access to the Administration REST API, you need to do it on the reverse
proxy level. Administration Console implicitly accesses the API using the URL as specified by
the hostname-admin option.

## Troubleshooting

It is possible to troubleshoot the hostname configuration with the following setting:

```txt
via cli: --hostname-debug paramter
via environment variable: KC_HOSTNAME_DEBUG
```

via operator:

```yaml
apiVersion: k8s.keycloak.org/v2alpha1
kind: Keycloak
metadata:
  name: keycloak
spec:
  additionalOptions:
    - name: hostname-debug
      value: "true"
```

Then the debug site will be available under `/realms/{your-realm}/hostname-debug`
