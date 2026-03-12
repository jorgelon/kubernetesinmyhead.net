# Upgrading Crossplane from v1 to v2

## Overview

This guide covers the complete upgrade process from Crossplane v1 to v2, with a focus on
environments using standalone managed resources (not Compositions).

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

1. Verify Crossplane version (check that you're running v1.20)
2. Inventory your resources (list all managed resources and providers)
3. Check for deprecated features:
   - Review compositions for native patch and transform
   - Check for ControllerConfig resources
   - Verify no external secret stores are configured

### Step 2: Upgrade Crossplane Core and Provider Packages

1. **Update provider manifests**

   Ensure providers use fully qualified image names and v2-compatible versions:

   ```yaml
   apiVersion: pkg.crossplane.io/v1
   kind: Provider
   metadata:
     name: provider-aws-s3
   spec:
     package: xpkg.upbound.io/upbound/provider-aws-s3:v2
   ```

2. **Deploy updated providers**

   Apply the updated provider manifests.

3. **Verify provider health**: `kubectl get providers && kubectl get providerrevisions`

## Complete Upgrade Checklist

- [ ] Verify running Crossplane v1.20
- [ ] Inventory all managed resources and providers
- [ ] Remove deprecated features (ControllerConfig, external secret stores, etc.)
- [ ] Upgrade Crossplane core to v2
- [ ] Upgrade provider packages to v2-compatible versions
- [ ] Verify all existing resources continue working
- [ ] Test existing infrastructure functionality

## Best Practices

Test in staging first. Backup all resource definitions before upgrading. Migrate
resources incrementally using `deletionPolicy: Orphan` for safety. Monitor logs
and metrics throughout. Both cluster-scoped (v1) and namespaced (v2) resources
coexist indefinitely — there is no forced cutover.

## Day 2 Operations

After upgrading, adopt v2 features at your own pace.

### Configure Managed Resource Activation Policies (MRAP)

In Crossplane v2, you must explicitly specify which managed resources should be
reconciled using MRAPs. During migration, include both cluster-scoped
(`.aws.upbound.io`) and namespaced (`.aws.m.upbound.io`) resource types.

See [Providers and MRAP](./providers-and-mrap.md) for the full MRAP reference,
including benefits, additive behavior, and best practices.

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

ProviderConfigs also need to be namespaced. The API group changes from
`aws.upbound.io/v1beta1` to `aws.m.upbound.io/v1beta1`, and the secret
reference no longer needs an explicit namespace (it uses the ProviderConfig's
own namespace). Place one ProviderConfig in each namespace that will contain
managed resources.

#### Create Namespace Structure

Plan namespaces for your managed resources (e.g. `production-infrastructure`,
`staging-infrastructure`) and declare them in git as part of your GitOps setup.

## References

- [Crossplane v2 Upgrade Guide](https://docs.crossplane.io/v2.0/guides/upgrade-to-crossplane-v2/)
- [Managed Resource Activation Policies](https://docs.crossplane.io/latest/concepts/managed-resources/#managed-resource-activation-policies)
- [Upbound Provider Documentation](https://marketplace.upbound.io/providers)
