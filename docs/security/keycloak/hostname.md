# Setting the hostname with the operator

There are 2 ways to configure the hostname in Keycloak:

- The old way (v1)  
It was the only option until the 25.0.0 release.

The v1 version will be removed in a future release (maybe 27.0.0) and to use it in 25.0.0 or later you must enable it via the "hostname-v1" feature. The migration to v2 is highly recommended

- The new way (v2)
Appears in the 25.0.0 release (jun 2024)

## v1 Configuration (deprecated)

These are the options available to configure the 3 endpoints (frontend, backend and admin console)

### Frontend

By default, the url of the frontend endpoint is based in the incoming requests. In a production deployment is recommended to work with a fixed url for the frontend. In the keycloak operator we have 2 settings here:

- **spec.hostname.hostname**  
This setting changes the host of the frontend URLs and configures the KC_HOSTNAME environment variable

- **spec.hostname.strict**  
Enabled by default, disables dynamically resolving the hostname from request headers.

### Backend

- **strictBackchannel**  

By default backchannel URLs are dynamically resolved from request headers. Enabling this setting the URLs for the backend endpoints are going to be exactly the same as the frontend endpoints. This is recommended if all the incoming requests are made through the public url. If not, leave it disabled (false)

### Admin url

By default, the urls of the administration console are based in the request headers. In order to use a fixed url we can use one of this (they are exclusive):

- **spec.hostname.admin**
Changes the hostname for accessing the administration console setting the KC_HOSTNAME_ADMIN environment variable

- **spec.hostname.adminUrl**  
Changes the base URL for accessing the administration console setting the KC_HOSTNAME_ADMIN_URL environment variable. It includes the protocol and port

example value:

```txt
https://keycloak-admin.internal.example.org
```

### Keycloak operator options

```yaml
apiVersion: k8s.keycloak.org/v2alpha1
kind: Keycloak
metadata:
  name: keycloak
spec:
  hostname:
    hostname:
    admin:
    adminUrl:
    strict:
    strictBackchannel:
```

## v2 Configuration

**pending**

## Links

- Configuring the hostname (v1)  
<https://www.keycloak.org/server/hostname-deprecated>

- Configuring the hostname (v2)  
<https://www.keycloak.org/server/hostname>

- Hostname troubleshooting  
<https://www.keycloak.org/server/hostname>

- Admin console not loading and hostname related issues #14666  
<https://github.com/keycloak/keycloak/issues/14666>

- Upgrade to 25.0.0  
<https://www.keycloak.org/docs/25.0.0/upgrading/>

- Using a reverse proxy  
<https://www.keycloak.org/server/reverseproxy>
