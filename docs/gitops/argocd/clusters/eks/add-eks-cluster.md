# Add an EKS Cluster to ArgoCD

## Overview

Two methods to register an EKS cluster:

- **CLI** (`argocd cluster add`): bootstraps a cluster Secret automatically. Useful for the initial setup.
- **Declarative Secret**: a `v1/Secret` with label `argocd.argoproj.io/secret-type: cluster`.
  Preferred for GitOps.

| Scenario      | ArgoCD location                | Auth method                                     |
|---------------|--------------------------------|-------------------------------------------------|
| Same account  | EKS in the same AWS account    | IRSA or Pod Identity                            |
| Cross-account | EKS in a different AWS account | IRSA or Pod Identity (cross-account assumption) |
| Outside AWS   | On-prem / other cloud          | Bearer token or AWS profile                     |

## Prerequisites

**EKS authentication modes** — two ways to map IAM identities to Kubernetes RBAC:

- **ConfigMap** (`aws-auth`): legacy mode, edit `kube-system/aws-auth`.
- **EKS API** (access entries): newer mode; the IAM principal that created the cluster gets an
  `AmazonEKSClusterAdminPolicy` access entry by default.

See [irsa-setup.md](irsa-setup.md) for OIDC provider, IRSA, and Pod Identity prerequisites
(required for Scenarios 1 & 2).

## Scenarios 1 & 2: Same Account and Cross-Account

See [irsa-setup.md](irsa-setup.md) for the full walkthrough covering both IRSA and Pod Identity:
management role, cluster role, access entries, and the cluster Secret YAML.

## Scenario 3: ArgoCD Outside AWS

**Option A — Bearer token (CLI):** use `argocd cluster add` with a kubeconfig that has valid AWS
credentials. See [CLI Registration](#cli-registration). After registration, follow
[Final Steps](#final-steps) to export and convert the generated Secret to a GitOps resource.

**Option B — AWS profile (v2.10+, Preferred):** store AWS credentials in a Kubernetes Secret and
reference a named profile. Preferred because it produces a fully declarative cluster Secret manageable
via GitOps:

```yaml
config: |
  {
    "awsAuthConfig": { "clusterName": "<EKS_CLUSTER_NAME>", "profile": "<AWS_PROFILE_NAME>" },
    "tlsClientConfig": { "insecure": false, "caData": "<BASE64_CA_DATA>" }
  }
```

Use [`cluster-external-secret.yaml`](cluster-external-secret.yaml) as a template. It pulls all four
fields — `server`, `caData`, `clusterName`, and `profile` — from the secrets store, so no sensitive
or environment-specific values are hardcoded. `<ARGOCD_CLUSTER_NAME>` is the only placeholder left
in the manifest, used as the K8s resource name and the secrets store path prefix.

## Token and Credential Expiry

| Component                               | TTL                          | Auto-renewed?                                 |
|-----------------------------------------|------------------------------|-----------------------------------------------|
| EKS bearer token                        | 15 min (hard EKS limit)      | Yes — `argocd-k8s-auth` regenerates on expiry |
| AWS static credentials (IAM access key) | Never, until rotated         | N/A                                           |
| AWS STS temporary credentials           | 15 min – 12 h (role session) | No — rotate externally before expiry          |

For **Option B**: if the profile uses static IAM credentials they never expire; STS temporary
credentials must be rotated before expiry or ArgoCD will lose cluster access.
For **Option A**: the generated Secret uses the exec plugin pattern (auto-refreshing EKS tokens),
but the underlying AWS credentials must remain valid.

## CLI Registration

```shell
# 1. Get the kubeconfig of the target cluster
aws configure list-profiles
export AWS_PROFILE=<TARGET_PROFILE>
aws eks update-kubeconfig --kubeconfig /path/to/target.yaml --name <EKS_CLUSTER_NAME>

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
