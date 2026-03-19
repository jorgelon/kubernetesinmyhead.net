# ProviderConfig

A `ProviderConfig` supplies credentials and configuration that a Crossplane
provider uses to authenticate with an external API. Every managed resource
references a `ProviderConfig` via `spec.providerConfigRef`.

The API group and version are provider-specific (e.g.
`aws.m.upbound.io/v1beta1` for the official AWS family).

## ProviderConfig vs ClusterProviderConfig

Crossplane v2 supports two scopes:

| Kind                    | Scope     | Applies to                                       |
|-------------------------|-----------|--------------------------------------------------|
| `ProviderConfig`        | Namespace | Managed resources in the **same namespace** only |
| `ClusterProviderConfig` | Cluster   | Managed resources in **any namespace**           |

When `spec.providerConfigRef` is omitted from a managed resource, Crossplane
defaults to a `ClusterProviderConfig` named `default`.

## Referencing a ProviderConfig

Both `name` and `kind` must be specified when referencing any ProviderConfig:

```yaml
spec:
  providerConfigRef:
    name: my-config
    kind: ProviderConfig          # namespace-scoped
```

```yaml
spec:
  providerConfigRef:
    name: my-cluster-config
    kind: ClusterProviderConfig   # cluster-wide
```

## Credential sources

### Secret

Store credentials in a Kubernetes `Secret` and reference it:

```yaml
apiVersion: aws.m.upbound.io/v1beta1
kind: ClusterProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: aws-creds
      key: creds
```

The secret value is provider-specific. For the AWS provider the `creds` key
holds an INI-format credentials file:

```ini
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

### IRSA / Pod Identity (AWS)

When using IAM Roles for Service Accounts or EKS Pod Identity, no secret is
needed. Set `source: IRSA` or `source: WebIdentity` and annotate the provider's
`ServiceAccount` via a
[DeploymentRuntimeConfig](./deploymentruntimeconfig.md):

```yaml
apiVersion: aws.m.upbound.io/v1beta1
kind: ClusterProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: IRSA
```

## Provider families

A provider family (e.g. `provider-family-aws`) installs a shared
`ProviderConfig` CRD. Sub-providers (`provider-aws-s3`, `provider-aws-ec2`, ...)
all consume the same `ProviderConfig` kind from the family, so you define
credentials once and reference them from every sub-provider's managed resources.

## Key fields reference

| Field                                  | Description                                                        |
|----------------------------------------|--------------------------------------------------------------------|
| `spec.credentials.source`              | Credential source: `Secret`, `IRSA`, `WebIdentity`, `Upbound`, ... |
| `spec.credentials.secretRef`           | Coordinates of the `Secret` when `source: Secret`                  |
| `spec.credentials.secretRef.namespace` | Namespace of the secret                                            |
| `spec.credentials.secretRef.name`      | Name of the secret                                                 |
| `spec.credentials.secretRef.key`       | Key inside the secret                                              |
