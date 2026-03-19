# Deployment tips

These tips are based on Crossplane 2.2 and cover deploying infrastructure resources.

## Deploy crossplane

Crossplane has an official helm chart.

<https://docs.crossplane.io/latest/get-started/install/>

> A personal recommendation is to deploy it using GitOps and the rendered
> manifest pattern.

## Prepare providers

### Configure MRAP

This is an alpha feature.
Before installing providers, modify the default MRAP to permit only the
**namespaced Managed Resource Definitions** that you will use.

See more about MRAP [in this document](providers-and-mrap.md)

### DeploymentRuntimeConfig

The `DeploymentRuntimeConfig` resource is a beta feature that configures how
providers are deployed (Deployment, Service, and ServiceAccount).

See more about DeploymentRuntimeConfig [in this document](deploymentruntimeconfig.md).

### Authentication and ProviderConfig

Depending on the provider, different authentication methods are available.
This is configured via a `ProviderConfig` resource.

See more about ProviderConfig [in this document](providerconfig.md)

## Deploy providers

Finally, deploy the needed providers. Depending on the case you will need the
official Upbound providers or the community ones.

See more about providers [in this document](official-vs-community-providers.md)
