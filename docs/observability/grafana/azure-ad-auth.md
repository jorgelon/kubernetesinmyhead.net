# Authentication via Azure

## Application Creation

Create a new application from App Registrations > New Registration

- Supported Account types:
For example, "Accounts in this organizational directory only"
- Redirect URI
In the initial wizard, set <https://migrafana.dominio.com>

## Post-configuration of the application

- Second Redirect URL
In Manage - Authentication - Web - Redirect URLs, create a new one with <https://migrafana.dominio.com/login/azuread>

- Client Secret
In "Manage - Certificates & secrets - Client secrets", create a new client secret and place its value in the GF_AUTH_AZUREAD_CLIENT_SECRET variable

- Groups claim
In "Manage - Token Configuration", add a groups claim by selecting "security groups" and "Groups assigned to the application"

- API permissions
We should have Microsoft Graph - User.Read

- App Roles
Create 3 roles with the same Display Name, Value, and Description, choosing "Users/Groups" as "Allowed member types".
These values will be Viewer, Editor, and GrafanaAdmin

- Add groups
From Enterprise Applications, enter our application and in Manage - Users and groups, choose the groups and users we want and map them to the desired roles

## Environment Variables List

### Authentication

```txt
GF_AUTH_AZUREAD_AUTH_URL: value shown as "OAuth 2.0 authorization endpoint (v2)" in "Endpoints"
GF_AUTH_AZUREAD_TOKEN_URL: value shown as "OAuth 2.0 token endpoint (v2)" in "Endpoints"
GF_AUTH_AZUREAD_CLIENT_ID: value shown as "Application (client) ID" in Overview
GF_AUTH_AZUREAD_CLIENT_SECRET: value of the secret created earlier
```

## Users and Role Assignment

If no role is defined in the application, the value assigned will be the one indicated in GF_USERS_AUTO_ASSIGN_ORG_ROLE.
This default value is Viewer and can also be Admin, Editor, and None.

This default role assignment behavior can be disabled by setting GF_AUTH_AZUREAD_ROLE_ATTRIBUTE_STRICT to true, which prevents login if no role is defined for the user.

| Variable                              | Typical Value | Function                                                            |
|---------------------------------------|---------------|---------------------------------------------------------------------|
| GF_USERS_AUTO_ASSIGN_ORG_ROLE         | Viewer        | Allows defining the default role for users in the main organization |
| GF_AUTH_AZUREAD_ROLE_ATTRIBUTE_STRICT |               | Disables default role assignment                                    |
| GF_AUTH_AZUREAD_SKIP_ORG_ROLE_SYNC    |               | Prevents fetching roles from Azure                                  |

It can be a good practice to enable GF_AUTH_AZUREAD_ROLE_ATTRIBUTE_STRICT, which forces the creation of application roles

### Misc

| Variable                                   | Typical Value          | Function                                               |
|--------------------------------------------|------------------------|--------------------------------------------------------|
| GF_AUTH_AZUREAD_ALLOW_ASSIGN_GRAFANA_ADMIN | false                  | Disables Grafana Admin role privileges                 |
| GF_AUTH_AZUREAD_ALLOW_SIGN_UP              | true                   |                                                        |
| GF_AUTH_AZUREAD_AUTO_LOGIN                 | false                  | Enabling it skips the login screen                     |
| GF_AUTH_AZUREAD_ENABLED                    | true                   | Enables Azure AD Auth                                  |
| GF_AUTH_AZUREAD_NAME                       | "Azure AD"             | Configuration name                                     |
| GF_AUTH_AZUREAD_SCOPES                     | "openid email profile" |                                                        |
| GF_AUTH_AZUREAD_USE_PKCE                   | true                   |                                                        |
| GF_AUTH_AZUREAD_ALLOWED_ORGANIZATIONS      |                        | Identifier of the organization we want to allow access |
| GF_AUTH_AZUREAD_ALLOWED_GROUPS             |                        | Groups we allow access, separated by commas or spaces  |
| GF_AUTH_AZUREAD_ALLOWED_DOMAIN             |                        | Domains we allow access, separated by commas or spaces |

## Links

- Configure Azure AD OAuth2 authentication
<https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/azuread/>

- Configure Grafana
<https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/>
