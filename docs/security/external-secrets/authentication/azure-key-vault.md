# Azure Key Vault

## Authentication (authType)

Defining the (Cluster)SecretStore, external Secrets Operator supports 3 authentication types defined in .spec.provider.azurekv.authType:

In all cases you must configure "environmentType" and "vaultUrl", but there are some differences in setup between the authTypes

### ServicePrincipal

This Azure Service Principal is the default authType and it can be used with:

- ClientID and ClientSecret
- ClientCertificate in PEM format

If we want to use this authentication type, we also need to configure:

- authSecretRef: the secret that stores that credential

- tenantId: the Azure Tenant ID

```yaml
apiVersion: external-secrets.io/v1
kind: SecretStore
metadata:
  name: azure-backend
spec:
  provider:
    azurekv:
      authType: ServicePrincipal
```

### ManagedIdentity (not recommended)

Uses aad-pod-identity, which was deprecated in 2022 and replaced by Azure Workload Identity

### WorkloadIdentity

Replaces aad-pod-identity and requires configuring "serviceAccountRef".

Optional settings:

- tenantId
- authSecretRef

### Settings Table

| Setting               | ServicePrincipal | ManagedIdentity | WorkloadIdentity |
|-----------------------|------------------|-----------------|------------------|
| **authType**          | ✅ Required       | ✅ Required      | ✅ Required       |
| **vaultUrl**          | ✅ Required       | ✅ Required      | ✅ Required       |
| **environmentType**   | ✅ Required       | ✅ Required      | ✅ Required       |
| **tenantId**          | ✅ Required       | ❌ Not used      | ⚪ Optional       |
| **authSecretRef**     | ✅ Required       | ❌ Not used      | ⚪ Optional       |
| **serviceAccountRef** | ❌ Not used       | ❌ Not used      | ✅ Required       |

## Supported Object Types

External Secrets Operator can manage all 3 types of objects: secrets, certificates, and keys (jwk)

```yaml
  data:
    - secretKey: database-username
        remoteRef:
            key: database-username # secret without prefix (default value)
    - secretKey: database-password
        remoteRef:
            key: secret/database-password # secret with prefix
    - secretKey: db-client-cert
        remoteRef:
            key: cert/db-client-cert # certificate with prefix
    - secretKey: encryption-pubkey
        remoteRef:
            key: key/encryption-pubkey # key with prefix
```

## Links

- External Secrets Operator and AzureAD

<https://external-secrets.io/latest/provider/azure-key-vault/>

- Api Spec

<https://external-secrets.io/latest/api/spec/#external-secrets.io/v1beta1.AzureKVProvider>

- AAD Pod identity (deprecated)

<https://azure.github.io/aad-pod-identity/docs/>

- Azure AD Workload Identity

<https://azure.github.io/azure-workload-identity/docs/>

- Azure AD Workload Identity Federation

<https://docs.microsoft.com/en-us/azure/active-directory/develop/workload-identity-federation>
