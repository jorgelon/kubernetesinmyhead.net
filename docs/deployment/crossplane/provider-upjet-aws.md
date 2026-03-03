# provider-upjet-aws

`crossplane-contrib/provider-upjet-aws` is the community AWS provider for
Crossplane, generated from the Terraform AWS provider via the
[Upjet](https://github.com/crossplane/upjet) framework. It replaced the legacy
hand-maintained `crossplane-contrib/provider-aws`.

## Governance and maintainership

Upbound donated the source code to the `crossplane-contrib` organisation under
the Apache 2.0 license, and remains the primary maintainer. The provider is
released in two tiers:

- **Community** (free): published to `xpkg.crossplane.io/crossplane-contrib/`
  and `ghcr.io/crossplane-contrib/`
- **Official Provider** (commercial): downstream build by Upbound with LTS,
  backports and signed releases, published to `xpkg.upbound.io/upbound/`

The core active team is small (primarily Upbound employees: `turkenf`,
`ulucinar`, `sergenyalcin`, `erhancagirici`). One contributor (`@mbbush`) moved
to emeritus status in 2025.

## Release cadence

Roughly one release every 4-6 weeks. Recent versions:

| Version | Date       | Terraform AWS provider base |
|---------|------------|-----------------------------|
| v2.4.0  | 2026-02-09 | v6.13.0                     |
| v2.3.0  | 2025-12-05 | -                           |
| v2.2.0  | 2025-11-05 | -                           |
| v2.1.0  | 2025-09-23 | v6.13.0                     |

## Known concerns

### Terraform AWS provider version lag

The provider pins an Upbound fork of the Terraform AWS provider
(`github.com/upbound/terraform-provider-aws`). As of v2.4.0 that fork is based
on **v6.13.0** of the upstream Terraform AWS provider, while upstream is already
at v6.34.0+. This means new AWS features land in the Terraform provider well
before they are available here.

### crossplane-runtime dependency lag

As of early 2026, the `crossplane-runtime` dependency had not been updated for
~7 months, leaving known reconciliation bugs unfixed in the provider.

See <https://github.com/crossplane-contrib/provider-upjet-aws/issues/1973>

### Polling reconciliation at scale

Like all Upjet-based providers, reconciliation relies on polling cloud APIs
rather than event-driven watching. At large scale (thousands of managed
resources, multiple accounts) this can cause AWS API rate limiting and
increased resource consumption on the controller pod.

## AWS feature support (as of v2.4.0)

| Feature              | Available in Terraform AWS provider | provider-upjet-aws        |
|----------------------|-------------------------------------|---------------------------|
| EKS Auto Mode        | Since v5.79.0 (Dec 2024)            | Supported                 |
| Regional NAT Gateway | Since v6.24.0 (Dec 2025)            | Not yet (base is v6.13.0) |

## References

- <https://github.com/crossplane-contrib/provider-upjet-aws>
- <https://blog.upbound.io/an-update-on-upbounds-official-providers>
- <https://blog.upbound.io/donate-upjet-provider-project-to-cncf>
- <https://blog.crossplane.io/new-providers-for-crossplane-donated-by-upbound-bring-up-to-4x-cost-savings/>
