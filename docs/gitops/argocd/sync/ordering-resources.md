# Ordering resources during a sync operation

To order the synchronization of resources, ArgoCD takes several factors into account.
Listed from highest to lowest priority:

- Resource phase
- Resource wave
- Resource type
- Resource name

> Before starting the actual synchronization, ArgoCD performs a dry-run.

## Resource Phases

ArgoCD has 3 execution phases:

- Pre-Sync
- Sync
- Post-Sync

By default, all objects use the "Sync" phase, but it can be specified on the
object using one of these annotations:

- argocd.argoproj.io/hook: PreSync
- argocd.argoproj.io/hook: Sync
- argocd.argoproj.io/hook: PostSync

> The PreSync and PostSync phases are used to specify hooks, intended for
> running tasks before or after the synchronization.

## Resource Waves

Waves are a way to order resources within the same phase.
By default, the wave of a resource is 0, but it can be changed using the
annotation:

```txt
argocd.argoproj.io/sync-wave: "wave-number"
```

The wave number can be positive or negative, where negative numbers are applied
first. This is an example of wave ordering:

```txt
-4
-1
0 (default)
1
3
```

## Resource Type

Within the same wave, ArgoCD takes the resource type into account for ordering.
The applied order can be seen here:

<https://github.com/argoproj/gitops-engine/blob/master/pkg/sync/sync_tasks.go>

> Custom resources (i.e., object types added via custom resource definitions)
> are not included in this order and will be applied at the end of the wave.

## Resource Name

Within the same wave and resource type, resources are ordered alphabetically by
name.

## Final Order

- Execution of the Pre-Sync phase, ordering resources by wave number.
  Within each wave, ordered by resource type.
  If resources of the same type exist within that wave, they are ordered by
  name.

- Execution of the Sync phase, ordering resources by wave number.
  Within each wave, ordered by resource type.
  If resources of the same type exist within that wave, they are ordered by
  name.

- Execution of the PostSync phase, ordering resources by wave number.
  Within each wave, ordered by resource type.
  If resources of the same type exist within that wave, they are ordered by
  name.

## Considerations

- Regarding resource health:
  ArgoCD does not advance to the next step in the order until the previous one
  has completed successfully (health check).
  ArgoCD knows how to check health for base Kubernetes resources (deployments,
  jobs, services, etc.) and some additional CRDs.
  For CRDs it does not know how to check, custom health checks can be added via
  Lua scripts, though the process is quite cumbersome.

## Links

- Sync and waves
  <https://argo-cd.readthedocs.io/en/stable/user-guide/sync-waves/>

- Hooks
  <https://argo-cd.readthedocs.io/en/stable/user-guide/resource_hooks/>

- Mastering Argo CD Sync Waves: A Deep Dive into Effective GitOps
  Synchronization Strategies
  <https://www.youtube.com/watch?v=LKuRtOTvlXk>

- Resource health
  <https://argo-cd.readthedocs.io/en/stable/operator-manual/health/>

- Resource health added for custom resource definitions
  <https://github.com/argoproj/argo-cd/tree/master/resource_customizations>
