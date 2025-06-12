# Endpoints

Keycloak exposes some endpoints for communication between applications and for management purposes.

We can group those endpoints in 3 main endpoint groups:

- Frontend
- Backend
- Administration

> There is another interface called the management interface

## Base URL

For that, we need to configure a base Url for them, that contains:

- a scheme (https,...)

- a hostname (example.keycloak.org,...)

- a port (8443,...)

- a path (/auth,...)

The base URL for each group has an important impact on:

- how tokens are issued and validated
- how links are created for actions that require the user to be redirected to Keycloak
- how applications will discover these endpoints when fetching the OpenID Connect Discovery Document from realms/{realm-name}/.well-known/openid-configuration.

## Frontend group

The frontend group of Keycloak endpoints refers to the URLs and API paths that are accessed by users and applications through the frontchannel. This is, via a publicly accessible communication path, typically over the internet.

These endpoints are designed for operations that require direct user interaction , such as browser-based authentication flows. Some examples are:

- The login page

Where users are redirected to authenticate.

```txt
https://<hostname>/realms/{realm}/protocol/openid-connect/auth
```

- Consent/Registration

```txt
https://<hostname>/realms/{realm}/login-actions/...
```

- Account management

User self-service account management

```txt
https://<hostname>/realms/{realm}/account/
```

- OpenID Connect Discovery Document

OIDC discovery for applications

```txt
https://<hostname>/realms/{realm}/.well-known/openid-configuration
```

- clicking on a link to reset a password

- performing actions that involve binding tokens

These activities are considered frontchannel requests because they happen over a channel that is exposed to users and external applications, rather than being restricted to internal or backend communication.

So, the front channel is a publicly accessible communication channel, which refers to a communication path that is publicly accessible, typically over the internet.

## Backend group

The backend group of Keycloak endpoints refers to URLs and API paths used for direct, programmatic communication between Keycloak and client applications, typically over a secure or private network.

These endpoints are designed for backend-to-backend interactions, such as exchanging tokens, introspecting tokens, or retrieving user information, and do not require direct user interaction.

> These endpoints handle sensitive operations like token issuance and validation.

Some examples are:

- Token Endpoint

Issues and refreshes tokens for clients.

```txt
https://<hostname>/realms/{realm}/protocol/openid-connect/token
```

- Token Introspection Endpoint
Allows clients to validate and inspect tokens.

```txt
https://<hostname>/realms/{realm}/protocol/openid-connect/token/introspect
```

- Userinfo Endpoint

Returns user profile information associated with an access token.

```txt
https://<hostname>/realms/{realm}/protocol/openid-connect/userinfo
```

- JWKS URI Endpoint

Provides the public keys used to verify JWT signatures.

```txt
https://<hostname>/realms/{realm}/protocol/openid-connect/certs
```

- Authorization Endpoint

Used by applications to obtain authorization from users (can be both frontend and backend, depending on flow).

```txt
https://<hostname>/realms/{realm}/protocol/openid-connect/auth
```

The backend endpoints are those accessible through a public domain or through a private network. They’re related to direct backend communication between Keycloak and a client (an application secured by Keycloak). Such communication might be over a local network, avoiding a reverse proxy.

## Administration group

The administration group Keycloak endpoints are URLs and API paths dedicated to managing and configuring the Keycloak server and its realms.

These endpoints are intended for administrators and are typically not exposed to the public internet for security reasons. They provide both a web-based interface and programmatic access for automation and integration.

- Administration Console

The web-based UI for managing realms, users, clients, roles, and other Keycloak resources.

```txt
https://<hostname>/admin/
```

- Admin REST API

A set of RESTful endpoints for programmatic management of Keycloak. Allows automation, scripting and integration with external systems.

```txt
https://<hostname>/admin/realms/{realm}/...
```

- Static Resources for Admin Console

CSS, JavaScript, images, and other static files required by the administration console.

```txt
https://<hostname>/resources/
```

## Links

- Configuring the hostname (v2)

<https://www.keycloak.org/server/hostname>
