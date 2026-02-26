# Raw Manifests vs Helm in GitOps

Trade-offs between raw YAML manifests and Helm charts in a GitOps workflow,
covering transparency, tooling complexity, and operational concerns.

## Raw Manifests

Raw manifests are plain Kubernetes YAML files committed directly to Git.
Tools like ArgoCD and FluxCD can sync them to a cluster without additional
processing.

### Advantages of Raw Manifests

- No additional tooling required beyond `kubectl`
- Full transparency: what you see in Git is exactly what gets applied
- Simple debugging: no templating layer to reason about
- Works natively with Kustomize for environment-specific overlays
- Easier to review in pull requests

### Disadvantages of Raw Manifests

- Repetition across environments (dev, staging, production)
- Managing environment-specific differences requires Kustomize overlays
- Risk of configuration drift between environments if not carefully managed
- Harder to reuse across multiple projects or teams

## Helm Charts

Helm is a package manager for Kubernetes that uses templates to generate
manifests dynamically. Charts bundle all resources for an application and
expose configurable values.

### Advantages of Helm Charts

- Parameterized configuration through `values.yaml`
- Single chart can target multiple environments with different values files
- Large ecosystem of community charts (e.g., Artifact Hub)
- Atomic upgrades and rollbacks via Helm release history
- Encapsulates application complexity behind a clean interface

### Disadvantages of Helm Charts

- **Not declarative**: `helm install/upgrade/rollback` are imperative commands
- Templating adds complexity: Go templates can be hard to read and debug
- `helm template` output must be inspected to understand what is applied
- Debugging requires understanding both the chart logic and rendered output
- Upstream chart changes may introduce unexpected modifications
- Chart dependencies can create version conflicts

## Comparison Table

| Aspect               | Raw Manifests      | Helm Charts     |
|----------------------|--------------------|-----------------|
| Declarative          | Yes                | No              |
| Complexity           | Low                | Medium to High  |
| Reusability          | Low                | High            |
| Transparency         | High               | Medium          |
| Environment handling | Kustomize overlays | Values files    |
| Rollback             | Git revert         | `helm rollback` |
| Community ecosystem  | Limited            | Large           |
| Debugging ease       | High               | Medium          |

## GitOps Tool Integration

### ArgoCD

ArgoCD syncs plain manifests from Git declaratively. Point the Application
source to the directory containing the rendered YAML files.

```yaml
spec:
  source:
    repoURL: https://github.com/my-org/my-repo
    path: manifests/my-app
    targetRevision: HEAD
```

#### manifest-generate-paths annotation

The `argocd.argoproj.io/manifest-generate-paths` annotation on an Application
tells ArgoCD which repository paths should trigger a manifest regeneration when
a webhook event fires. Without it, every push to the repo triggers a refresh
for all applications, regardless of what changed.

```yaml
metadata:
  annotations:
    argocd.argoproj.io/manifest-generate-paths: /manifests/my-app
```

Multiple paths are separated by `;`. With raw manifests the path is explicit
and predictable (the directory containing the YAMLs). With Helm, the scope is
harder to narrow down because values files and chart dependencies may live
across multiple locations.

This annotation is one of the strongest performance arguments for raw
manifests in large monorepos with many ArgoCD Applications.

<https://argo-cd.readthedocs.io/en/stable/operator-manual/high_availability/#webhook-and-manifest-paths-annotation>

### FluxCD

FluxCD uses dedicated CRDs for each approach:

- `Kustomization` CR for raw manifests (with optional Kustomize processing)
- `HelmRelease` CR for Helm charts managed by the helm-controller

## Rendered Manifest Pattern

The recommended GitOps approach: render all templates in CI and commit the
resulting plain YAML to Git. The GitOps operator syncs those static files —
no rendering happens at deploy time.

```shell
# CI pipeline: render once, commit the output
helm template my-release my-chart -f values-prod.yaml > manifests/my-app.yaml
# or
kustomize build overlays/production > manifests/my-app.yaml
```

- Helm and Kustomize act as **CI rendering tools**, not as deploy tools
- `manifest-generate-paths` paths are trivially precise: the rendered folder
- Pull request diffs show exact manifest changes, not template diffs
- Rollback is a `git revert` on the rendered files — no Helm state involved

See [get-raw-yaml](get-raw-yaml.md) for rendering commands.

## Recommendations

- Use the **rendered manifest pattern** as the primary GitOps approach
- Use Helm or Kustomize as **CI rendering tools**, committing plain YAML to Git
- Avoid `kubectl apply` or `helm install` in a GitOps workflow — these are
  imperative and bypass Git as the source of truth
