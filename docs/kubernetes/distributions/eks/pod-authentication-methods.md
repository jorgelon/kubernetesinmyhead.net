# Pod Authentication Methods for AWS API

This document describes the various methods available to authenticate Kubernetes pods against AWS APIs.

## Overview

When running applications in Kubernetes that need to interact with AWS services, you must provide AWS credentials. The method you choose impacts security, complexity, and operational overhead.

## Authentication Methods

### 1. IRSA (IAM Roles for Service Accounts)

IRSA uses an OIDC identity provider to establish trust between Kubernetes ServiceAccounts and AWS IAM roles. The pod receives a JWT token that AWS STS exchanges for temporary AWS credentials.

**How it works:**

- Cluster OIDC provider is registered with AWS IAM
- ServiceAccount is annotated with IAM role ARN
- AWS SDK automatically retrieves credentials via environment variables and mounted tokens
- No interception or DaemonSet required

**Security characteristics:**

- Fine-grained permissions per ServiceAccount
- Short-lived credentials with automatic rotation
- No privileged containers needed
- Excellent audit trail via CloudTrail

**Operational considerations:**

- Configuration lives in Kubernetes manifests (GitOps friendly)
- Requires OIDC provider setup per cluster
- Cross-account access requires additional trust policy configuration

**Use cases:**

- Standard choice for EKS workloads
- GitOps-centric workflows
- When you need configuration in version control

See [IRSA documentation](./irsa.md) for implementation details.

### 2. EKS Pod Identity

EKS Pod Identity is AWS's newest solution that simplifies IAM role assignment without requiring OIDC provider configuration. An AWS-managed agent handles credential distribution.

**How it works:**

- EKS add-on installs an agent DaemonSet
- Pod Identity associations are created via AWS API
- Agent intercepts SDK calls and provides credentials
- ServiceAccounts require no annotations

**Security characteristics:**

- Pod-specific permissions
- Temporary credentials
- Managed by AWS
- Simplified cross-account access

**Operational considerations:**

- Simpler initial setup than IRSA
- Associations managed outside Kubernetes manifests
- Less GitOps-friendly (external API configuration)
- Requires newer AWS SDK versions

**Use cases:**

- New EKS clusters
- When centralized IAM management is preferred
- Cross-account access patterns
- Infrastructure-as-Code managed associations

See [EKS Pod Identity Agent documentation](./eks-pod-identity-agent.md) for implementation details.

### 3. Node IAM Role (EC2 Instance Profile)

EC2 instances running Kubernetes nodes have IAM roles attached via instance profiles. All pods on a node inherit the node's IAM permissions.

**How it works:**

- IAM role is attached to EC2 instances
- AWS metadata service provides credentials
- All pods automatically use node credentials
- No pod-specific configuration needed

**Security characteristics:**

- Coarse-grained permissions (all pods share access)
- Automatic credential rotation
- Follows principle of least privilege poorly

**Operational considerations:**

- Zero configuration in pod manifests
- Simple to implement
- Works on any Kubernetes distribution with EC2 nodes

**Use cases:**

- Single-tenant clusters with uniform permissions
- Quick prototypes
- When fine-grained access control isn't required

### 4. Static IAM Credentials

Long-lived AWS access keys stored as Kubernetes Secrets and exposed to pods via environment variables.

**How it works:**

- IAM user access keys created in AWS
- Keys stored in Kubernetes Secrets
- Environment variables injected into pods

**Security characteristics:**

- Long-lived credentials
- Manual rotation required
- Risk of credential leakage
- No automatic expiry

**Operational considerations:**

- Works in any environment (not EKS-specific)
- Simple to understand
- Rotation is operationally intensive

**Use cases:**

- Development and testing environments only
- Non-EKS clusters without better alternatives
- Last resort when other methods aren't available

### 5. External Secrets Operator

External Secrets Operator synchronizes secrets from external secret management systems (AWS Secrets Manager, Parameter Store) into Kubernetes Secrets.

**How it works:**

- Operator runs in cluster with IRSA or Pod Identity
- Fetches secrets from AWS Secrets Manager or Parameter Store
- Creates and updates Kubernetes Secrets automatically
- Applications consume standard Kubernetes Secrets

**Security characteristics:**

- Centralized secret management
- Automatic synchronization
- Audit trail in AWS
- Still distributes static credentials (but managed)

**Operational considerations:**

- Additional operator to maintain
- Requires IRSA/Pod Identity for operator authentication
- Supports automatic secret rotation

**Use cases:**

- Managing static credentials from external AWS accounts
- Centralized secret lifecycle management
- When secrets need to be shared across multiple applications

### 6. AWS Secrets and Configuration Provider (ASCP)

ASCP uses the Secrets Store CSI driver to mount secrets from AWS Secrets Manager or Parameter Store as volumes in pods.

**How it works:**

- CSI driver retrieves secrets at pod start
- Secrets mounted as files in pod filesystem
- Uses IRSA or Pod Identity for authentication

**Security characteristics:**

- Secrets not exposed as environment variables
- Automatic rotation support
- Secrets fetched only when pod starts

**Operational considerations:**

