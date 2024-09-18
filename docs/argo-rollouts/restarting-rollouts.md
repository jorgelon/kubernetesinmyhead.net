# Restarting rollouts

## Restart the rollout

Using the kubectl plugin

```shell
kubectl argo rollouts restart -n NAMESPACE_NAME ROLLOUT_NAME
```

This deletes the pods of the current rollout. The deployment controller will replace them without creating a new replicaset

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
