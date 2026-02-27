# Add an EKS Cluster to ArgoCD

## Overview

Two methods to register an EKS cluster:

- **CLI** (`argocd cluster add`): bootstraps a cluster Secret automatically. Useful for the initial setup.
- **Declarative Secret**: a `v1/Secret` with label `argocd.argoproj.io/secret-type: cluster`.
  Preferred for GitOps.

| Scenario | ArgoCD location | Auth method |
|---|---|---|
| Same account | EKS in the same AWS account | IRSA or Pod Identity |
| Cross-account | EKS in a different AWS account | IRSA or Pod Identity (cross-account assumption) |
| Outside AWS | On-prem / other cloud | Bearer token or AWS profile |

## Prerequisites

**EKS authentication modes** — two ways to map IAM identities to Kubernetes RBAC:

- **ConfigMap** (`aws-auth`): legacy mode, edit `kube-system/aws-auth`.
- **EKS API** (access entries): newer mode, must be enabled on the cluster. The IAM principal that created
  the cluster gets an `AmazonEKSClusterAdminPolicy` access entry by default.

**OIDC provider** — required for IRSA only. Each EKS cluster has an OIDC URL (EKS console →
**Overview → Details**). Verify it is registered in **IAM → Identity Providers**. If missing, create
it: provider type `OpenID Connect`, audience `sts.amazonaws.com`.

**IRSA** (IAM Roles for Service Accounts) — lets Kubernetes service accounts assume IAM roles via OIDC
federation. Requires OIDC provider setup and a service account annotation.

**Pod Identity** — newer alternative to IRSA. Uses the EKS Pod Identity Agent add-on (a DaemonSet)
instead of OIDC federation. No OIDC provider setup and no service account annotation needed. Requires
ArgoCD to run on EKS.

IAM roles carry temporary credentials and are assumable by any authorized principal. An ARN uniquely
identifies every AWS resource.

## Scenarios 1 & 2: Same Account and Cross-Account

See [irsa-setup.md](irsa-setup.md) for the full walkthrough covering both IRSA and Pod Identity:
management role, cluster role, access entries, and the cluster Secret YAML.

## Scenario 3: ArgoCD Outside AWS

**Option A — Bearer token (CLI):** use `argocd cluster add` with a kubeconfig that has valid AWS
credentials. See [CLI Registration](#cli-registration).

**Option B — AWS profile (v2.10+):** store AWS credentials in a Kubernetes Secret and reference a named
profile:

```yaml
config: |
  {
    "awsAuthConfig": { "clusterName": "<CLUSTER_NAME>", "profile": "<AWS_PROFILE_NAME>" },
    "tlsClientConfig": { "insecure": false, "caData": "<BASE64_CA_DATA>" }
  }
```

## CLI Registration

```shell
# 1. Get the kubeconfig of the target cluster
aws configure list-profiles
export AWS_PROFILE=<TARGET_PROFILE>
aws eks update-kubeconfig --kubeconfig /path/to/target.yaml --name <CLUSTER_NAME>

# 2. Identify the context name
export KUBECONFIG=/path/to/target.yaml
kubectl config get-contexts

# 3. Log in to ArgoCD (pick one)
argocd login --grpc-web <ARGOCD_FQDN>
argocd login --sso <ARGOCD_FQDN>
# In-cluster (core mode):
export KUBECONFIG=/path/to/argocd-manager.yaml && argocd login --core

# 4. Register the cluster
argocd cluster add <CONTEXT_NAME> \
  --name <DESIRED_CLUSTER_NAME> \
  --kubeconfig /path/to/target.yaml \
  --cluster-endpoint kubeconfig
```

## Final Steps

After CLI registration, ArgoCD creates a Secret with a long auto-generated name. Export and manage it
declaratively:

```shell
kubectl get secret                          # locate the generated secret
kubectl get secret <GENERATED_NAME> -o yaml > /path/to/clusters/<CLUSTER>.yaml
```

Edit the exported file: remove `creationTimestamp`, `resourceVersion`, `uid`, and managed-fields
annotations. Set a meaningful `name`. Add the file to `kustomization.yaml`, commit and push, sync, verify
the cluster is healthy, then delete the original Secret.

## Common Errors

**`NoCredentialProviders`** — ArgoCD pod cannot find AWS credentials. For IRSA: verify the service
account annotation and OIDC provider registration. For Pod Identity: verify the add-on is installed and
the pod identity associations exist.

**`argocd-k8s-auth failed with exit code 20`** — cluster API is unreachable (network / security group
issue) or the assumed role has no access entry in the target cluster.

## Links

- [ArgoCD declarative setup — EKS](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#eks)
- [EKS cluster authentication](https://docs.aws.amazon.com/eks/latest/userguide/cluster-auth.html)
- [EKS access entries](https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html)
- [IRSA — IAM roles for service accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)
- [IAM roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)
- [IAM roles — terms and concepts](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_terms-and-concepts.html)
- [ArgoCD on AWS with multiple clusters](https://www.modulo2.nl/blog/argocd-on-aws-with-multiple-clusters)
