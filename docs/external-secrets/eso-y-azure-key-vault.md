# External secrets operator y azure

## Tipos de objetos soportados

External secrets operator es capaz de gestionar los 3 tipos de objectos: secrets, certificates y keys (jwk)

```yaml
  data:
    - secretKey: database-username
        remoteRef:
        key: database-username # secret sin prefijo (valor por defecto) 
    - secretKey: database-password
        remoteRef:
        key: secret/database-password # secret con prefijo
    - secretKey: db-client-cert
        remoteRef:
        key: cert/db-client-cert # certificate con prefijo
    - secretKey: encryption-pubkey
        remoteRef:
        key: key/encryption-pubkey # key con prefijo
```

## Autentication soportada

External secrets operator permite 3 tipos de autenticaciones que se definen en .spec.provider.azurekv.authType del SecretStore o ClusterSecretStore:

- ManagedIdentity  
Usando aad-pod-identity, que fue deprecado en 2002 y reemplazado por Azure Workload Identity

- WorkloadIdentity  
Reemplaza a aad-pod-identity y requiere configurar "serviceAccountRef".
Se puede usar mediante

- ServicePrincipal  
Autenticacion mediante ClientID y ClientSecret o ClientCertificate en formato PEM y require configurar "tenantId" y "authSecretRef"

> En todos los casos hay que configurar "environmentType" y "vaultUrl"

## Links

- External Secrets Operator y AzureAD  
<https://external-secrets.io/latest/provider/azure-key-vault/>

- Api Spec  
<https://external-secrets.io/latest/api/spec/#external-secrets.io/v1beta1.AzureKVProvider>

- AAD Pod identity (deprecated)  
<https://azure.github.io/aad-pod-identity/docs/>

- Azure AD Workfload Identity  
<https://azure.github.io/azure-workload-identity/docs/>

- Azure AD Workfload Identity Federation
<https://docs.microsoft.com/en-us/azure/active-directory/develop/workload-identity-federation>
