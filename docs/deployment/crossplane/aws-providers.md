# Crossplane AWS Providers

There are three distinct AWS provider lineages for Crossplane. They are not
interchangeable.

## Provider lineages

### crossplane-contrib/provider-aws (legacy, native)

Hand-written Go implementation predating Upjet. No longer the recommended
choice for new deployments.

- API group: `aws.crossplane.io/v1beta1`
- Registry: `xpkg.upbound.io/crossplane-contrib/provider-aws`
- Latest: `v0.57.x`
- GitHub: <https://github.com/crossplane-contrib/provider-aws>

### crossplane-contrib/provider-upjet-aws (community, free)

Upjet-generated from the Terraform AWS provider. Upbound donated the source
to `crossplane-contrib` in 2024 under the Apache 2.0 license. Released
roughly every 4-6 weeks. See [provider-upjet-aws.md](provider-upjet-aws.md)
for details and known concerns.

- API group: `aws.upbound.io/v1beta1`
- Registry: `xpkg.crossplane.io/crossplane-contrib/` (proxies GHCR)
- Latest: `v2.4.x`
- GitHub: <https://github.com/crossplane-contrib/provider-upjet-aws>
- Releases: <https://github.com/crossplane-contrib/provider-upjet-aws/releases>
- Packages (GHCR): <https://github.com/orgs/crossplane-contrib/packages?repo_name=provider-upjet-aws>

### upbound/provider-aws (official, commercial)

Downstream commercial build of the same upstream source as
`crossplane-contrib/provider-upjet-aws`. Requires an Upbound subscription
for packages published after March 25, 2025.

Additional benefits over the community provider:

- **LTS**: 12 months mainstream support + 6 months backport window per release
- **Backports**: security fixes, critical regressions, and data-loss fixes
  cherry-picked to older releases — allows staying on a pinned version without
  being forced to upgrade to receive fixes
- **Signed releases**: digitally signed by Upbound
- **SBOM**: Software Bill of Materials for compliance and auditing
- **Multi-language schemas**: resource schemas available in KCL and Python in
  addition to YAML
- **Commercial support**: Upbound SLA-backed support

- API group: `aws.upbound.io/v1beta1` (identical to community)
- Registry: `xpkg.upbound.io/upbound/`
- Latest: `v2.4.x`
- GitHub: <https://github.com/upbound/provider-aws>

## Syntax compatibility

`crossplane-contrib/provider-upjet-aws` and `upbound/provider-aws` share
identical CRD names, API groups, resource specs, and ProviderConfig syntax.
Migrating between them only requires changing `spec.package` in the Provider
manifest — managed resources, MRAPs, and Compositions are unaffected.

MRAPs reference MRD names derived from the CRD API groups embedded in the
provider package, not from the registry URL or org name. Since both upjet-based
lineages produce MRDs with identical names (e.g.
`podidentityassociations.eks.aws.m.upbound.io`), existing MRAPs require no
changes when switching between registries.

`crossplane-contrib/provider-aws` (legacy) uses a different API group
(`aws.crossplane.io`) and is **not** compatible.

## Family model

Both upjet-based lineages use the family provider model:

- `provider-family-aws` — manages ProviderConfig and authentication for all
  sub-providers in the family
- `provider-aws-eks`, `provider-aws-iam`, `provider-aws-s3`, etc. — one
  package per AWS service; install only what you need

## Choosing a provider

| Situation                                        | Recommendation                                 |
|--------------------------------------------------|------------------------------------------------|
| New deployment, no subscription                  | `crossplane-contrib/provider-upjet-aws`        |
| Existing Upbound subscription                    | `upbound/provider-aws`                         |
| Need LTS / backports / SLA                       | `upbound/provider-aws`                         |
| Migrating from `crossplane-contrib/provider-aws` | Migrate to `provider-upjet-aws`, not a drop-in |

## Version pinning

Upbound publishes a mutable **major channel tag** (`:v2`) that always points
to the latest release within that major version. This is convenient but not
reproducible — two clusters applying the same manifest can run different
versions.

| Strategy      | Example           | Reproducible     |
|---------------|-------------------|------------------|
| Major channel | `:v2`             | No — mutable tag |
| Full semver   | `:v2.4.0`         | Yes              |
| Image digest  | `@sha256:9dca...` | Yes — immutable  |

**Recommended**: pin to full semver. Discover the current version resolved by
a running provider:

```bash
kubectl get pods -n crossplane-system -o jsonpath=\
  '{range .items[*]}{.metadata.name}{"\t"}{range .status.containerStatuses[*]}{.imageID}{"\n"}{end}{end}'
```

Update the version explicitly in git when you intend to upgrade — this gives
a clear audit trail and prevents silent drift.

## Package URL reference

```yaml
# Community (free) — family provider
xpkg.crossplane.io/crossplane-contrib/provider-family-aws:v2.4.0
xpkg.crossplane.io/crossplane-contrib/provider-aws-eks:v2.4.0
xpkg.crossplane.io/crossplane-contrib/provider-aws-iam:v2.4.0
xpkg.crossplane.io/crossplane-contrib/provider-aws-route53:v2.4.0
xpkg.crossplane.io/crossplane-contrib/provider-aws-s3:v2.4.0

# Official (Upbound subscription required)
xpkg.upbound.io/upbound/provider-family-aws:v2.4.0
xpkg.upbound.io/upbound/provider-aws-eks:v2.4.0
xpkg.upbound.io/upbound/provider-aws-iam:v2.4.0
xpkg.upbound.io/upbound/provider-aws-route53:v2.4.0
xpkg.upbound.io/upbound/provider-aws-s3:v2.4.0
```

## References

- <https://blog.upbound.io/upbound-official-packages-changes>
- <https://blog.upbound.io/an-update-on-upbounds-official-providers>
- <https://blog.crossplane.io/new-providers-for-crossplane-donated-by-upbound-bring-up-to-4x-cost-savings/>
- <https://github.com/crossplane-contrib/provider-upjet-aws>
- <https://github.com/crossplane-contrib/provider-upjet-aws/releases>
- <https://github.com/orgs/crossplane-contrib/packages?repo_name=provider-upjet-aws>
- <https://marketplace.upbound.io>