- Requires CSI driver installation
- Secrets only refreshed on pod restart by default
- More complex than environment variables

**Use cases:**

- When secrets must be files rather than environment variables
- Applications that watch filesystem for secret changes
- Enhanced security posture over environment variables

### 7. Assumed Roles via AWS STS

Applications explicitly assume additional IAM roles using AWS STS AssumeRole API after initial authentication via IRSA or Pod Identity.

**How it works:**

- Pod authenticates with IRSA or Pod Identity initially
- Application code calls STS AssumeRole for additional roles
- Returns temporary credentials for assumed role

**Security characteristics:**

- Dynamic role assumption
- Short-lived credentials
- Chain of trust
- Fine-grained access control

**Operational considerations:**

- Application must implement assume-role logic
- Requires trust relationships between roles
- Enables complex permission scenarios

**Use cases:**

- Multi-account access patterns
- Dynamic permission escalation
- Service-to-service authentication across accounts

### 8. Legacy Solutions (kube2iam, KIAM)

Both kube2iam and KIAM intercept AWS metadata service calls to provide pod-specific IAM roles.

**How they work:**

- DaemonSet runs on each node
- iptables rules redirect metadata requests
- Pod annotations specify desired IAM role

**Status:**

- **kube2iam**: Still maintained but no longer recommended by AWS. AWS officially recommends using IRSA for EKS clusters
- **KIAM**: Archived on March 5, 2024 and no longer maintained
- Both have security concerns with privileged DaemonSets
- Both superseded by IRSA and EKS Pod Identity

**Do not use for new deployments.**

## Comparison Matrix

| Method             | Security  | Complexity | EKS-Specific | GitOps Friendly | Status     |
|--------------------|-----------|------------|--------------|-----------------|------------|
| IRSA               | Excellent | Medium     | Yes          | Very            | Active     |
| EKS Pod Identity   | Excellent | Low        | Yes          | Moderate        | Active     |
| Node IAM Role      | Poor      | Low        | No           | Yes             | Active     |
| Static Credentials | Poor      | Low        | No           | Yes             | Active     |
| External Secrets   | Good      | Medium     | No           | Moderate        | Active     |
| ASCP               | Good      | Medium     | No           | Moderate        | Active     |
| Assumed Roles      | Excellent | High       | No           | Yes             | Active     |
| kube2iam/KIAM      | Poor      | Medium     | No           | Yes             | Deprecated |

## Security Ranking

From most to least secure:

1. IRSA / EKS Pod Identity - Pod-specific, short-lived credentials
2. Assumed Roles via STS - Dynamic, temporary credentials
3. ASCP / External Secrets - Managed static credentials
4. Node IAM Role - Shared permissions, automatic rotation
5. Static Credentials - Manual management required
6. Hardcoded Credentials - Never use

## Decision Guide

### For EKS Clusters

**When you need per-pod IAM permissions:**

- Use IRSA if you prefer GitOps workflows and manifest-based configuration
- Use EKS Pod Identity if you prefer infrastructure-as-code for IAM associations

**When all pods need the same permissions:**

- Use Node IAM Role for simplicity

**When you need static credentials from external accounts:**

- Use External Secrets Operator with IRSA or Pod Identity

### For Non-EKS Clusters

**With EC2 nodes:**

- Use Node IAM Role if shared permissions are acceptable
- Use Static Credentials as last resort

**Without EC2 nodes (on-premises, other clouds):**

- Use Static Credentials with robust rotation practices
- Consider External Secrets Operator for centralized management

### For Multi-Account Scenarios

**Complex cross-account access:**

- Use IRSA or Pod Identity with Assumed Roles via STS
- Configure trust relationships between accounts

**Simple cross-account secrets:**

- Use External Secrets Operator

## Best Practices

### General Recommendations

- Avoid static credentials whenever possible
- Use short-lived credentials with automatic rotation
- Follow principle of least privilege per pod
- Implement proper IAM role trust policies
- Monitor credential usage via CloudTrail
- Never commit credentials to version control

### For Production Environments

- Use IRSA or EKS Pod Identity as default choice
- Implement pod security policies to prevent credential access
- Regular audit of IAM role assignments
- Automated detection of credential leakage
- Rotate static credentials regularly if they must be used

### For Development Environments

- Still prefer IRSA/Pod Identity when possible
- Static credentials acceptable for local development
- Use separate AWS accounts for development
- Implement credential cleanup automation

## Migration Path

From legacy solutions to modern approaches:

1. **From kube2iam/KIAM:** Migrate to IRSA or EKS Pod Identity
2. **From Static Credentials:** Migrate to IRSA or EKS Pod Identity
3. **From Node IAM Role:** Migrate to IRSA or EKS Pod Identity for fine-grained control
4. **Between IRSA and Pod Identity:** Both are valid, choose based on operational preferences

## Links

- [AWS EKS IAM Roles for Service Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)
- [AWS EKS Pod Identities](https://docs.aws.amazon.com/eks/latest/userguide/pod-identities.html)
- [External Secrets Operator](https://external-secrets.io/)
- [AWS Secrets and Configuration Provider](https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_csi_driver.html)
- [AWS STS AssumeRole](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html)
