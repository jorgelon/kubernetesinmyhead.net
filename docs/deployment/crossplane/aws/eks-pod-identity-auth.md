# Upbound AWS Provider Authentication with EKS Pod Identity

Authenticate Crossplane's Upbound AWS provider pods against AWS using EKS Pod
Identity Agent — no static credentials required.

## Prerequisites

- EKS cluster with the Pod Identity Agent addon installed
- Crossplane installed in the cluster
- Upbound AWS provider family packages to install

## IAM Role

Create an IAM role (e.g. `crossplane-provider-aws`) with the following trust policy:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowEksAuthToAssumeRoleForPodIdentity",
            "Effect": "Allow",
            "Principal": {
                "Service": "pods.eks.amazonaws.com"
            },
            "Action": [
                "sts:AssumeRole",
                "sts:TagSession"
            ]
        }
    ]
}
```

Attach a permission policy scoped to the AWS actions your provider family packages
require. Example for S3 and EC2:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "ec2:*"
            ],
            "Resource": "*"
        }
    ]
}
```

> Scope permissions to only the actions and resources your providers actually manage.

## EKS Pod Identity Association

In the EKS cluster's **Access** tab, create a Pod Identity association:

- **IAM role**: `crossplane-provider-aws`
- **Namespace**: `crossplane-system`
- **Service account**: `provider-aws` (must match `serviceAccountTemplate.metadata.name`
  below)

## Crossplane Configuration

Apply the following three resources:

```yaml
apiVersion: pkg.crossplane.io/v1beta1
kind: DeploymentRuntimeConfig
metadata:
  name: provider-aws-runtime-config
spec:
  serviceAccountTemplate:
    metadata:
      name: provider-aws
---
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-aws-s3
spec:
  package: xpkg.upbound.io/upbound/provider-aws-s3:v2.4.0
  runtimeConfigRef:
    name: provider-aws-runtime-config
---
apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: PodIdentity
```

> For multiple provider family packages (e.g. `provider-aws-ec2`, `provider-aws-rds`),
> each `Provider` resource must reference the same `runtimeConfigRef`.

## Verification

Check provider health with `kubectl get providers && kubectl get providerconfig`.
Verify end-to-end by creating a managed resource and confirming it reconciles
in AWS — no static credentials should be present in the cluster.

## Managed Resources in Other Namespaces

In Crossplane v2, managed resources and `ProviderConfig` are **namespace-scoped**
(they were cluster-scoped in v1.x). For the full v1-to-v2 migration context, see
[Upgrading Crossplane from v1 to v2](../upgrading-to-v2.md).

### How Authentication Works

**EKS Pod Identity operates at the pod level, not the namespace level.** The Pod
Identity Agent injects short-lived AWS credentials into the provider pod via
environment variables (`AWS_CONTAINER_CREDENTIALS_FULL_URI`,
`AWS_CONTAINER_AUTHORIZATION_TOKEN_FILE`). The provider pod holds a ClusterRole
allowing it to reconcile managed resources across all namespaces — AWS auth is
entirely a concern of the pod in `crossplane-system`.

`ProviderConfig` with `source: PodIdentity` is a configuration pointer, not a
credential store. In Crossplane v2, the controller looks up the `ProviderConfig`
in the **same namespace** as the managed resource — a `ProviderConfig` in
`crossplane-system` is invisible to resources in other namespaces, hence the need
to copy it.

### Deploying to Another Namespace

Copy the `ProviderConfig` into every namespace that will contain managed resources.
No additional IAM roles, Pod Identity Associations, ServiceAccounts, or RBAC are
required — the actual credential exchange still happens entirely within the provider
pod in `crossplane-system`:

```yaml
apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
  namespace: my-namespace
spec:
  credentials:
    source: PodIdentity
```

## References

- [provider-upjet-aws AUTHENTICATION.md](https://github.com/crossplane-contrib/provider-upjet-aws/blob/main/AUTHENTICATION.md)
- [Upbound provider authentication](https://docs.upbound.io/providers/provider-aws/authentication/)
- [EKS Pod Identity Agent](../../kubernetes/distributions/eks/eks-pod-identity-agent.md)
