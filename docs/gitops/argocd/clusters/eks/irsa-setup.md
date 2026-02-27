# EKS + ArgoCD: IAM Authentication Setup

Two options when ArgoCD and the target EKS cluster run in AWS: **IRSA** (requires OIDC provider, service
account annotation) and **Pod Identity** (requires EKS Pod Identity Agent add-on, no annotation needed).
The cluster Secret format and target cluster role are identical for both — only the management role trust
policy and ArgoCD service account setup differ.

## Scenario 1: Same Account

### ArgoCD management IAM role

Create a role that both `argocd-application-controller` and `argocd-server` will assume. Trust policy:

```json
{
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Federated": "arn:aws:iam::<ARGOCD_ACCOUNT_ID>:oidc-provider/oidc.eks.<REGION>.amazonaws.com/id/<OIDC_ID>"
    },
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringEquals": {
        "oidc.eks.<REGION>.amazonaws.com/id/<OIDC_ID>:sub": [
          "system:serviceaccount:argocd:argocd-application-controller",
          "system:serviceaccount:argocd:argocd-server"
        ]
      }
    }
  }]
}
```

Permissions policy: allow `sts:AssumeRole` on `*` (or scoped to specific cluster role ARNs).

Annotate both ArgoCD service accounts with the management role ARN:

```yaml
eks.amazonaws.com/role-arn: arn:aws:iam::<ARGOCD_ACCOUNT_ID>:role/<ARGOCD_MANAGEMENT_ROLE>
```

### Target cluster IAM role

Create a role in the target cluster's account. Trust policy — allow the management role to assume it:

```json
{
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "AWS": "arn:aws:iam::<ARGOCD_ACCOUNT_ID>:role/<ARGOCD_MANAGEMENT_ROLE>"
    },
    "Action": "sts:AssumeRole"
  }]
}
```

Grant cluster access: add the role to `aws-auth` (ConfigMap mode) or create an access entry with
`AmazonEKSClusterAdminPolicy` (EKS API mode).

### Cluster Secret

```yaml
apiVersion: v1
kind: Secret
metadata:
  labels:
    argocd.argoproj.io/secret-type: cluster
  name: <CLUSTER-NAME>
type: Opaque
stringData:
  name: "arn:aws:eks:<REGION>:<TARGET_ACCOUNT_ID>:cluster/<CLUSTER_NAME>"
  server: "https://<CLUSTER_ID>.gr7.<REGION>.eks.amazonaws.com"
  config: |
    {
      "awsAuthConfig": {
        "clusterName": "<CLUSTER_NAME>",
        "roleARN": "arn:aws:iam::<TARGET_ACCOUNT_ID>:role/<TARGET_CLUSTER_ROLE>"
      },
      "tlsClientConfig": { "insecure": false, "caData": "<BASE64_CA_DATA>" }
    }
```

Retrieve endpoint and CA data:

```shell
aws eks describe-cluster --name <CLUSTER_NAME> --query "cluster.endpoint" --output text
aws eks describe-cluster --name <CLUSTER_NAME> --query "cluster.certificateAuthority.data" --output text
```

## Scenario 2: Cross-Account

Identical to Scenario 1. The management role trust policy and cluster Secret format are unchanged —
only the account IDs differ. The `roleARN` in the cluster Secret config points to a role in a
different AWS account.

## Alternative: EKS Pod Identity

Pod Identity replaces IRSA on the ArgoCD cluster side. The target cluster role and cluster Secret are
unchanged. Requires the **EKS Pod Identity Agent** add-on installed on the ArgoCD cluster.

| Aspect                     | IRSA                    | Pod Identity                     |
|----------------------------|-------------------------|----------------------------------|
| Trust policy principal     | OIDC federated identity | `pods.eks.amazonaws.com` service |
| Service account annotation | Required                | Not needed                       |
| OIDC provider setup        | Required                | Not required                     |
| ArgoCD must run on EKS     | No                      | Yes                              |

### Management role trust policy

Replace the OIDC-based trust with:

```json
{
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "Service": "pods.eks.amazonaws.com" },
    "Action": ["sts:AssumeRole", "sts:TagSession"]
  }]
}
```

### Pod identity associations

No service account annotation. Create an association for each ArgoCD service account instead:

```shell
aws eks create-pod-identity-association \
  --cluster-name <ARGOCD_CLUSTER_NAME> \
  --namespace argocd \
  --service-account argocd-application-controller \
  --role-arn arn:aws:iam::<ARGOCD_ACCOUNT_ID>:role/<ARGOCD_MANAGEMENT_ROLE>

aws eks create-pod-identity-association \
  --cluster-name <ARGOCD_CLUSTER_NAME> \
  --namespace argocd \
  --service-account argocd-server \
  --role-arn arn:aws:iam::<ARGOCD_ACCOUNT_ID>:role/<ARGOCD_MANAGEMENT_ROLE>
```
