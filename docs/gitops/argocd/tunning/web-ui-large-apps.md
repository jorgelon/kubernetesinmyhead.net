# Web UI performance with large applications

When an ArgoCD application manages a large number of resources, the browser UI can become slow
or unresponsive due to the volume of data sent from the API server to the frontend and the
number of nodes rendered in the resource graph.

## Resource Exclusions

The most effective way to reduce browser UI load is to exclude high-churn, high-volume
resource types that are typically not managed via GitOps.

ArgoCD v3.0 ships with a set of default exclusions. The full default list introduced in v3.0 covers `ReplicaSet`, `CiliumEndpoint`,
`CiliumIdentity`, and Kyverno/cert-manager report CRDs. See the upgrade notes:

<https://argo-cd.readthedocs.io/en/stable/operator-manual/upgrading/2.14-3.0>

> Excluded resources are not tracked by ArgoCD at all — they will not appear in the UI
> resource graph, will not be synced, and will not be diffed. Only exclude types that
> ArgoCD should not own.

## ignoreResourceUpdates

High-churn fields like `status` or `lastProbeTime` cause ArgoCD to mark resources as
changed frequently, which increases reconcile pressure and how often the UI reloads state.

> ArgoCD v3.0 ships with `/status` exclusion enabled by default for common Kubernetes
> resources. On v2.x this must be configured manually.

To apply globally across all tracked resources on v2.x:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  resource.customizations.ignoreResourceUpdates.all: |
    jsonPointers:
    - /status
```

Or per resource kind:

```yaml
data:
  resource.customizations.ignoreResourceUpdates.batch_Job: |
    jsonPointers:
    - /status
  resource.customizations.ignoreResourceUpdates.Pod: |
    jsonPointers:
    - /status
```

Reference: <https://argo-cd.readthedocs.io/en/stable/operator-manual/reconcile/>

## Selective Sync (ApplyOutOfSyncOnly)

See [Tune reconciliation](../reconciliation/01-tune-reconciliation.md) for details and
important caveats (**no history**, **no rollback**, **hooks do not run**).

## Server-side pagination

The ArgoCD API server loads the full application list into memory and sends it to the
browser in one shot. This becomes a bottleneck beyond ~2000 applications. Check whether
your ArgoCD version supports server-side pagination on the applications list and watch APIs,
which reduces the payload transferred to the browser.

## Workqueue rate limiting

For environments with many applications being reconciled simultaneously, a global rate
limiter on the application controller workqueues avoids spikes that make the UI appear
slow:

```bash
# application-controller deployment env vars
WORKQUEUE_BUCKET_SIZE=500
WORKQUEUE_BUCKET_QPS=300
```

Reference: <https://argo-cd.readthedocs.io/en/stable/operator-manual/high_availability/>

## Links

- Resource Exclusions: <https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#resource-exclusioninclusion>
- Reconcile Optimization: <https://argo-cd.readthedocs.io/en/stable/operator-manual/reconcile/>
- High Availability: <https://argo-cd.readthedocs.io/en/stable/operator-manual/high_availability/>
- v3.0 default exclusions: <https://argo-cd.readthedocs.io/en/stable/operator-manual/upgrading/2.14-3.0>
