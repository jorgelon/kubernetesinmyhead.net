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

Check provider health:

```bash
kubectl get providers
kubectl get providerconfig
```

Verify end-to-end authentication by creating a managed resource and confirming it
reconciles successfully in AWS — no static credentials should be present in the
cluster.

## Managed Resources in Other Namespaces

In Crossplane v2, managed resources and `ProviderConfig` are **namespace-scoped**
(they were cluster-scoped in v1.x).

### How Authentication Works

Authentication is always performed by the **provider pod running in
`crossplane-system`**, regardless of which namespace the managed resource lives in.
The provider pod watches all namespaces via ClusterRole. When reconciling a resource,
it fetches the `ProviderConfig` from the same namespace as the resource. For
`source: PodIdentity`, the provider uses its own pod's ambient AWS credentials —
the namespace of the resource or `ProviderConfig` does not affect authentication.

### Deploying to Another Namespace

Copy the `ProviderConfig` into the target namespace. No additional IAM roles, EKS
Pod Identity Associations, ServiceAccounts, or RBAC are required:

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
