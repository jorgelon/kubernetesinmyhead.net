# .argocd-source.yaml

The `.argocd-source.yaml` file is a special file placed in the source application directory inside the Git repository. ArgoCD reads it during manifest generation and merges its content with the application source fields defined in the `Application` manifest.

!!! warning "GitOps purity and vendor lock-in"
    The ArgoCD documentation itself flags parameter overrides as *"an anti-pattern to GitOps"*, because the effective source of truth becomes a union of the Git repository and the override state — not Git alone. Additionally, this file is an ArgoCD-specific convention: a plain `kustomize build` or any other toolchain will silently ignore it, coupling the repository to ArgoCD internals.

    The most GitOps-aligned use is the **write-back** pattern with argocd-image-updater, where automated tooling commits updated values back to Git through this file. Avoid using it as a general-purpose override mechanism in production.

## Use Cases

It solves two main problems:

- **Write-back**: Provides a unified Git-native way to override application parameters, enabling tools like [argocd-image-updater](https://argocd-image-updater.readthedocs.io/) to write updated image tags back to the repository without modifying the `Application` manifest directly.
- **Application discovery**: Supports discovering applications in Git repositories for projects like ApplicationSet (see [git files generator](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Generators-Git/)).

## File Naming

| Scenario                                       | Filename                                    |
|------------------------------------------------|---------------------------------------------|
| Shared overrides for all apps at a path        | `.argocd-source.yaml`                       |
| Overrides for a specific app                   | `.argocd-source-<appname>.yaml`             |
| Specific app + `apps-in-any-namespace` feature | `.argocd-source-<namespace>_<appname>.yaml` |

When both a generic `.argocd-source.yaml` and an app-specific file exist, the generic file is merged first, then the app-specific file is merged on top (allowing per-app overrides).

## Content

The file supports the same fields as the `source` section of an `Application` manifest. Only the tool-specific override fields are relevant here.

### Kustomize

Each entry in `images` is a string following the `kustomize edit set image` syntax. ArgoCD matches images by the **left-hand side** (the original image name) and applies the override. Multiple images from the same app can be listed, one per entry:

| Format                  | Effect                              |
|-------------------------|-------------------------------------|
| `image:newTag`          | Override only the tag               |
| `image=newImage`        | Rename the image, keep original tag |
| `image=newImage:newTag` | Rename and override the tag         |
| `image=newImage@digest` | Rename and pin to a digest          |

```yaml
kustomize:
  images:
    - nginx:1.27.0                              # override tag only
    - postgres=my-registry/postgres:15-alpine   # rename + tag
    - myapp=myapp@sha256:abc123def456           # rename + pin digest
    - sidecar=quay.io/myorg/sidecar:v2.0.0     # different registry + tag
```

A deployment with containers `nginx`, `postgres`, `myapp`, and `sidecar` would have each image matched and replaced independently.

Override the Kustomize version (ArgoCD v3.2+):

```yaml
kustomize:
  version: v4.5.7
```

### Helm

Override Helm parameters:

```yaml
helm:
  parameters:
    - name: image.tag
      value: v1.2.3
    - name: replicaCount
      value: "3"
```

Override values inline:

```yaml
helm:
  values: |
    image:
      tag: v1.2.3
    replicaCount: 3
```

Override value files:

```yaml
helm:
  valueFiles:
    - values-prod.yaml
```

## Merge Behavior

ArgoCD **merges** the content of `.argocd-source.yaml` into the `Application` spec at render time. Fields present in the file override the corresponding fields in the `Application` manifest. Fields absent in the file remain as defined in the manifest.

## Links

- Parameter overrides documentation
  <https://argo-cd.readthedocs.io/en/stable/user-guide/parameters/#store-overrides-in-git>
- argocd-image-updater write-back
  <https://argocd-image-updater.readthedocs.io/en/stable/basics/update-methods/>
