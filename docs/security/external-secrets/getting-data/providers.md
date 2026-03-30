# Providers comparison

Every provider uses different terminology for the same concepts and the externalsecrets uses the spec differently

## Secret store

The SecretStore has no built-in filter to restrict which secrets can be accessed.
The only supported restriction mechanism is **IAM** — by scoping the IAM role
attached to the SecretStore to specific secret ARN patterns. ESO itself has no
equivalent filtering at the store level.

## Secrets Container

In general, we have a place where key/value pairs are stored. We will call it **Secrets Container**
Then we ask for the key inside ot if and we get the value.

| Provider            | Secrets container |
|---------------------|-------------------|
| Azure Key Vault     | Key Vault         |
| AWS Secrets Manager | Secret            |
| Infisical           |                   |

## Data

Depending of the provider we must specify one or more data fields to ask for the value we want (KEY)

- In Azure Key Vault select the key via remoteRef/key only
- In AWS Secrets Manager we select the key via remoteRef/key and remoteRef/property **KEY**

| Provider            | remoteRef key         | remoteRef property | version |
|---------------------|-----------------------|--------------------|---------|
| Azure Key Vault     | secret/**KEY**        | Not used           |         |
| AWS Secrets Manager | **Secrets container** | **KEY**            |         |
| Infisical           |                       |                    |         |

## DataFrom

### extract

Fetches one specific secret by name and expands its JSON key/value pairs as
individual keys in the Kubernetes Secret.

| Provider            | key                     | property | version |
|---------------------|-------------------------|----------|---------|
| Azure Key Vault     |                         |          |         |
| AWS Secrets Manager | Secret name (full path) | Not used |         |
| Infisical           |                         |          |         |

- AWS Secrets Manager: `key` is the full name of the AWS secret (e.g. `myapp/production`).
  All JSON key/value pairs inside it become individual keys in the Kubernetes Secret.

```yaml
dataFrom:
  - extract:
      key: myapp/production
# result: each JSON key becomes an individual key in the Kubernetes Secret
```

### find

Discovers secrets dynamically by searching their **name** or **tags** in the provider.
Each matched secret becomes a single key in the Kubernetes Secret (name with `/` → `_`),
with its full JSON object as the value — keys are NOT expanded.

| Provider            | name.regexp | path          | tags |
|---------------------|-------------|---------------|------|
| Azure Key Vault     |             |               |      |
| AWS Secrets Manager | Supported   | Not supported |      |
| Infisical           |             |               |      |

- AWS Secrets Manager: has no native path hierarchy. `find.name.regexp` matches against
  the full AWS secret name. Each match produces one k8s key named after the secret
  (e.g. secret `myapp/production` → key `myapp_production`), with the raw JSON as value.
  Use `name.regexp` as a path prefix filter (e.g. `"^myapp/.*"`).

> Use `extract` when you have one secret with multiple key/value pairs and want them
> expanded. Use `find` when you have multiple separate secrets to discover dynamically.

### Filtering keys within a secret (AWS)

ESO has no built-in filter for key names within a secret. `extract` always returns
all keys. To get only a subset, use one of these approaches:

**Option 1 — `spec.data` with explicit `remoteRef.property`** (precise, verbose):

```yaml
spec:
  data:
    - secretKey: DB_USER
      remoteRef:
        key: myapp/production
        property: DB_USER
    - secretKey: DB_PASSWORD
      remoteRef:
        key: myapp/production
        property: DB_PASSWORD
```

**Option 2 — `extract` + `spec.target.template`** (extract all, expose only what you need):

```yaml
spec:
  dataFrom:
    - extract:
        key: myapp/production
  target:
    template:
      data:
        DB_USER: "{{ .DB_USER }}"
        DB_PASSWORD: "{{ .DB_PASSWORD }}"
```

Option 1 is simpler for a small number of keys. Option 2 is useful when you also
need to transform or combine values.

## Links

- AWS Secrets Manager

<https://external-secrets.io/latest/provider/aws-secrets-manager/>

- Azure Key Vault

<https://external-secrets.io/latest/provider/azure-key-vault/>

- Infisical

<https://external-secrets.io/latest/provider/infisical/>
