# Upgrading Crossplane from v1 to v2

## Overview

This guide covers the complete upgrade process from Crossplane v1 to v2, with a focus on environments using standalone managed resources (not Compositions).

## Prerequisites

Before upgrading to Crossplane v2, ensure:

1. **Running Crossplane v1.20** - Upgrade to v1.20 first if on an earlier version
2. **Remove deprecated features**:
   - Native patch and transform compositions (replaced by composition functions)
   - ControllerConfig type (replaced by DeploymentRuntimeConfig)
   - External secret stores (no longer supported)
   - Default registry flags (use fully qualified image names)

## What's New in v2

- **Namespaced managed resources** - Resources are now namespace-scoped instead of cluster-scoped
- **Managed Resource Activation Policies (MRAP)** - Control which resources Crossplane reconciles
- **Composition functions** - More flexible composition approach
- **Improved multi-tenancy** - Better isolation with namespace-scoped resources
- **Breaking changes** - Some v1 features removed

## Upgrade Process

### Step 1: Pre-Upgrade Assessment

1. **Verify Crossplane version**

   Check that you're running v1.20:

   ```bash
   kubectl get deployment crossplane -n crossplane-system -o jsonpath='{.spec.template.spec.containers[0].image}'
   ```

2. **Inventory your resources**

   List all managed resources:

   ```bash
   kubectl get managed --all-namespaces
   ```

   List all providers:

   ```bash
   kubectl get providers
   ```

3. **Check for deprecated features**

   - Review compositions for native patch and transform
   - Check for ControllerConfig resources
   - Verify no external secret stores are configured

### Step 2: Upgrade Crossplane Core

1. Update Helm repository
2. Upgrade to v2
3. Verify the upgrade (check deployment and logs)

### Step 3: Upgrade Provider Packages

1. **Update provider manifests**

   Ensure providers use fully qualified image names and v2-compatible versions:

   ```yaml
   apiVersion: pkg.crossplane.io/v1
   kind: Provider
   metadata:
     name: provider-aws-s3
   spec:
     package: xpkg.upbound.io/upbound/provider-aws-s3:v2.0.0
   ```

2. **Deploy updated providers**

   Apply the updated provider manifests.

3. **Verify provider health**

   Check that providers are healthy and running:

   ```bash
   kubectl get providers
   kubectl get providerrevisions
   ```

### Step 4: Verify and Test

1. Check that existing cluster-scoped managed resources continue working
2. Verify providers are healthy and running
3. Test that existing infrastructure remains functional

## Complete Upgrade Checklist

- [ ] Verify running Crossplane v1.20
- [ ] Inventory all managed resources and providers
- [ ] Remove deprecated features (ControllerConfig, external secret stores, etc.)
- [ ] Upgrade Crossplane core to v2
- [ ] Upgrade provider packages to v2-compatible versions
- [ ] Verify all existing resources continue working
- [ ] Test existing infrastructure functionality

## Rollback Strategy

If issues occur during upgrade:

1. **Crossplane core rollback**

   ```bash
   helm rollback crossplane -n crossplane-system
   ```

2. **Provider rollback**

   Revert provider manifests to previous versions.

3. **Keep existing resources**

   Existing cluster-scoped resources continue working even after core upgrade. Only delete after confirming namespaced resources work.

## Troubleshooting

### MRAP Issues

**Problem**: Resources not reconciling after upgrade

**Solution**: Verify MRAP includes the resource type:

```bash
kubectl get managedresourceactivationpolicy -o yaml
```

### Provider Not Installing

**Problem**: Provider stuck in "Installing" state

**Solution**: Check provider logs and events:

```bash
kubectl describe provider provider-aws-s3
kubectl logs -n crossplane-system deployment/provider-aws-s3
```

### Resource Not Adopting

**Problem**: Using orphan-adopt strategy but resource not adopting existing cloud resource

**Solutions**:

- Verify cloud resource name exactly matches
- Check all required spec fields match the existing cloud resource
- Review provider logs for adoption errors
- Ensure credentials have permission to describe/import the resource

### Permission Issues

**Problem**: Resources failing with permission errors

**Solution**:

- Verify ProviderConfig credentials are correct
- Check RBAC permissions for the target namespace
- Ensure service accounts have necessary permissions

## Best Practices

1. **Test in staging first** - Perform the upgrade in a non-production environment
2. **Gradual migration** - Migrate resources incrementally, not all at once
3. **Keep both versions during transition** - Maintain both cluster-scoped and namespaced resources during migration
4. **Use orphan deletion policy** - Set `deletionPolicy: Orphan` for safety during migration
5. **Monitor closely** - Watch logs and metrics during and after the upgrade
6. **Document your process** - Keep detailed notes of your specific migration steps
7. **Backup configurations** - Export all resource definitions before upgrading

