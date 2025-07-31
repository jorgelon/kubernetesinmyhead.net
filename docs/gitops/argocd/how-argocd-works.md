# How argocd works

Target / desired state:
Live / real state:

## Reconciliation / Refresh

The reconcilation is the process where the application controller checks if there are changes in the application sources and if there are differences with the live state.

The argocd controller triggers a reconciliation with a configured frequency. This is done because it has a setting that controlls the the maximum time that controller will wait until triggering a new refresh.

This setting is **timeout.reconciliation**, configured via argocd-cm configmap.

- The default value is 120 seconds
- Valid values are duration strings (5m, 3h, 5d,..)
- A zero value disables this reconciliation operation
- The argocd-repo-server and argocd-application-controller must be restarted to apply this setting

There are some situations where the reconciliation operation can be delayed because of a large number of applications. We can give more extra time to the refresh peration via the **timeout.reconciliation.jitter** setting.

- Valid values are duration strings (5m, 3h, 5d,..)
- A zero value disables the jitter
- The default value is 1 minute

Example: if the sync timeout is 3 minutes and the jitter is 1 minute, then the actual timeout will be between 3 and 4 minutes.

> The default timeout.reconciliation and timeout.reconciliation.jitter values makes the maximum period to be 3 minutes

### Other ways to trigger a reconciliation / Refresh

- Manually via argocd ui (refresh button)
- Using the argocd cli (argocd app get --refresh)
- Via a webhook (a change in the source notifies a change to argocd)
- Via argocd.argoproj.io/refresh=normal annotation to the application
- Using the api

### Cache and hard refresh

Argocd stores the target state in a cache.

#### Git source

In a git source, argocd checks the latest commit for the desired branch/tag, generates the final manifests (helm template, kustomize or plain yaml) and it stores them in the cache.

> If the commit SHA has not changed, it does not pull the git repo again.

We can also do an additional tunning **per application** that makes a new commit be ignored and consider our cache as valid, so no new manifests generation will be launched.

This is done via **argocd.argoproj.io/manifest-generate-paths** annotation, that tells argocd the paths in the git repo must change to trigger a new manifest generation in our application.

#### Helm source

In a helm source, argocd downloads the desired chart version, generates the final manifests via helm template and it stores them in the cache.

> If the desired chart version is the same, it does not download the chart again.

#### Hard refresh

We can invalidate that cache and force to get the git repo / helm chart again with a hard refresh

- Manually via argocd ui (refresh + hard button)
- Using the argocd cli (argocd app get --hard-refresh)
- Via argocd.argoproj.io/refresh=hard annotation to the application
- Using the api

## Sync

Once argocd has the rendered manifests for our application, the sync operation applies that manifests to our cluster. It is basically a **kubectl apply** operation.

### Autosync and selfHeal

By default that operation must be done manually

- Manually via argocd ui (sync button)
- Using the argocd cli (argocd app sync)
- Using the api

But we can enable to trigger an automated sync operation when changes in the sources modifies the rendered manifests, so a drift is detected. This is, when the application is in the OutOfSync state (not Error or Synced).

```yaml
spec:
  syncPolicy:
    automated: {}
```

- Autosync disables the posibility to use Rollback
- Enabling autosync makes timeout.reconciliation an timeout.reconciliation.jitter relevant for this operation
- Autosync has only 1 attempt per combinaion of commit SHA1 and application parameters

#### selfHeal

We can also trigger an automated sync operation when a drift is detected when the changes occur in the live clusters. This is called **selfHeal** and it can be enabled this way:

```yaml
spec:
  syncPolicy:
    automated:
      selfHeal: true
```

> We can control the time to wait until a selfHeal operation starts with "controller.self.heal.timeout.seconds" in the argocd-cmd-params-cm configmap. The default value is 5 seconds.

### live state cached

The controller.default.cache.expiration setting in ArgoCD controls how long the application controller caches the live state of Kubernetes resources (not the target/desired state from Git or Helm).
This cache is used to reduce the number of API calls to the Kubernetes API server and improve performance when no changes are detected

- Accepts Go duration strings (e.g., 10m, 1h, 24h).
- The default value is 24h0m0s
- It can be changed with controller.default.cache.expiration in the argocd-cmd-params-cm configmap
