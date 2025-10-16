# Tune reconciliation

## timeout.reconciliation

When deploying many Applications, the reconciliation default values can cause high cpu / memory consuption. To avoid it we can increase the timeout.reconciliation value to a greater value (12h, 24h) or disabling it (0)

> Changing this value needs to restart the Application controller and the repo server

If you set timeout.reconciliation to 0 or a big value, then Argo CD will stop polling Git repositories automatically at every 3 minutes so it is recommended to use alternative methods such as webhooks, for example, when a new commit is pushed to a git repository to tell the reposerver to recheck if there are changes

### Setting the Application webhook

If the git repository does not trigger Applications using Applicationsets, expose only the argocd api (argocd server) and create a webhook for <https://myargocd/api/webhook>

```txt
service: argocd-server
port: 443
name: https
```

What this Application webhook does:

- It triggers a normal refresh to the Applications
- Uses intelligent filtering: Only triggers refresh if the webhook event matches the application's source repository and if the changed files match the application's refresh paths (if configured). See manifest-generate-paths for more tunning.
- This is defined in [webhook.go](https://github.com/argoproj/argo-cd/blob/master/util/webhook/webhook.go) and in [application_annotations.go](https://github.com/argoproj/argo-cd/blob/master/pkg/apis/application/v1alpha1/application_annotations.go).

### Setting the Applicationset webhook

If the git repository triggers Applications using Applicationsets, also expose the Applicationset controller and create a webhook for <https://Applicationseturl/api/webhook>

```txt
service: argocd-applicationset-controller
port: 7000
name: webhook
```

What this Applicationset webhook does:

- It makes an annotation **argocd.argoproj.io/application-set-refresh** to the Applicationset.
- This is defined [in webhook.go](https://raw.githubusercontent.com/argoproj/argo-cd/refs/heads/master/Applicationset/webhook/webhook.go) and [common.go](https://github.com/argoproj/argo-cd/blob/master/common/common.go)
- This annotation makes the applicationset re-evaluate generators (like Git files generator).

Links

- <https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/services/webhook/>
- <https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Generators-Git/#webhook-configuration>
- [See more info here](gitlab-webhook.md)

## manifest-generate-paths

Another great setting is using manifest-generate-paths. We can tell argocd Applications to only trigger a refresh is the changes are detected in one or more paths of the github repository.

This can be done adding the argocd.argoproj.io/manifest-generate-paths label to the Applications

```txt
argocd.argoproj.io/manifest-generate-paths: .
```

This only will trigger a refresh when the changes are detected in the path the Application has been declared. We can configure more paths comma separated.

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
