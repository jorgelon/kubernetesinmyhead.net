# Crossplane AWS Providers

AWS-specific provider reference. For the general community vs official tier
comparison, see [Official vs Community Providers](../official-vs-community-providers.md).

## Provider lineages

Three distinct AWS provider lineages exist — they are not interchangeable.

### crossplane-contrib/provider-aws (legacy, native)

Hand-written Go implementation predating Upjet. No longer recommended for new
deployments.

- API group: `aws.crossplane.io/v1beta1`
- Registry: `xpkg.upbound.io/crossplane-contrib/provider-aws`
- Latest: `v0.57.x`
- GitHub: <https://github.com/crossplane-contrib/provider-aws>

### crossplane-contrib/provider-upjet-aws (community)

Upjet-generated from the Terraform AWS provider. Upbound donated the source to
`crossplane-contrib` in 2024 under Apache 2.0. Released every 4-6 weeks.

- API group: `aws.upbound.io/v1beta1`
- Registry: `xpkg.crossplane.io/crossplane-contrib/` (proxies GHCR)
- Latest: `v2.5.x`
- GitHub: <https://github.com/crossplane-contrib/provider-upjet-aws>

### upbound/provider-aws (official)

Downstream commercial build of the same source as `provider-upjet-aws`. Requires
an Upbound subscription for packages published after March 25, 2025. See
[Official vs Community](../official-vs-community-providers.md) for the full
feature comparison.

- API group: `aws.upbound.io/v1beta1` (identical to community)
- Registry: `xpkg.upbound.io/upbound/`
- Latest: `v2.5.x`
- GitHub: <https://github.com/upbound/provider-aws>

## Syntax compatibility

`crossplane-contrib/provider-upjet-aws` and `upbound/provider-aws` share identical
CRD names, API groups, resource specs, and ProviderConfig syntax. Migrating between
them only requires changing `spec.package` in the Provider manifest.

MRAPs reference MRD names derived from the CRD API groups embedded in the provider
package (e.g. `podidentityassociations.eks.aws.m.upbound.io`), not from the registry.
Both upjet-based lineages produce identical MRD names.

`crossplane-contrib/provider-aws` (legacy) uses `aws.crossplane.io` and is **not**
compatible.

## Family model

Both upjet-based lineages use the family provider model:

- `provider-family-aws` — manages ProviderConfig and authentication for all sub-providers
- `provider-aws-eks`, `provider-aws-iam`, `provider-aws-s3`, etc. — one package per
  AWS service; install only what you need

### Auto-installation behaviour

Each sub-provider declares a dependency on the **latest available version** of
`provider-family-aws`. The Crossplane package manager resolves and installs it
automatically when the first sub-provider is installed.

The family provider version will therefore be newer than the sub-provider version.
This version mismatch is by design and safe to ignore.

### Explicit installation with version pinning

To control the exact version of `provider-family-aws` (e.g. in an air-gapped
environment or for strict reproducibility), declare it explicitly **and** set
`skipDependencyResolution: true` on every sub-provider. Without the flag, sub-providers
still pull the latest family provider regardless of any explicit declaration.

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-family-aws
spec:
  package: xpkg.crossplane.io/crossplane-contrib/provider-family-aws:v2.5.0
---
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-aws-s3
spec:
  package: xpkg.crossplane.io/crossplane-contrib/provider-aws-s3:v2.5.0
  skipDependencyResolution: true  # must be set on every sub-provider
```

| Situation | Approach |
|-----------|----------|
| Internet-connected cluster | Let auto-dependency install the family provider |
| Air-gapped / strict version pinning | Explicit family provider + `skipDependencyResolution: true` on every sub-provider |

## Choosing a provider

| Situation                                        | Recommendation                                  |
|--------------------------------------------------|-------------------------------------------------|
| New deployment, no subscription                  | `crossplane-contrib/provider-upjet-aws`         |
| Existing Upbound subscription                    | `upbound/provider-aws`                          |
| Need LTS / backports / SLA                       | `upbound/provider-aws`                          |
| Migrating from `crossplane-contrib/provider-aws` | Migrate to `provider-upjet-aws` — not a drop-in |

## Version pinning

Pin sub-providers to full semver (e.g. `:v2.5.0`). Mutable tags like `:v2` are not reproducible.
Package URLs follow the pattern shown in [Explicit installation with version pinning](#explicit-installation-with-version-pinning).

## Governance and release cadence

Upbound donated the source to `crossplane-contrib` under Apache 2.0 and remains
the primary maintainer. Releases roughly every 4-6 weeks.

| Version | Date       | Terraform AWS provider base |
|---------|------------|-----------------------------|
| v2.5.0  | 2026-03-16 | v6.34.0                     |
| v2.4.0  | 2026-02-09 | v6.13.0                     |

## AWS feature support (as of v2.5.0)

| Feature              | Terraform AWS provider   | provider-upjet-aws        |
|----------------------|--------------------------|---------------------------|
| EKS Auto Mode        | Since v5.79.0 (Dec 2024) | Supported                 |
| Regional NAT Gateway | Since v6.24.0 (Dec 2025) | Supported (since v2.5.0)  |

## References

- <https://github.com/crossplane-contrib/provider-upjet-aws>
- <https://github.com/upbound/provider-aws>
- <https://docs.upbound.io/manuals/packages/providers/provider-families>
