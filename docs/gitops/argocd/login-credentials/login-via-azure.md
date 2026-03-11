
# Azure login (using OIDC)

[ArgoCD Microsoft OIDC docs](https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/microsoft/)

## Create the application from App Registrations

Values required to create it:

- Supported account types: Accounts in this organizational directory only
- Redirect URI (optional): `https://<my-argo-cd-url>/auth/callback`

> Relevant values obtained: Application (client) ID

Post-configuration (inside the created application):

- In **Branding and properties**: set a logo
- In **Authentication**: "Add a platform" > "Mobile and desktop applications",
  and add `http://localhost:8085/auth/callback`
- In **Certificates & secrets** > **Client secrets**: add a secret with an
  expiry date

> Relevant values obtained: Secret Value (shown only once)

- In **API Permissions**: add `User.Read` for Microsoft Graph
- In **Token configuration**: add a "group claim" with
  "Groups assigned to the application" (4th option)

## Associate a group with the application from Enterprise Applications

Search for the application and from **Users and groups** add the desired
users or groups.

> Relevant values obtained: The identifier of the added groups or users

## ArgoCD configuration

Data must be added to the following objects:

- In the `argocd-cm` ConfigMap: the `oidc.config` field
- In the `argocd-secret` Secret: the `oidc.azure.clientSecret` field
- In the `argocd-rbac-cm` ConfigMap: the RBAC configuration for those users
  or groups
