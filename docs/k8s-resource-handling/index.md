# Kubernetes Resource Handling

Tools and frameworks for templating, composing,
and managing Kubernetes resources.

## Templating and manifest generation

### [Helm](helm/syntax.md)

The most widely adopted Kubernetes package manager.
Helm uses Go templates to generate Kubernetes manifests
from reusable charts, supporting versioned releases
and rollbacks.

### [Kustomize](kustomize/98-tips.md)

A template-free approach to Kubernetes manifest
customization. Kustomize uses overlays and patches
to transform base manifests without modifying the
originals, and is built into `kubectl`.

### [ytt](ytt/00-intro.md)

A YAML-aware templating tool from the Carvel project.
ytt uses Starlark (a Python dialect) for overlay logic
while keeping YAML structure intact, avoiding the
whitespace pitfalls of text-based templating.

### Jsonnet / Tanka

Grafana Tanka uses Jsonnet, a data templating language,
to generate Kubernetes manifests. More expressive than
YAML but with a steeper learning curve.

### cdk8s

AWS CDK for Kubernetes. Define manifests using
TypeScript, Python, Go, or Java. Useful if you
prefer general-purpose languages over YAML.

### CUE

A data validation and configuration language that can
generate, validate, and constrain Kubernetes manifests
with strong type checking.

### Timoni

CUE-based package manager for Kubernetes from the Flux
ecosystem. Similar to Helm but uses CUE instead of Go
templates.

### KCL

Kusion Configuration Language. A CNCF project for
writing and validating Kubernetes configs with a
purpose-built language.

### Dhall

A programmable, typed configuration language that can
target Kubernetes YAML with built-in imports and
guarantees about termination.

## Resource composition and abstraction

### Crossplane Composite Resources

Crossplane XRDs and Compositions allow platform teams
to define higher-level abstractions that provision both
Kubernetes and cloud-provider resources through a
single API object.

### Kro

Kro (Kubernetes Resource Orchestrator) lets you define
custom groups of Kubernetes resources as a single
logical unit using ResourceGroups, simplifying complex
multi-resource deployments.

### Metacontroller

A lightweight framework for writing custom controllers
using simple webhooks instead of full operator SDKs.
Enables resource composition with minimal boilerplate.

## YAML and JSON processing

### [yq](yq/98-tips.md)

A lightweight command-line YAML processor for reading,
writing, and manipulating YAML files. Useful for
scripting Kubernetes manifest transformations and
extracting values from resource definitions.

### jq

The JSON equivalent of yq. Often used with
`kubectl -o json` output for querying and transforming
Kubernetes resource data in scripts.
