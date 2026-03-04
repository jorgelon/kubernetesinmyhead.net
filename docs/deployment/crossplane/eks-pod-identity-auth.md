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
- **Service account**: `provider-aws` (must match `serviceAccountTemplate.metadata.name` below)

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

Verify end-to-end authentication by creating an S3 Bucket managed resource:

```yaml
apiVersion: s3.aws.upbound.io/v1beta1
kind: Bucket
metadata:
  name: test-pod-identity-bucket
spec:
  forProvider:
    region: eu-west-1
  providerConfigRef:
    name: default
```

If the Pod Identity association is correct, the bucket will be created in AWS
without any static credentials in the cluster.

## References

- [provider-upjet-aws AUTHENTICATION.md](https://github.com/crossplane-contrib/provider-upjet-aws/blob/main/AUTHENTICATION.md)
- [Upbound provider authentication](https://docs.upbound.io/providers/provider-aws/authentication/)
- [EKS Pod Identity Agent](../../kubernetes/distributions/eks/eks-pod-identity-agent.md)
