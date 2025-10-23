# Crossplane Providers and Managed Resource Activation Policies

## Overview

This guide explains the relationship between Providers and Managed Resource
Activation Policies (MRAP) in Crossplane v2, and how to configure them
effectively.

## Understanding Providers

### What Are Providers?

Providers are packages that extend Crossplane with the ability to manage
external resources (AWS, GCP, Azure, Kubernetes, etc.). Each provider:

- Installs Custom Resource Definitions (CRDs) for managed resources
- Runs a controller that reconciles those resources
- Manages the lifecycle of cloud infrastructure

### Provider Types

**Monolithic Providers** (legacy):

- Single package containing all resources for a cloud provider
- Example: `provider-aws` (includes S3, EC2, RDS, etc.)
- Larger footprint, slower updates

**Family Providers** (modular):

- Split into smaller, focused packages
- Example: `provider-aws-s3`, `provider-aws-ec2`, `provider-aws-rds`
- Install only what you need
- Better performance and faster updates

### Installing Providers

Providers are installed using the `Provider` resource:

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-aws-s3
spec:
  package: xpkg.upbound.io/upbound/provider-aws-s3:v2.0.0
```

When a provider is installed:

1. Crossplane downloads the package
2. CRDs are created in the cluster
3. Provider controller is deployed
4. Provider becomes available for use

Check provider status:

```bash
kubectl get providers
kubectl get providerrevisions
```

## Understanding Managed Resource Activation Policies (MRAP)

### What Are MRAPs?

MRAPs are Crossplane v2 resources that control **which managed resource types
Crossplane actively reconciles**.

Key concept: Installing a provider creates CRDs, but MRAP determines if
Crossplane watches and reconciles resources of those types.

### Why MRAPs Exist

**Performance**: Limit reconciliation to only the resources you actually use
**Security**: Explicit control over what resource types can be managed
**Multi-tenancy**: Different namespaces can have different activation policies
**Scalability**: Reduce overhead in clusters with many providers installed

### The Default Catch-All MRAP

After upgrading to Crossplane v2, a default catch-all MRAP may be created
that activates **all** managed resource types.

**Problem with catch-all**:

- Reconciles every CRD, even unused ones
- Poor performance at scale
- Less explicit control
- Higher resource consumption

**Best practice**: Delete the default catch-all and create specific MRAPs.

### Creating Specific MRAPs

Create targeted activation policies for only the resource types you use:

```yaml
apiVersion: apiextensions.crossplane.io/v1alpha1
kind: ManagedResourceActivationPolicy
metadata:
  name: aws-storage-resources
spec:
  activate:
    - buckets.s3.aws.upbound.io          # v1 cluster-scoped
    - buckets.s3.aws.m.upbound.io        # v2 namespaced
    - bucketpolicies.s3.aws.upbound.io
    - bucketpolicies.s3.aws.m.upbound.io
```

## Provider + MRAP Workflow

The complete flow for using managed resources:

```text
1. Install Provider
   └─> Creates CRDs (e.g., buckets.s3.aws.upbound.io)

2. Create MRAP
   └─> Activates reconciliation for specific CRD types

3. Deploy ProviderConfig
   └─> Configures credentials for the provider

4. Create Managed Resources
   └─> Crossplane reconciles them (because MRAP activates them)
```

### Installation Example

#### Step 1: Install the Provider

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-aws-s3
spec:
  package: xpkg.upbound.io/upbound/provider-aws-s3:v2.0.0
```

#### Step 2: Create MRAP

```yaml
apiVersion: apiextensions.crossplane.io/v1alpha1
kind: ManagedResourceActivationPolicy
metadata:
  name: aws-s3-activation
spec:
  activate:
    - buckets.s3.aws.m.upbound.io
    - bucketpolicies.s3.aws.m.upbound.io
```

#### Step 3: Configure Provider Credentials

```yaml
apiVersion: aws.m.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: aws-config
  namespace: production
spec:
  credentials:
    source: Secret
    secretRef:
      name: aws-credentials
      key: credentials
```

#### Step 4: Create Managed Resource

```yaml
apiVersion: s3.aws.m.upbound.io/v1beta1
kind: Bucket
metadata:
  name: my-bucket
  namespace: production
spec:
  forProvider:
    region: us-east-1
  providerConfigRef:
    name: aws-config
```

