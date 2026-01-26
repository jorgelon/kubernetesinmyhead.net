# EKS Authentication Mode

EKS clusters use an authentication mode to control how IAM principals (users and roles) are granted access to Kubernetes APIs and objects within the cluster.

## Available Modes

| Mode              | Value                | Description                                                       |
|-------------------|----------------------|-------------------------------------------------------------------|
| ConfigMap only    | `CONFIG_MAP`         | Uses only the `aws-auth` ConfigMap (legacy, deprecated)           |
| API and ConfigMap | `API_AND_CONFIG_MAP` | Supports both access entries via EKS API and `aws-auth` ConfigMap |
| API only          | `API`                | Uses only access entries via EKS API (recommended)                |

## How It Works

The authentication mode determines which methods can be used to grant IAM principals access to the cluster:

### ConfigMap Method (Deprecated)

- Edit the `aws-auth` ConfigMap inside the cluster
- Maps IAM roles/users to Kubernetes RBAC groups
- Managed using kubectl within the cluster
- Cannot be enabled after cluster creation if not initially enabled
- The IAM principal that created the cluster has implicit `system:masters` permissions

### Access Entries Method (Recommended)

- Manage access using EKS API, AWS CLI, SDKs, CloudFormation, or Console
- Create access entries outside the cluster
- Use access policies for preconfigured permissions or Kubernetes RBAC for custom permissions
- Cannot be disabled once enabled
- All principals are visible and manageable via the EKS API

## Comparison

| Aspect                     | ConfigMap                           | Access Entries                    |
|----------------------------|-------------------------------------|-----------------------------------|
| Management Location        | Inside cluster (kubectl)            | Outside cluster (AWS API)         |
| Visibility                 | Limited (cluster creator invisible) | Full (all entries visible)        |
| Tooling                    | kubectl, manual YAML editing        | AWS CLI, Console, SDKs, IaC tools |
| Status                     | Deprecated                          | Recommended                       |
| Required for EKS Auto Mode | No                                  | Yes                               |
| Required for Hybrid Nodes  | Optional                            | Yes                               |

## Migration Path

The `API_AND_CONFIG_MAP` mode allows both methods to coexist during migration from the deprecated ConfigMap approach to access entries. Each method maintains separate entries.

### Migration Steps

1. Change cluster authentication mode from `CONFIG_MAP` to `API_AND_CONFIG_MAP`
2. Create access entries for existing `aws-auth` ConfigMap entries
3. Test access with new access entries
4. Remove entries from `aws-auth` ConfigMap
5. Optionally change mode to `API` to disable ConfigMap method permanently

## Important Considerations

- The `aws-auth` ConfigMap method is deprecated by AWS
- Once access entries are enabled, they cannot be disabled
- If ConfigMap method is not enabled during cluster creation, it cannot be enabled later
- All clusters created before access entries were introduced have ConfigMap enabled by default
- Amazon EKS Auto Mode requires access entries
- Hybrid nodes require `API` or `API_AND_CONFIG_MAP` modes
- Platform version requirements apply for access entries support

## Platform Version Requirements

To use access entries, the cluster must have a platform version equal to or later than:

| Kubernetes Version | Minimum Platform Version |
|--------------------|--------------------------|
| 1.30               | eks.2                    |
| 1.29               | eks.1                    |
| 1.28               | eks.6                    |
| Earlier versions   | All supported            |

## Recommendation

- **New clusters**: Use `API` mode to leverage access entries from the start
- **Existing clusters with ConfigMap**: Use `API_AND_CONFIG_MAP` during migration, then transition to `API` after migrating all entries
- **Clusters with hybrid nodes**: Must use `API` or `API_AND_CONFIG_MAP`

## References

- [AWS EKS - Change authentication mode to use access entries](https://docs.aws.amazon.com/eks/latest/userguide/setting-up-access-entries.html)
- [AWS EKS - Grant IAM users and roles access to Kubernetes APIs](https://docs.aws.amazon.com/eks/latest/userguide/grant-k8s-access.html)
- [AWS EKS - Grant IAM users access to Kubernetes with a ConfigMap](https://docs.aws.amazon.com/eks/latest/userguide/auth-configmap.html)
- [AWS EKS - Migrating existing aws-auth ConfigMap entries to access entries](https://docs.aws.amazon.com/eks/latest/userguide/migrating-access-entries.html)