## Day 2 Operations

After successfully upgrading Crossplane to v2, you can begin adopting v2 features at your own pace. Existing v1 cluster-scoped resources continue working indefinitely alongside new v2 namespaced resources.

### Understanding Coexistence

Crossplane v2 supports both cluster-scoped (v1) and namespaced (v2) resources simultaneously. This allows you to:

- Run v2 without immediately migrating existing resources
- Test namespaced resources while keeping production on cluster-scoped resources
- Migrate resources gradually over time
- Maintain both resource types indefinitely if needed

### Configure Managed Resource Activation Policies (MRAP)

In Crossplane v2, you must explicitly specify which managed resources should be reconciled using MRAPs.

#### Step 1: Review Default MRAP

By default, Crossplane v2 may create a catch-all MRAP that activates all resource types. Review existing policies:

```bash
kubectl get managedresourceactivationpolicy -o yaml
```

#### Step 2: Create Targeted MRAPs

Create activation policies for your specific resource types:

```yaml
apiVersion: apiextensions.crossplane.io/v1alpha1
kind: ManagedResourceActivationPolicy
metadata:
  name: aws-resources
spec:
  activate:
    - buckets.s3.aws.upbound.io        # v1 cluster-scoped
    - buckets.s3.aws.m.upbound.io      # v2 namespaced
    - instances.ec2.aws.upbound.io
    - instances.ec2.aws.m.upbound.io
```

**Important**: Include both cluster-scoped (`.aws.upbound.io`) and namespaced (`.aws.m.upbound.io`) resource types during the migration period.

#### Step 3: Delete Default Catch-All (Optional)

For better performance and security, delete the default catch-all MRAP after creating specific policies.

See the [Providers and MRAP](./providers-and-mrap.md) guide for more details.

### Migrating to Namespaced Managed Resources

When ready, you can migrate existing cluster-scoped resources to namespaced versions.

#### Understanding the Resource Changes

- **v1 (cluster-scoped)**: `s3.aws.upbound.io/v1beta2`
- **v2 (namespaced)**: `s3.aws.m.upbound.io/v1beta1`

The `.m.` indicates a namespaced managed resource.

#### Migration Strategies

Choose based on your resource type and tolerance for downtime:

##### Option A: Create-First Migration

Use when duplicate resources are acceptable or downtime is tolerable.

1. Deploy the new namespaced resource
2. Wait for the resource to become ready
3. Update application references (ConfigMaps, Secrets, etc.)
4. Delete the old cluster-scoped resource

##### Option B: Orphan-and-Adopt Migration

Use for resources with globally unique names (like S3 buckets) or zero-downtime requirements.

1. Set `deletionPolicy: Orphan` on the old resource
2. Delete the old Crossplane resource (cloud resource remains)
3. Deploy the new namespaced resource with the same cloud resource name
4. Verify the resource was adopted (check events and status)

#### Migrate ProviderConfigs

ProviderConfigs also need to be namespaced:

**Before (v1)**

```yaml
apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: aws-provider
spec:
  credentials:
    source: Secret
    secretRef:
      name: aws-credentials
      namespace: crossplane-system
      key: credentials
```

**After (v2)**

```yaml
apiVersion: aws.m.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: aws-provider
  namespace: production-infrastructure
spec:
  credentials:
    source: Secret
    secretRef:
      name: aws-credentials
      key: credentials
```

Note: The secret reference no longer needs a namespace when ProviderConfig is namespaced (it uses the same namespace).

#### Create Namespace Structure

Plan and create namespaces for your managed resources:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: production-infrastructure
---
apiVersion: v1
kind: Namespace
metadata:
  name: staging-infrastructure
```

### Exploring Other v2 Features

Beyond namespaced resources, consider exploring:

1. **Composition functions** - More powerful than patch and transform
2. **Multi-tenancy** - Use namespaces to isolate teams/environments
3. **Refined MRAP policies** - Optimize which resources are actively reconciled
4. **Updated monitoring** - Adjust dashboards for namespace-scoped resources

## References

- [Crossplane v2 Upgrade Guide](https://docs.crossplane.io/v2.0/guides/upgrade-to-crossplane-v2/)
- [Managed Resource Activation Policies](https://docs.crossplane.io/latest/concepts/managed-resources/#managed-resource-activation-policies)
- [Upbound Provider Documentation](https://marketplace.upbound.io/providers)
