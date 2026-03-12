# Crossplane Providers and MRAP

## Providers

A provider extends Crossplane with the ability to manage external resources
(AWS, GCP, Azure, etc.). Providers come in two shapes:

**Monolithic** — single package for all resources of a cloud (legacy).

**Family** — split into focused packages per service (e.g.
`provider-aws-eks`, `provider-aws-s3`). Install only what you need.

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-aws-eks
spec:
  package: xpkg.upbound.io/upbound/provider-aws-eks:v1.x.x
```

```bash
kubectl get providers
kubectl get providerrevisions
```

## Managed Resource Definitions (MRDs)

When a provider installs, it creates **ManagedResourceDefinitions** — one
per resource type. MRDs are lightweight Crossplane objects; at this stage
**no CRDs are installed yet**.

```bash
kubectl get managedresourcedefinition
```

MRDs remain dormant until activated by a
`ManagedResourceActivationPolicy`.

## ManagedResourceActivationPolicy (MRAP)

An MRAP declares which MRDs to activate. When an MRD is activated,
Crossplane installs its CRD and starts reconciling resources of that type.

```txt
Provider installs  →  MRDs created (no CRDs yet)
MRAP activates MRD →  CRD installed + controller watches it
```

```yaml
apiVersion: apiextensions.crossplane.io/v1alpha1
kind: ManagedResourceActivationPolicy
metadata:
  name: default
spec:
  activate:
    - podidentityassociations.eks.aws.m.upbound.io
    - roles.iam.aws.m.upbound.io
    - rolepolicyattachments.iam.aws.m.upbound.io
    - policies.iam.aws.m.upbound.io
    - zones.route53.aws.m.upbound.io
```

Check what is actually activated:

```bash
kubectl get managedresourceactivationpolicy default -o jsonpath='{.status.activated}' | tr ',' '\n'
```

### MRAPs are additive

Multiple MRAPs in the same cluster are **purely additive** — if any MRAP
activates an MRD, that MRD is activated. There is no priority, no
deactivation, and no way to restrict what another MRAP has activated.

This means a single MRAP with `activate: ["*"]` activates everything
regardless of other MRAPs:

```yaml
# This activates ALL MRDs. No other MRAP can restrict it.
spec:
  activate:
    - "*"
```

The only fix is to update or delete the wildcard MRAP itself.

### CRDs are not removed on deactivation

Removing an MRD from an MRAP's activate list does **not** uninstall its
CRD. CRD removal is destructive (it would delete all resources of that
type), so Crossplane leaves it to you.

The MRAP change only affects future installs — e.g. after a provider
upgrade or reinstall.

### What MRAP does not control

`ProviderConfig` CRDs are installed directly by the provider and are
**not** managed by MRAPs. They are always present:

- `providerconfigs.aws.m.upbound.io`
- `providerconfigusages.aws.m.upbound.io`
- `clusterproviderconfigs.aws.m.upbound.io`

Crossplane core CRDs (`*.crossplane.io`, `*.pkg.crossplane.io`) are also
always installed.

## Best practices

### Use explicit names, not wildcards

Discover which MRDs have actual managed resources in the cluster:

```bash
kubectl get managed -A
```

Use that list to build the MRAP `activate` entries. Avoid `"*"` — it
installs CRDs for every resource type the provider supports (~120+ for
`provider-aws`), putting unnecessary pressure on the API server.

### Namespaced vs cluster-scoped

Upbound providers ship two MRD variants per resource type:

| Suffix               | Scope          | Notes                      |
|----------------------|----------------|----------------------------|
| `*.aws.m.upbound.io` | Namespaced     | Crossplane v2, recommended |
| `*.aws.upbound.io`   | Cluster-scoped | Crossplane v1 (legacy)     |

Activate only the namespaced (`*.m.upbound.io`) variants unless you are
mid-migration from v1.

## References

- [Crossplane Provider Documentation](https://docs.crossplane.io/latest/concepts/providers/)
- [Managed Resource Activation Policies](https://docs.crossplane.io/latest/concepts/managed-resources/#managed-resource-activation-policies)
- [Upbound Marketplace](https://marketplace.upbound.io/providers)
