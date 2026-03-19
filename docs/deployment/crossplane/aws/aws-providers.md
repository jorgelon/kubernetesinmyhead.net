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

## Choosing a provider

| Situation                                        | Recommendation                                  |
|--------------------------------------------------|-------------------------------------------------|
| New deployment, no subscription                  | `crossplane-contrib/provider-upjet-aws`         |
| Existing Upbound subscription                    | `upbound/provider-aws`                          |
| Need LTS / backports / SLA                       | `upbound/provider-aws`                          |
| Migrating from `crossplane-contrib/provider-aws` | Migrate to `provider-upjet-aws` — not a drop-in |

## Version pinning

| Strategy      | Example           | Reproducible     |
|---------------|-------------------|------------------|
| Major channel | `:v2`             | No — mutable tag |
| Full semver   | `:v2.5.0`         | Yes              |
| Image digest  | `@sha256:9dca...` | Yes — immutable  |

**Recommended**: pin to full semver. Discover the version a running provider
resolves to:

```bash
kubectl get pods -n crossplane-system -o jsonpath=\
  '{range .items[*]}{.metadata.name}{"\t"}{range .status.containerStatuses[*]}{.imageID}{"\n"}{end}{end}'
```

## Package URL reference

```yaml
# Community (free) — family provider
xpkg.crossplane.io/crossplane-contrib/provider-family-aws:v2.5.0
xpkg.crossplane.io/crossplane-contrib/provider-aws-eks:v2.5.0
xpkg.crossplane.io/crossplane-contrib/provider-aws-iam:v2.5.0
xpkg.crossplane.io/crossplane-contrib/provider-aws-s3:v2.5.0

# Official (Upbound subscription required)
xpkg.upbound.io/upbound/provider-family-aws:v2.5.0
xpkg.upbound.io/upbound/provider-aws-eks:v2.5.0
xpkg.upbound.io/upbound/provider-aws-iam:v2.5.0
xpkg.upbound.io/upbound/provider-aws-s3:v2.5.0
```

## Governance and release cadence

Upbound donated the source to `crossplane-contrib` under Apache 2.0 and remains
the primary maintainer. Releases roughly every 4-6 weeks.

| Version | Date       | Terraform AWS provider base |
|---------|------------|-----------------------------|
| v2.5.0  | 2026-03-16 | v6.34.0                     |
| v2.4.0  | 2026-02-09 | v6.13.0                     |

## Known concerns

### Terraform AWS provider version lag

The provider pins an Upbound fork of the Terraform AWS provider. As of v2.5.0 that
fork is based on **v6.34.0**, closing the significant gap from v6.13.0 in v2.4.0.
New AWS features may still land in upstream Terraform before they reach this provider.

### crossplane-runtime dependency lag

As of early 2026, the `crossplane-runtime` dependency had not been updated for ~7
months, leaving known reconciliation bugs unfixed. See
<https://github.com/crossplane-contrib/provider-upjet-aws/issues/1973>.

## AWS feature support (as of v2.5.0)

| Feature              | Terraform AWS provider   | provider-upjet-aws        |
|----------------------|--------------------------|---------------------------|
| EKS Auto Mode        | Since v5.79.0 (Dec 2024) | Supported                 |
| Regional NAT Gateway | Since v6.24.0 (Dec 2025) | Supported (since v2.5.0)  |

## References

- <https://github.com/crossplane-contrib/provider-upjet-aws>
- <https://github.com/crossplane-contrib/provider-upjet-aws/releases>
- <https://github.com/orgs/crossplane-contrib/packages?repo_name=provider-upjet-aws>
- <https://github.com/upbound/provider-aws>
- <https://blog.upbound.io/upbound-official-packages-changes>
- <https://blog.upbound.io/an-update-on-upbounds-official-providers>
- <https://blog.upbound.io/donate-upjet-provider-project-to-cncf>
- <https://blog.crossplane.io/new-providers-for-crossplane-donated-by-upbound-bring-up-to-4x-cost-savings/>
- <https://marketplace.upbound.io>
