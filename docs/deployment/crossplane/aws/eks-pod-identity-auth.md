# AWS Provider Authentication with EKS Pod Identity

This document explains how to authenticate one or more AWS Crossplane providers deployed in an EKS cluster against the same account.

- We assume crossplane is installed in an EKS cluster with the **Pod Identity Agent addon** and in the crossplane-system namespace
- The role will be **crossplane-provider-aws**
- We will use the **provider-aws service account** to authenticate
- We will use namespace managed resources

## IAM Role

Create a role for crossplane called **crossplane-provider-aws**, for example.

- With the [following trust policy](policies/pia-trust-relationships.json)
- With the desired policies depending of what permissions we want to give to crossplane

Some examples you can adapt and review

| Policy name                                                          | What manages                           |
|----------------------------------------------------------------------|----------------------------------------|
| [crossplane-eks](policies/crossplane-eks.json)                       | Pod Identity Associations              |
| [crossplane-iam](policies/crossplane-iam.json)                       | Iam policies, roles and attachments    |
| [crossplane-ec2](policies/crossplane-ec2.json)                       | Security Groups and rules              |
| [crossplane-route53](policies/crossplane-route53.json)               | Route53 Zones                          |
| [crossplane-efs](policies/crossplane-efs.json)                       | Filesystems, Targets and Access Points |
| [crossplane-s3](policies/crossplane-s3.json)                         | S3 Bucket creation, deletion and read-only configuration |
| [crossplane-secretsmanager](policies/crossplane-secretsmanager.json) | Secrets Manager secrets                |

## Add the Pod identity agent

Go to the eks cluster -  Access Tab - Pod Identity associations section and add a pod identity association

```txt
IAM role: crossplane-provider-aws
Kubernetes namespace: crossplane-system
Kubernetes service account: the service account specified in the DeploymentRuntimeConfig
```

## Crossplane Configuration

The following **ProviderConfig** in the crossplane-system declares pod identity authentication

```yaml
apiVersion: aws.m.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: podidentity
  namespace: crossplane-system
spec:
  credentials:
    source: PodIdentity
```

Lets create a DeploymentRuntimeConfig that will use the provider-aws service account to authenticate. It must include

```yaml
apiVersion: pkg.crossplane.io/v1beta1
kind: DeploymentRuntimeConfig
metadata:
  name: provider-aws
  namespace: crossplane-system
spec:
  serviceAccountTemplate:
    metadata:
      name: provider-aws
```

Finally ensure your AWS crossplane providers include that DeploymentRuntimeConfig. For example:

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: upbound-provider-aws-ec2
  namespace: crossplane-system
spec:
  package: xpkg.crossplane.io/crossplane-contrib/provider-aws-ec2:v2.5.0
  runtimeConfigRef:
    name: provider-aws
```

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
apiVersion: pkg.crossplane.io/v1beta1
kind: DeploymentRuntimeConfig
metadata:
  name: provider-aws
  namespace: mynamespace
spec:
  serviceAccountTemplate:
    metadata:
      name: provider-aws
```

## References

- [provider-upjet-aws AUTHENTICATION.md](https://github.com/crossplane-contrib/provider-upjet-aws/blob/main/AUTHENTICATION.md)
- [Upbound provider authentication](https://docs.upbound.io/providers/provider-aws/authentication/)
- [EKS Pod Identity Agent](../../kubernetes/distributions/eks/eks-pod-identity-agent.md)
