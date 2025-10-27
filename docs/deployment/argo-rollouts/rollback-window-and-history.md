# Rollback window and history limit

## Rollback window

spec.rollbackWindow determines the number of revisions to consider in an automatic rollback

In this example argo rollouts will monitor the last three revisions in order to rollback automatically to the last known good revision within the rollback window.

```yaml
spec:
  rollbackWindow:
    revisions: 3
```

The rollback window provides a way to fast track deployments to previously deployed versions (default not set)

## History limit

spec.revisionHistoryLimit determines the number of old ReplicaSets to retain for the purpose of rollback (default 10)

In this example, Argo Rollouts will keep the last three ReplicaSets that were created by the Rollout. If a Rollout is rolled back, it will revert to an older ReplicaSet. This does not affect the running Pods, but it does allow you to rollback to a previous version of your application if something goes wrong.

```yaml
spec:
  revisionHistoryLimit: 3
```

> On clusters with thousands of rollouts memory usage for the argo-rollouts operator can be reduced significantly by changing RevisionHistoryLimit from the default of 10 to a lower number. One user of Argo Rollouts saw a 27% reduction in memory usage for a cluster with 1290 rollouts by changing RevisionHistoryLimit from 10 to 0.

## Links

<https://argo-rollouts.readthedocs.io/en/stable/FAQ/#rollbacks>
<https://argo-rollouts.readthedocs.io/en/stable/features/rollback/>
<https://argo-rollouts.readthedocs.io/en/stable/features/specification/>
<https://argo-rollouts.readthedocs.io/en/stable/best-practices/>
