# Restarting rollouts

## Restart the rollout

Using the kubectl plugin

```shell
kubectl argo rollouts restart -n NAMESPACE_NAME ROLLOUT_NAME
```

> Argocd has an embedded action that permits to restart a rollout

### Notes about the restart

- Eviction  
This deletes the pods of the current rollout using the eviction api.  
The deployment controller will replace them without creating a new replicaset.  
Because argo rollouts uses the eviction api, this respects the existing PodDisruptionBudgets.  
Also, a rollout with a single replica causes downtime.

- Speed  
The speed can be specified with spec.maxUnavailable setting in the rollout spec.

- Schedule  
It is possible to schedule a restart with the **.spec.restartAt** field

### Order

The restart order is:

- First the stable replica set
- Second, the current replica set
- Finally all other ReplicaSets beginning with the oldest

### With stakater reloader

If we want to restart a rollout the same way with stakater reloader when a configmap or secret changes, we have to:

- enable argo rollouts restart with isArgoRollouts: true
- use at least the 1.1.0 release of stakater reloader
- use the single resource specification of the rollout (spec.template). Using spec.workloadRef currently crashes the controller

## If using workloadRef

If we are using spec.workloadRef instead of spec.template we can restart the rollout the same way, but we can also restart the referenced deployment with this command.

```shell
kubectl rollout restart -n NAMESPACE_NAME DEPLOYMENT NAME
```

But this generates a new replicaset and a new revision in the rollout

> The deployment name must be the deployment created by the rollout, not the deployment defined in the deployment resource itself.

## Links

- Restarting Rollout Pods
<https://argo-rollouts.readthedocs.io/en/stable/features/restart/>

- Stakater Reloader  
<https://github.com/stakater/Reloader>

- [BUG] Restarting a rollout with workloadRef crashes the operator pod #751  
<https://github.com/stakater/Reloader/issues/751>

- Argocd rollout restart action  
<https://github.com/argoproj/argo-cd/tree/master/resource_customizations/argoproj.io/Rollout/actions/restart>
