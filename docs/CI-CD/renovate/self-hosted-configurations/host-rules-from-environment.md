# Host rules from environment variables

There is a setting that permits to detect host rules from environemnt variables:

```txt
via cli: --detect-host-rules-from-env
via env: RENOVATE_DETECT_HOST_RULES_FROM_ENV
```

This setting by default is disabled but, enabling it, permits to configure host rules with variables.

How that rule is detected? Renovate search for this syntax:

```txt
RENOVATE_DATASOURCENAME_DOMAIN/SUBDOMAIN_FIELD
```

for example

```txt
RENOVATE_DOCKER_DOCKER_IO_USERNAME
RENOVATE_DOCKER_DOCKER_IO_PASSWORD
```

Notes:

- The RENOVATE_ is optional, but the documentation says it will be required in the future
- Only domains/subdomains are supported. Nothing like protocols (https://,...).
- The field name can be: TOKEN, USERNAME, PASSWORD, HTTPSPRIVATEKEY, HTTPSCERTIFICATE, HTTPSCERTIFICATEAUTHORITY
- Hyphens (-) in datasource or host name must be replaced with double underscores (__).
- Periods (.) in host names must be replaced with a single underscore (_).
