# Multi-Account EKS Deployment

This guide assumes a management cluster with CAPA already running
(see [Management Cluster](10-management-cluster.md)). It covers provisioning EKS clusters across
multiple AWS accounts using a dedicated **management account** where the CAPI management cluster
and CAPA controller run, and target accounts where EKS workload clusters are provisioned.

## Account Structure

```txt
Management Account       Staging Account       Live Account
──────────────────       ───────────────       ────────────
CAPI management          CloudFormation        CloudFormation
cluster + CAPA           stack with trust      stack with trust
controller               policy                policy
     │                        ▲                      ▲
     └────── sts:AssumeRole ──┘                      │
     └────── sts:AssumeRole ────────────────────────┘
```

The CAPA controller in the management account assumes roles in each target account via
`sts:AssumeRole`. This avoids embedding static credentials per account and follows least-privilege
principles.

## CloudFormation Stack per Account

Run `clusterawsadm` in each account with different configurations.

### Management account

Standard stack with an extra inline policy to allow cross-account role assumption:

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  bootstrapUser:
    enable: true
  clusterAPIControllers:
    extraStatements:
      - Action:
          - "sts:AssumeRole"
        Effect: "Allow"
        Resource:
          - "arn:aws:iam::*:role/controllers.cluster-api-provider-aws.sigs.k8s.io"
```

```shell
clusterawsadm bootstrap iam create-cloudformation-stack --config bootstrap-management.yaml
```

### Target accounts (staging, live)

Each target account needs a stack with a trust policy that allows the management account
controller role to assume into it:

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  clusterAPIControllers:
    disabled: false
    trustStatements:
      - Action:
          - "sts:AssumeRole"
        Effect: "Allow"
        Principal:
          AWS:
            - "arn:aws:iam::<management-account-id>:role/controllers.cluster-api-provider-aws.sigs.k8s.io"
  eks:
    managedMachinePool:
      disable: false
    iamRoleCreation: true
```

```shell
# Run once per target account authenticated against that account
clusterawsadm bootstrap iam create-cloudformation-stack --config bootstrap-target.yaml
```

## Identity Resources in the Management Cluster

For each target account, create an `AWSClusterRoleIdentity` that references the role ARN in
that account and chains from the default controller identity. Repeat for each account:

```yaml
apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
kind: AWSClusterRoleIdentity
metadata:
  name: staging-identity  # repeat as live-identity for live account
spec:
  roleARN: arn:aws:iam::<staging-account-id>:role/controllers.cluster-api-provider-aws.sigs.k8s.io
  sourceIdentityRef:
    kind: AWSClusterControllerIdentity
    name: default
  allowedNamespaces:
    list:
      - staging  # restrict to the staging namespace only
```

> `allowedNamespaces` restricts which namespaces can use the identity, preventing accidental
> cross-environment provisioning.

## Reference the Identity in AWSManagedControlPlane

Each EKS cluster must reference its corresponding identity:

```yaml
apiVersion: controlplane.cluster.x-k8s.io/v1beta2
kind: AWSManagedControlPlane
metadata:
  name: my-eks-cluster
  namespace: staging
spec:
  identityRef:
    kind: AWSClusterRoleIdentity
    name: staging-identity
  region: eu-west-1
  version: "1.31"
```

## Alternative: Separate Provider per Account (CAPI Operator)

The CAPI Operator also supports deploying one `InfrastructureProvider` per account in its own
namespace with static credentials and a `watch-filter` for isolation. The configSecret must
include both `AWS_B64ENCODED_CREDENTIALS` and `AWS_REGION`. Prefer the `AWSClusterRoleIdentity`
approach for production as it avoids long-lived static credentials.

```yaml
apiVersion: operator.cluster.x-k8s.io/v1alpha2
kind: InfrastructureProvider
metadata:
  name: aws-staging
  namespace: capa-staging
spec:
  version: v2.3.0
  configSecret:
    name: staging-creds  # must contain AWS_B64ENCODED_CREDENTIALS and AWS_REGION
  manager:
    additionalArgs:
      watch-filter: "env=staging"
```

## Links

- Multi-tenancy: <https://cluster-api-aws.sigs.k8s.io/topics/multitenancy>
- Full multi-tenancy EKS: <https://cluster-api-aws.sigs.k8s.io/topics/full-multitenancy-implementation>
- clusterawsadm prerequisites: <https://cluster-api-aws.sigs.k8s.io/topics/using-clusterawsadm-to-fulfill-prerequisites>
- [Management Cluster](10-management-cluster.md)
- [AWSManagedControlPlane](21-awsmanagedcontrolplane.md)
