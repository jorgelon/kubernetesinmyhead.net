# Management Cluster

We assume the CAPI Operator and CoreProvider are already installed. CAPA requires
credentials from startup: it is a continuous reconciliation loop, and the moment an
`AWSCluster` or `AWSManagedControlPlane` is created, the controller calls AWS APIs
immediately. These credentials also act as the **default identity** used when an
`AWSCluster` has no `identityRef`.

## Step 1: Create IAM Resources with clusterawsadm

Use the `clusterawsadm` binary with an `AWSIAMConfiguration` file. This creates a
**CloudFormation stack** containing IAM roles, policies, and instance profiles.

### Authentication

Authenticate with an administrative user via environment variables:

- `AWS_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN` (if using MFA)

### AWSIAMConfiguration

Key settings:

- **Name and tags** for the CloudFormation stack
- **Region** (if not provided via environment variable or CLI)
- **`spec.bootstrapUser`** — dedicated IAM user/group, avoids personal credentials

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  bootstrapUser:
    enable: true
    userName: capa-manager-user
    groupName: capa-manager-group
```

> Default: `bootstrapper.cluster-api-provider-aws.sigs.k8s.io`. Prefix/suffix via
> `spec.namePrefix` / `spec.nameSuffix`. EKS options: see [Features](11-features.md).
> CRD docs: <https://cluster-api-aws.sigs.k8s.io/crd/>

### Create the CloudFormation Stack

```shell
clusterawsadm bootstrap iam create-cloudformation-stack --config bootstrap.yaml
```

Creates the bootstrap user/group, instance profiles (control-plane, controllers, nodes),
managed policies, and other roles.

## Step 2: Controller Credentials

The method depends on where the management cluster runs.

### Outside AWS (Static Credentials)

```shell
export AWS_PROFILE=capa-bootstrap
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile)
kubectl create secret generic aws-bootstrap \
  --from-literal=AWS_B64ENCODED_CREDENTIALS="${AWS_B64ENCODED_CREDENTIALS}" \
  --from-literal=AWS_REGION="eu-west-1" \
  --namespace capa-system
```

> Relies on static access keys — rotate regularly. Prefer an AWS-hosted management cluster.

### On EC2 (Instance Profile / IMDS)

When nodes run on EC2 with an instance profile, CAPA picks up credentials from IMDS
automatically. The profile must include the `controllers.cluster-api-provider-aws.sigs.k8s.io`
role. Create the `aws-bootstrap` secret with `AWS_B64ENCODED_CREDENTIALS: ""` — the SDK
falls through to IMDS automatically.

### On EKS (IRSA) — Recommended

The controller pod assumes an IAM role via the EKS pod identity webhook without static
credentials.

1. Create an IAM role with CAPA permissions and a trust policy for the CAPA service account:

   ```json
   {
     "Principal": {
       "Federated": "arn:aws:iam::<account>:oidc-provider/<eks-oidc-provider>"
     },
     "Action": "sts:AssumeRoleWithWebIdentity",
     "Condition": {
       "StringEquals": {
         "<oidc>:sub": "system:serviceaccount:capa-system:capa-controller-manager"
       }
     }
   }
   ```

2. Create the `aws-bootstrap` secret with `AWS_B64ENCODED_CREDENTIALS: ""`.

> Credentials are short-lived and automatically rotated by EKS. Preferred for production.

### Credential Resolution Order

CAPA follows the standard AWS SDK chain:

1. `AWS_B64ENCODED_CREDENTIALS` secret
2. EC2 IMDS (instance profile)
3. IRSA / EKS Pod Identity

If the secret is present but empty, the SDK falls through automatically.

## Step 3: Deploy the InfrastructureProvider

This step applies regardless of the credential method — all scenarios require `aws-bootstrap`.

```yaml
apiVersion: operator.cluster.x-k8s.io/v1alpha2
kind: InfrastructureProvider
metadata:
  name: aws
  namespace: capa-system
spec:
  version: v2.10.0
  configSecret:
    name: aws-bootstrap
  manager:
    featureGates:
      MachinePool: true
```

See [Features](11-features.md) for optional feature gates.

### After Deployment: Annotate the Service Account (IRSA only)

Once deployed, the `capa-controller-manager` ServiceAccount exists. Annotate it with the
role ARN so IRSA takes effect:

```shell
kubectl annotate serviceaccount capa-controller-manager \
  "eks.amazonaws.com/role-arn=arn:aws:iam::<account-id>:role/capa-controller-role" \
  -n capa-system
```

## Links

- <https://cluster-api-aws.sigs.k8s.io/topics/using-clusterawsadm-to-fulfill-prerequisites>
- <https://cluster-api-aws.sigs.k8s.io/topics/using-iam-roles-in-mgmt-cluster.html>
- <https://cluster-api-aws.sigs.k8s.io/topics/specify-management-iam-role.html>
- [Features](11-features.md)
- [Multi-Account](13-multi-account.md)
- [AWSManagedControlPlane](21-awsmanagedcontrolplane.md)
