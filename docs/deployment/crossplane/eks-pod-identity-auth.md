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

**EKS Pod Identity operates at the pod level, not the namespace level.** The full
flow is:

1. The EKS Pod Identity Agent (DaemonSet) detects the Pod Identity Association
   for the `provider-aws` ServiceAccount in `crossplane-system`.
2. It injects AWS credential environment variables directly into the provider pod:
   `AWS_CONTAINER_CREDENTIALS_FULL_URI` and `AWS_CONTAINER_AUTHORIZATION_TOKEN_FILE`.
3. The AWS SDK inside the provider pod reads these variables and automatically
   fetches short-lived credentials from the EKS auth endpoint — no static keys needed.
4. The provider pod uses those credentials for **every** AWS API call it makes,
   regardless of which namespace the managed resource being reconciled lives in.

The provider pod has a ClusterRole that allows it to watch and reconcile managed
resources across all namespaces. AWS authentication is therefore entirely a concern
of the pod in `crossplane-system`, not of the namespaces where resources are deployed.

### Role of ProviderConfig

`ProviderConfig` is a **configuration pointer**, not a credential store. It carries
no IAM role ARN, access key, or identity information. The only thing
`source: PodIdentity` declares is: *"when this ProviderConfig is referenced, use
the ambient AWS credentials already injected into the provider pod."*

In Crossplane v2, the provider controller looks up the `ProviderConfig` named by
`providerConfigRef.name` in the **same namespace** as the managed resource being
reconciled. A `ProviderConfig` living in `crossplane-system` is invisible to managed
resources in any other namespace — hence the need to copy it.

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

The `ProviderConfig` in `my-namespace` and the one in `crossplane-system` are
independent objects that happen to carry the same instruction. They both point to the
same authentication mechanism: the pod's ambient credentials. Updating or deleting
one does not affect the other.

## References

- [provider-upjet-aws AUTHENTICATION.md](https://github.com/crossplane-contrib/provider-upjet-aws/blob/main/AUTHENTICATION.md)
- [Upbound provider authentication](https://docs.upbound.io/providers/provider-aws/authentication/)
- [EKS Pod Identity Agent](../../kubernetes/distributions/eks/eks-pod-identity-agent.md)
