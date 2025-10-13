# Tune reconciliation

## timeout.reconciliation

When deploying many applications, the reconciliation default values can cause high cpu / memory consuption. To avoid it we can increase the timeout.reconciliation value to a greater value (12h, 24h) or disabling it (0)

> Changing this value needs to restart the application controller and the repo server

If you set timeout.reconciliation to 0 or a big value, then Argo CD will stop polling Git repositories automatically at every 3 minutes so it is recommended to use alternative methods such as webhooks, for example, when a new commit is pushed to a git repository

> It is also posible to create another webhook for the applicationset controller

[See more info here](gitlab-webhook.md)

## manifest-generate-paths

Another great setting is using manifest-generate-paths. We can tell argocd applications to only trigger a refresh is the changes are detected in one or more paths of the github repository.

This can be done adding the argocd.argoproj.io/manifest-generate-paths label to the applications

```txt
argocd.argoproj.io/manifest-generate-paths: .
```

This only will trigger a refresh when the changes are detected in the path the application has been declared. We can configure more paths comma separated.

> This does not work for helm registries

## Selective Sync (ApplyOutOfSyncOnly)

It is possible to reduce the calls to the kubernetes api server made by argocd syncing only the changed objects. This is called Selective Sync

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
...
spec:
  syncPolicy:
    syncOptions:
    - ApplyOutOfSyncOnly=true
```

But this has some counterparts

- The sync operation is not recorded in the history
- The rollback is not possible
- The hooks (not the git webhooks) dont run

## Links

- High Availability

<https://argo-cd.readthedocs.io/en/stable/operator-manual/high_availability/>

- Reconcile Optimization

<https://argo-cd.readthedocs.io/en/stable/operator-manual/reconcile/>

- Selective Sync

<https://argo-cd.readthedocs.io/en/stable/user-guide/selective_sync/>
