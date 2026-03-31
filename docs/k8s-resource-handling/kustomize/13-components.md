# Components

Kustomize components (`kind: Component`) are reusable, modular units of configuration that represent **optional features**. They allow you to package patches, generators, and resources into a self-contained unit that can be selectively included in any overlay.

Available since kustomize v3.7.0.

## The problem they solve

When an application has N optional features and M deployment scenarios, maintaining separate overlays for every combination is unsustainable.

Example: an app with three optional features (external DB, LDAP, reCAPTCHA) deployed in three variants:

| Variant    | External DB | LDAP | reCAPTCHA |
|------------|-------------|------|-----------|
| Community  |             |      |           |
| Enterprise | x           | x    | x         |
| Dev        | x           |      | x         |

Without components, patches for "external DB" and "reCAPTCHA" must be duplicated across Enterprise and Dev overlays. With components, each feature lives in its own directory and overlays simply list which ones to include.

## Components vs overlays

| Aspect             | Overlays                                       | Components                                                               |
|--------------------|------------------------------------------------|--------------------------------------------------------------------------|
| Execution          | Independent — each clones and extends its base | Sequential — each receives and transforms the parent's accumulated state |
| Resource ownership | Must declare their own resources               | Can patch resources they do not own                                      |
| Purpose            | Environment-specific full configurations       | Optional, cross-cutting features for a subset of environments            |
| Reference field    | `resources:`                                   | `components:`                                                            |

## Structure

```text
project/
  base/
    deployment.yaml
    kustomization.yaml        # kind: Kustomization
  components/
    external_db/
      kustomization.yaml      # kind: Component
      deployment-patch.yaml
      dbpass.txt
    monitoring/
      kustomization.yaml      # kind: Component
      metrics-patch.yaml
  overlays/
    community/
      kustomization.yaml
    enterprise/
      kustomization.yaml
    dev/
      kustomization.yaml
```

## Component kustomization.yaml

```yaml
apiVersion: kustomize.config.k8s.io/v1alpha1
kind: Component

secretGenerator:
  - name: dbpass
    files:
      - dbpass.txt

configMapGenerator:
  - name: app-conf
    behavior: merge          # merges with the base ConfigMap
    literals:
      - DB_HOST=127.0.0.1

patches:
  - path: deployment-patch.yaml
    target:
      kind: Deployment
      name: myapp
```

A component supports the same fields as a regular kustomization: `resources`, `patches`, `secretGenerator`, `configMapGenerator`, `images`, etc. The only difference is the header — `apiVersion: kustomize.config.k8s.io/v1alpha1` and `kind: Component` instead of `v1beta1` / `kind: Kustomization`.

## Referencing from overlays

Overlays use the dedicated `components:` field — **not** `resources:`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../base

components:
  - ../../components/external_db
  - ../../components/monitoring
  # - ../../components/ldap     # disabled — comment/uncomment to toggle
```

Order matters — components are applied sequentially, and each one sees the state left by the previous one.

## When to use components vs resources

The decision comes down to whether the feature **patches resources it doesn't own**.

| Situation                                                             | Use                                                       |
|-----------------------------------------------------------------------|-----------------------------------------------------------|
| Feature only adds new resources (ServiceMonitors, dashboards, rules)  | `resources:` — components add no value                    |
| Feature patches resources declared in the base or by other components | `components:` — this is the core use case                 |
| Feature is toggled across environments but only adds resources        | Either works; `components:` is more explicit about intent |

**Example:** a cilium monitoring bundle that only adds ServiceMonitors and GrafanaDashboards brings no technical benefit from being a component — it adds nothing to resources it doesn't own. Listing it under `resources:` is equivalent.

**Example:** a CRD annotation patch that sets `argocd.argoproj.io/sync-options: ServerSideApply=true` on every `CustomResourceDefinition` is a perfect component — it patches resources it doesn't own and needs to be selectively applied across environments without duplicating the patch in each overlay.

## Patching component output from the parent overlay

The parent kustomization always has final say. Execution order:

1. Parent accumulates `resources:`
2. Components run sequentially
3. Parent's own `patches:`, `labels:`, `namePrefix:`, etc. are applied

Parent patches run after all components, so they can override or further modify anything a component introduced — including resources the component added.

## Limitations

- **Alpha API** — `v1alpha1` signals the semantics may still change.
- **Order-dependent** — items in `components:` are processed sequentially, unlike `resources:`.
- **No mixing fields** — components cannot be listed under `resources:`, and resources cannot be listed under `components:`.
- **Array index patches** — JSON6902 patches that target fixed array indices (e.g., `/spec/template/spec/volumes/0`) require coordination between components to avoid conflicts.
- **ConfigMap merges** — components contributing to a shared ConfigMap must use `behavior: merge`, otherwise a duplicate resource error is raised.

## Links

- Kustomize components example

<https://github.com/kubernetes-sigs/kustomize/blob/master/examples/components.md>

- KEP 1802: Kustomize Components

<https://github.com/kubernetes/enhancements/blob/master/keps/sig-cli/1802-kustomize-components/README.md>
