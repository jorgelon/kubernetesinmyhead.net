# Application Health

ArgoCD monitors the health of every resource in an application and aggregates that
into an overall application health status.

The official documentation: <https://argo-cd.readthedocs.io/en/stable/operator-manual/health/>

## Health Statuses

### Healthy

All resources are running and meeting their expected conditions. For example, a Deployment
has reached its desired replica count and all pods are ready.

### Progressing

The resource is not healthy yet but is still making progress and might become healthy
soon. This is a transitional state, typically seen during rolling updates or pod restarts.

A common scenario is an application stuck in `Progressing` permanently. This usually
means a pod cannot be scheduled or a container keeps crashing. See the FAQ:
<https://argo-cd.readthedocs.io/en/stable/faq/#why-is-my-application-stuck-in-progressing-state>

### Degraded

The resource has failed or is not meeting its desired state. Examples include a Deployment
where pods are crash-looping, or a StatefulSet with unavailable replicas.

### Suspended

The resource is suspended and waiting for an external event to resume it. Typical examples:

- A `CronJob` that has been suspended (`spec.suspend: true`)
- A `Deployment` or `Rollout` that has been paused

### Missing

The resource is defined in Git but does not exist in the cluster. This happens when ArgoCD
has not yet synced the application, or when a resource was manually deleted from the cluster.

## Resource Health Customizations

ArgoCD has built-in health checks for core Kubernetes resources (Deployments, StatefulSets,
DaemonSets, Ingress, PVCs, etc.). However, Kubernetes is highly extensible through Custom
Resource Definitions (CRDs), and ArgoCD cannot know by default how to evaluate the health
of a custom resource.

To address this, ArgoCD supports **resource health customizations** — Lua scripts that define
how to compute the health of any resource, including CRDs.

### The `resource_customizations` repository

The ArgoCD project maintains a community-contributed folder with health checks, actions,
and other customizations for popular operators and CRDs:

<https://github.com/argoproj/argo-cd/tree/master/resource_customizations>

Each subdirectory is organized by API group and kind, for example:

```text
resource_customizations/
  external-secrets.io/
    ExternalSecret/
      actions/refresh/action.lua
      health.lua
  argoproj.io/
    Rollout/
      health.lua
  cert-manager.io/
    Certificate/
      health.lua
```

#### Examples

Health check for an Argo Rollout:
<https://raw.githubusercontent.com/argoproj/argo-cd/master/resource_customizations/argoproj.io/Rollout/health.lua>

Refresh action for an ExternalSecret (External Secrets Operator):
<https://raw.githubusercontent.com/argoproj/argo-cd/master/resource_customizations/external-secrets.io/ExternalSecret/actions/refresh/action.lua>

### Adding custom health checks

If your organization has internal CRDs, you can define custom health checks in the ArgoCD
`ConfigMap`. Add a Lua script under `resource.customizations.health.<group_kind>` in
`argocd-cm`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
  namespace: argocd
data:
  resource.customizations.health.example.com_MyResource: |
    hs = {}
    if obj.status ~= nil then
      if obj.status.phase == "Running" then
        hs.status = "Healthy"
        hs.message = obj.status.message
        return hs
      end
      if obj.status.phase == "Failed" then
        hs.status = "Degraded"
        hs.message = obj.status.message
        return hs
      end
    end
    hs.status = "Progressing"
    hs.message = "Waiting for resource to be ready"
    return hs
```

> If your company has created Kubernetes CRDs for internal applications, contributing or
> configuring health checks improves ArgoCD's ability to accurately reflect application
> state and enables operators to act on real health signals.