## MRAP Best Practices

### 1. Be Specific

Only activate resource types you actually use:

**Bad** (activates everything):

```yaml
spec:
  activate:
    - "*"  # Avoid this
```

**Good** (explicit list):

```yaml
spec:
  activate:
    - buckets.s3.aws.m.upbound.io
    - instances.ec2.aws.m.upbound.io
```

### 2. Include Both v1 and v2 During Migration

During the v1 to v2 migration period, include both cluster-scoped and
namespaced versions:

```yaml
spec:
  activate:
    - buckets.s3.aws.upbound.io      # v1 (cluster-scoped)
    - buckets.s3.aws.m.upbound.io    # v2 (namespaced)
```

Once migration is complete, remove v1 entries.

### 3. Organize by Function

Create separate MRAPs for different resource groups:

```yaml
---
apiVersion: apiextensions.crossplane.io/v1alpha1
kind: ManagedResourceActivationPolicy
metadata:
  name: storage-resources
spec:
  activate:
    - buckets.s3.aws.m.upbound.io
    - bucketpolicies.s3.aws.m.upbound.io
---
apiVersion: apiextensions.crossplane.io/v1alpha1
kind: ManagedResourceActivationPolicy
metadata:
  name: compute-resources
spec:
  activate:
    - instances.ec2.aws.m.upbound.io
    - securitygroups.ec2.aws.m.upbound.io
```

### 4. Document Your Activation Policies

Maintain clear documentation of which MRAPs exist and why, so teams know
what resources are available.

## Managing Multiple Providers

When using multiple providers (AWS, GCP, Azure), create organized MRAPs:

```yaml
apiVersion: apiextensions.crossplane.io/v1alpha1
kind: ManagedResourceActivationPolicy
metadata:
  name: multi-cloud-storage
spec:
  activate:
    # AWS S3
    - buckets.s3.aws.m.upbound.io
    # GCP Storage
    - buckets.storage.gcp.m.upbound.io
    # Azure Storage
    - accounts.storage.azure.m.upbound.io
```

## Troubleshooting

### Resources Not Reconciling

**Problem**: Created a managed resource but it's not being reconciled

**Solutions**:

1. Check if provider is installed and healthy: `kubectl get providers`
2. Verify MRAP includes the resource type:
   `kubectl get managedresourceactivationpolicy -o yaml`
3. Check provider logs for errors

### MRAP Not Found

**Problem**: Error about missing MRAP after upgrade

**Solution**: Create an MRAP for the resource types you're using.
In v2, MRAPs are required.

### Too Many Resources Activated

**Problem**: Performance issues, high memory usage

**Solution**: Review MRAPs and remove unused resource types from
activation lists.

## Checking Active Resources

To see which resource types are activated:

```bash
kubectl get managedresourceactivationpolicy -o yaml
```

To list all CRDs installed by providers:

```bash
kubectl get crd | grep -E '(aws|gcp|azure).*upbound'
```

## Migration Considerations

When migrating from v1 to v2:

1. **Providers continue working** - Existing providers don't need
   immediate changes
2. **MRAPs are new** - You must create MRAPs in v2 for reconciliation
   to work
3. **Both versions coexist** - Include both v1 and v2 resource types
   in MRAPs during migration
4. **Cleanup after migration** - Remove v1 resource types from MRAPs
   once migration is complete

## Summary

| Component | Purpose | Required? |
|-----------|---------|-----------|
| **Provider** | Installs CRDs and controllers | Yes |
| **MRAP** | Activates reconciliation for resource types | Yes (v2) |
| **ProviderConfig** | Configures credentials | Yes |
| **Managed Resource** | Actual infrastructure to create | Yes |

**Key takeaway**: Providers install capabilities, MRAPs activate them,
ProviderConfigs configure them, and Managed Resources use them.

## References

- [Crossplane Provider Documentation](https://docs.crossplane.io/latest/concepts/providers/)
- [Managed Resource Activation Policies](https://docs.crossplane.io/latest/concepts/managed-resources/#managed-resource-activation-policies)
- [Upbound Marketplace](https://marketplace.upbound.io/providers)
