# ServerSideApply

There are 2 ways to apply manifests in kubernetes. Client-Side and Server-Side

## Client-Side Apply in kubernetes

By default kubectl apply uses the traditional client-side way.

The full desired state is stored in the `kubectl.kubernetes.io/last-applied-configuration` annotation on the object. ArgoCD uses this annotation to compute diffs and detect drift. This approach has a hard limit: **annotations cannot exceed 262144 bytes (256KB)**. Large CRDs with complex specs will hit this limit and fail to apply.

## Server-Side Apply in kubernetes

It became GA in kubernetes 1.22 as a new object merge algorithm, as well as tracking of field ownership, running on the Kubernetes API server.

Server-Side Apply allows multiple "managers" (e.g., ArgoCD, kubectl, other controllers) to declaratively manage different parts of a resource's configuration.
Each manager owns specific fields in the resource's manifest.
The Kubernetes API server tracks which manager owns which fields in the resource's spec. This is called field ownership.
When a manager applies changes, only the fields it owns are updated, leaving fields owned by other managers untouched.
If two managers attempt to modify the same field, the API server detects the conflict and rejects the change unless explicitly forced.

To see what "manager" controls what fields we can use this:

```shell
kubectl get RESOURCE RESOURCENAME --show-managed-fields -o yaml
```

## ServerSideApply in argocd

- Resource exceeds the 262144 bytes annotation limit (common with large CRDs).
- Patching resources not fully managed by ArgoCD.
- More declarative field-ownership tracking instead of last-applied-state tracking.
- Improved merge behavior: changes by other controllers (e.g. HPA) are not overwritten by ArgoCD unless it owns those fields.
- Conflict detection: ArgoCD reports conflicts when another manager modifies fields it is also trying to manage.
- Declarative ownership: explicit per-field responsibility makes multi-tool management auditable.
- CRD compatibility: required for certain advanced controllers that rely on field ownership.
- Conflict risk: multiple tools modifying the same fields can cause conflicts if not carefully managed.
- API server load shift: merging moves from ArgoCD to the API server.

## Enable ServerSideApply in argocd

### At Application controller level

We can enable server side apply with the param **--server-side-diff-enabled** in the argocd-application-controller, or with the following setting in the argocd-cmd-params-cm configMap

```yaml
controller.diff.server.side: true # false by default
```

Enables the server side diff feature at the application controller level. Diff calculation will be done by running a server side apply dryrun (when diff cache is unavailable)

### At Application level

SSA can be enabled per ArgoCD Application using `syncOptions`:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
spec:
  syncPolicy:
    syncOptions:
      - ServerSideApply=true
```

### At resource level

The most surgical approach: annotate only the specific resources that need SSA, leaving all others on client-side apply. This is the recommended pattern when SSA is needed only because of large CRDs hitting the annotation limit.

> **Note — force-conflicts is automatic:** ArgoCD unconditionally runs `kubectl apply --server-side --force-conflicts` whenever SSA is enabled, whether at Application level or via resource annotation. Field ownership conflicts from previous client-side apply managers are resolved automatically on the first SSA sync — no manual `kubectl` intervention needed.

```yaml
metadata:
  annotations:
    argocd.argoproj.io/sync-options: ServerSideApply=true
```

To apply SSA only to CRDs when deploying manifests that include them (e.g. via kustomize), use a patch so the rest of the resources continue using client-side apply:

```yaml
patches:
  - patch: |-
      apiVersion: apiextensions.k8s.io/v1
      kind: CustomResourceDefinition
      metadata:
        name: placeholder
        annotations:
          argocd.argoproj.io/sync-options: ServerSideApply=true
    target:
      kind: CustomResourceDefinition
```

## Diff noise on non-declared fields

Enabling SSA — whether globally or per resource — can surface diffs on fields that were never declared in Git.

### Root cause

With SSA, the Kubernetes API server or mutating admission webhooks may inject default values into fields not declared in the manifest (e.g. `weight: 1` on a single-backend Istio route). These fields are owned by a different field manager (the webhook or the API server), not by ArgoCD. ArgoCD sees the live object has a value that is absent from the desired state and reports drift. This was less visible with client-side apply because the diff was based solely on the last-applied annotation, which only contained what ArgoCD had explicitly set.

### Solutions

#### Option 1 — Declare the field explicitly (cleanest)

Add the defaulted value to your manifest so the desired and live states match:

```yaml
    weight: 1
```

#### Option 2 — ignoreDifferences with a JSON pointer

```yaml
spec:
  ignoreDifferences:
    - group: networking.istio.io
      kind: VirtualService
      jsonPointers:
        - /spec/http/*/route/*/weight
```

**Option 3 — ignoreDifferences scoped to a specific field manager** (ArgoCD 2.7+)

```yaml
spec:
  ignoreDifferences:
    - group: networking.istio.io
      kind: VirtualService
      managedFieldsManagers:
        - istio-pilot
```

### Typical progression when adopting SSA for large CRDs

```text
Large CRD hits the 262144 annotation limit
        ↓
Enable SSA only on the affected resources (annotation or kustomize patch)
        ↓
Gain: large CRDs apply successfully
Loss: diff noise appears on fields defaulted by webhooks or the API server
        ↓
Add ignoreDifferences rules or declare the fields explicitly to compensate
```

## Links

- [Server-Side Apply](https://kubernetes.io/docs/reference/using-api/server-side-apply/)
- [Server-Side Apply support for ArgoCD (proposal)](https://argo-cd.readthedocs.io/en/stable/proposals/server-side-apply/)
- [ServerSideApply argocd sync option](https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/#server-side-apply)
