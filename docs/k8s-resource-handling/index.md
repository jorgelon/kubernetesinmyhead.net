# Kubernetes Resource Handling

Tools and frameworks for templating, composing,
and managing Kubernetes resources.

## Technologies

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

### [yq](yq/98-tips.md)

A lightweight command-line YAML processor for reading,
writing, and manipulating YAML files. Useful for
scripting Kubernetes manifest transformations and
extracting values from resource definitions.

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
