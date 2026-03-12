# Concepts

Crossplane extends Kubernetes to manage external infrastructure using the
same declarative API model. Its main building blocks are:

- Providers — connect to external APIs (AWS, Azure, GCP, ...)
- Managed Resources — individual infrastructure objects
- Compositions + XRDs — build custom platform APIs on top

## Provider and provider family

A provider is a Crossplane controller that manages external resources (AWS, GCP,
Azure, ...). A **provider family** groups related providers sharing a common
`ProviderConfig` (e.g. `provider-family-aws` + `provider-aws-eks`). A
`ProviderConfig` supplies credentials via `spec.providerConfigRef`.

See [Official vs Community Providers](./official-vs-community-providers.md) for
tier comparison and [Providers and MRAP](./providers-and-mrap.md) for MRAP
activation details.

## Managed resource

A managed resource (MR) maps 1-to-1 to an external infrastructure object
(e.g. an AWS VPC, an RDS instance). Crossplane continuously reconciles
the desired state in the spec against the real state in the cloud.

Key fields on every MR:

- `spec.forProvider` — desired configuration of the external resource
- `spec.providerConfigRef` — which ProviderConfig to use for credentials
- `spec.deletionPolicy` — `Delete` (default) or `Orphan` the external
  resource when the MR is deleted
- `metadata.annotations[crossplane.io/external-name]` — override the
  name used in the external API

> List all managed resources across all providers with `kubectl get managed`

## Composition

A Composition is a template that defines which managed resources are
created when a Composite Resource is instantiated.

Key concepts inside a Composition:

- **resources** — list of managed resource templates
- **patches** — copy values from the XR into composed resources (e.g.
  propagate `spec.parameters.region` to every resource)
- **transforms** — manipulate values during patching (string format,
  type conversion, value mapping, ...)
- **pipeline** (`mode: Pipeline`) — ordered functions for advanced logic,
  alternative to the `resources` list

## Composite Resource Definitions (XRD)

An XRD defines a new cluster-scoped custom API, similar to a CRD. It
specifies the API group, kind, versions, an optional `claimNames` block
to expose a namespace-scoped Claim kind, and a JSON schema to validate
user input.

## Composite resource (XR)

A Composite Resource is a cluster-scoped instance of an XRD. Crossplane
uses the matching Composition to render it into one or more managed
resources. Users rarely create XRs directly — they use Claims instead.

## Claim

A Claim is a namespace-scoped proxy for a Composite Resource, enabled by
setting `spec.claimNames` in the XRD. Platform users create Claims;
Crossplane creates and manages the backing XR automatically.

## Linking a Composition to an XRD

A Composition references an XRD via `spec.compositeTypeRef`. The
`apiVersion` and `kind` must match the XRD's `spec.group`,
`spec.versions[*].name`, and `spec.names.kind`.

Multiple Compositions can target the same XRD. The active Composition is
selected via `spec.compositionRef` or `spec.compositionSelector` on the
XR or Claim.

```text
XRD  →  Composition (compositeTypeRef)
  ↓
  XR (cluster-scoped instance)
  ↓
  Claim (namespace-scoped, optional)
```

## Grouping all

In Crossplane you can create a custom API to manage Kubernetes resources
and infrastructure services grouped as a single unit.
