# Official vs Community Crossplane Providers

Crossplane providers are distributed in two tiers built from the same
Upjet-generated source code. The tier affects licensing, support, and
operational capabilities — not the resource API.

## Community tier

Published under the Apache 2.0 license to `xpkg.crossplane.io/crossplane-contrib/`
(proxies GHCR). No subscription required.

Example: `crossplane-contrib/provider-upjet-aws`

## Official tier

Commercial downstream builds by Upbound. Packages published after March 25, 2025
require an Upbound subscription.

Published to `xpkg.upbound.io/upbound/`.

Example: `upbound/provider-aws`

## Feature comparison

| Feature                              | Community | Official                                |
|--------------------------------------|-----------|-----------------------------------------|
| Free to use                          | Yes       | Subscription required (post March 2025) |
| LTS (12 months + 6 month backports)  | No        | Yes                                     |
| Security/regression backports        | No        | Yes                                     |
| Signed releases                      | No        | Yes                                     |
| SBOM                                 | No        | Yes                                     |
| Multi-language schemas (KCL, Python) | No        | Yes                                     |
| `safe-start` MRAP capability         | No        | Yes                                     |
| Commercial support (SLA)             | No        | Yes                                     |

## Syntax compatibility

Both tiers share **identical** CRD names, API groups, and ProviderConfig syntax.
Switching only requires changing `spec.package` in the Provider manifest —
managed resources, MRAPs, and Compositions are unaffected.

## Choosing a tier

| Situation                     | Recommendation |
|-------------------------------|----------------|
| No Upbound subscription       | Community      |
| Need LTS / backports / SLA    | Official       |
| Need `safe-start` / MRAP      | Official       |
| Existing Upbound subscription | Official       |

## References

- <https://blog.upbound.io/upbound-official-packages-changes>
- <https://blog.upbound.io/an-update-on-upbounds-official-providers>
- <https://blog.crossplane.io/new-providers-for-crossplane-donated-by-upbound-bring-up-to-4x-cost-savings/>
