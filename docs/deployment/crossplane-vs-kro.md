# Crossplane vs kro: packaging Kubernetes manifests

Comparison between [Crossplane](https://www.crossplane.io/) and [kro](https://kro.run/)
(Kube Resource Orchestrator) focused **exclusively** on how each project
packages a set of Kubernetes manifests behind a single, higher-level custom
API. Provisioning of external infrastructure, day-2 operations and policy are
out of scope here.

## Project facts at a glance

| Item               | Crossplane                                  | kro                                                                               |
|--------------------|---------------------------------------------|-----------------------------------------------------------------------------------|
| Repository         | `crossplane/crossplane`                     | `kubernetes-sigs/kro`                                                             |
| GitHub stars       | ~11.7k                                      | ~2.9k                                                                             |
| Contributors       | ~318                                        | ~120                                                                              |
| Company / origin   | Created by **Upbound**, donated to the CNCF | Jointly announced by **AWS**, **Google Cloud** and **Microsoft Azure** (Jan 2025) |
| Current governance | CNCF **Incubating** project (since 2020)    | Subproject of **Kubernetes SIG Cloud Provider**                                   |
| CNCF status        | Incubating                                  | Not a CNCF project (lives under the Kubernetes project umbrella)                  |

!!! note "Crossplane and Terraform providers"
    Beyond the YAML-packaging capabilities discussed below, Crossplane also
    ships **infrastructure providers**, many of which are generated **from
    existing Terraform providers** through the Upjet code-generation
    framework (for example `provider-upjet-aws`, `provider-upjet-azure`,
    `provider-upjet-gcp`). This lets Crossplane reuse the broad coverage of
    the Terraform provider ecosystem while still exposing each resource as a
    native Kubernetes CRD reconciled by a controller. kro has no equivalent
    concept; it only orchestrates Kubernetes resources.

## How each project packages manifests

Both tools solve the same packaging problem: take a graph of Kubernetes
manifests, hide it behind a single custom resource, and let platform users
consume it as a simple API. They reach that result with very different
mechanics.

### Crossplane

Crossplane splits the packaging contract into three pieces that live together
inside a **Configuration package** (an OCI image):

1. **CompositeResourceDefinition (XRD)**: declares the new high-level API.
   It defines the API group, kind, versions and the OpenAPI v3 schema of the
   fields that platform users will fill in. The XRD also controls whether
   the API is cluster-scoped or namespaced and whether a `Claim` kind is
   generated as a namespaced façade for the composite resource.

2. **Composition**: declares what the XR actually expands into. A
   Composition is a **pipeline of composition functions** (running as
   sidecar-like gRPC containers) that receive the desired state, run their
   logic, and return the rendered child resources. Common functions are
   `function-patch-and-transform` (declarative field patches between the XR
   and the children), `function-kcl`, `function-go-templating` or
   `function-python`. Each function step can read and mutate the desired
   composed resources, so logic can be expressed in plain YAML patches or in
   a real programming/templating language.

3. **Managed Resources / native Kubernetes resources**: the actual leaves of
   the graph. They can be Crossplane Managed Resources from a Provider
   (cloud infrastructure CRDs) or any standard Kubernetes object such as
   `Deployment`, `Service`, `ConfigMap`, etc. Crossplane reconciles each
   child independently and surfaces a consolidated status back on the XR.

The unit of distribution is the **Configuration package**: an OCI artifact
containing the XRD, the Compositions and the metadata that pins the required
Providers and Functions with their versions. Installing the package makes
the new API immediately available cluster-wide, with the controller logic
provided by Crossplane itself plus the referenced functions and providers.

### kro

kro collapses the contract into a single object, the
**ResourceGraphDefinition (RGD)**. An RGD has two main sections:

1. **`schema`**: describes the user-facing API. kro accepts both an OpenAPI
   schema and a **simpleSchema** shorthand where fields are declared as
   typed key/value pairs (`replicas: integer | default=2`, `name: string
   | required=true`, …). From this section kro derives a CRD, registers it
   in the cluster and starts a dedicated controller for it.

2. **`resources`**: an ordered (but logically a graph) list of Kubernetes
   manifest **templates**. Each entry has an `id` and a `template` holding
   a regular Kubernetes object. Templates can reference both the instance's
   spec and the live status/fields of sibling resources using **CEL
   expressions** like `${schema.spec.replicas}` or
   `${deployment.status.readyReplicas}`. From those references kro
   automatically **infers the dependency graph** and the correct creation,
   update and deletion order; there is no explicit `dependsOn`.

When a user applies an instance of the generated CRD, kro evaluates the CEL
expressions, materializes every templated resource, applies them in
topological order and propagates child status back into the instance's
status, again through CEL expressions defined in the RGD.

The unit of distribution is the **RGD YAML file itself** (typically shipped
through Git/GitOps, Helm or Kustomize); there is no dedicated package
format or OCI artifact, and no external function runtime to install.

## Conceptual differences in packaging

| Dimension                     | Crossplane                                                                            | kro                                                          |
|-------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------|
| API definition                | XRD (separate object)                                                                 | `schema` block inside the RGD                                |
| Resource graph definition     | Composition + composition functions pipeline                                          | `resources` list with CEL references                         |
| Templating / logic engine     | Pluggable functions (patch-and-transform, KCL, Go templates, Python, …)               | Built-in CEL expressions                                     |
| Dependency ordering           | Implicit per function step; explicit `dependsOn`-style via patches and function logic | Inferred automatically from CEL references between resources |
| Unit of distribution          | OCI **Configuration package** pinning providers and functions                         | A single **RGD** YAML manifest                               |
| Scope of children             | Kubernetes objects **and** Managed Resources (cloud APIs via providers)               | Kubernetes objects only                                      |
| Runtime footprint             | Crossplane core + Providers + Functions                                               | kro controller only                                          |
| Multi-tenancy façade          | XR + optional namespaced **Claim**                                                    | Namespaced or cluster-scoped instance of the generated CRD   |
| Learning curve for the author | Higher: XRD + Composition + functions + package metadata                              | Lower: one file, schema + templates + CEL                    |

## When the packaging model matters

- If the goal is to **bundle Kubernetes-only manifests** (a "stack" of
  `Deployment` + `Service` + `Ingress` + `ConfigMap` + `HPA` behind a
  single CRD), both tools are viable; kro is markedly more compact and has
  no external runtime to install besides its own controller.
- If the same higher-level API must **also provision cloud or SaaS
  infrastructure** (RDS, S3, IAM, GitHub repos, Datadog monitors, …), only
  Crossplane provides that out of the box thanks to its Providers,
  including the large family generated from Terraform providers via Upjet.
- If the author values **templating power** (loops, conditionals, full
  programming languages), Crossplane's function pipeline is more expressive;
  if the author prefers **a single declarative file with implicit
  dependencies**, kro's RGD is simpler.

## References

- Crossplane docs: <https://docs.crossplane.io/>
- Crossplane Configuration packages: <https://docs.crossplane.io/latest/concepts/packages/>
- Upjet (Terraform-based provider generator): <https://github.com/crossplane/upjet>
- kro docs: <https://kro.run/docs/overview>
- kro repository: <https://github.com/kubernetes-sigs/kro>
