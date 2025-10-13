# Reconciliation

## Concepts

Argocd permits to define 3 repository types (application sources) we can use to define the desired state of the cluster:

- Git repositories
- Helm repositories
- Oci registries

The reconcilation is a discovery process where:

- the argocd repo server checks if there are changes in the application sources (and update the stored cache)
- the argocd application generates the final manifests (desired state)
- the argocd application controller checks if there are differences with the live state (drift detection)

> If there are any Git changes, Argo CD will only update applications with the auto-sync setting enabled

## Argocd repo server

The argocd server binary has a parameter --revision-cache-expiration that controls the cache TTL for revision metadata that repo-server fetches from Git, Helm, and OCI registries. When that cache expires it stores a new one in redis.

- Git References (git ls-remote output):
  - Branch names → commit SHAs
  - Tag names → commit SHAs
  - HEAD → commit SHA
  - Used to resolve ambiguous revisions like "main" or "v1.0.0" to exact commit SHAs
- Helm Index (from Helm chart repositories)
  - Chart versions available
  - Chart metadata
  - Download URLs
- OCI Tags (from OCI registries)
  - Available image tags
  - Tag metadata

The default value for this setting is 3 minutes, but it can be overriden with the timeout.reconciliation setting in the argocd-cm ConfigMap, that is loaded with the ARGOCD_RECONCILIATION_TIMEOUT environment variable.

### Repo server settings table

| Concept                   | Default | Environment variable          | argocd-cm ConfigMap    | Binary                      |
|---------------------------|---------|-------------------------------|------------------------|-----------------------------|
| Revision Cache expiration | 180s    | ARGOCD_RECONCILIATION_TIMEOUT | timeout.reconciliation | --revision-cache-expiration |

### Repo Server References

- Repo Server Cache Code

<https://github.com/argoproj/argo-cd/blob/master/reposerver/cache/cache.go>

- Command line

<https://argo-cd.readthedocs.io/en/stable/operator-manual/server-commands/argocd-repo-server/>

## Application controller

### Manifest generation

The application controller uses that application source cache to generate the final manifests that represents the desired (target) state and stores them also in the redis cache. This is done for every application.

- Git source

In a **git source**, argocd checks the latest commit for the desired branch/tag, generates the final manifests (helm template, kustomize or plain yaml) and it stores them in the cache.

> If the commit SHA has not changed, it does not pull the cached git repo.

We can also do an additional tunning **per application** that makes a new commit be ignored and consider our cache as valid, so no new manifests generation will be launched.

This is done via **argocd.argoproj.io/manifest-generate-paths** annotation, that tells argocd the paths in the git repo must change to trigger a new manifest generation in our application.

- Helm source

In a helm source, argocd uses the cached chart version and it generates the final manifests via helm template

> If the desired chart version is the same, it does not download the chart again.

The Application cached manifests expire in redis after a day by default and it can be changed with the argocd-cmd-params-cm Configmap with **reposerver.repo.cache.expiration** setting.

This setting controls the cache expiration for repo state, including app lists, app details, manifest generation and revision meta-data and it makes to regenerate the manifests after 24 hours, so a periodic hard refresh is not needed most of the times.

> The default cache TTL for other cached data is controlled by reposerver.default.cache.expiration

### Settings

In the application controller, the ARGOCD_RECONCILIATION_TIMEOUT (timeout.reconciliation in the argocd-cm ConfigMap) controls how often the application-controller checks all applications for drift, regardless of whether any changes occurred. This is

- If no timeout.reconciliation is configured, the default value is 120s
- Valid values are duration strings (5m, 3h, 5d,..)
- A zero value disables this reconciliation operation
- The argocd-repo-server and argocd-application-controller must be restarted to apply this settingç
- Undocummented behaviour accessing applications the web UI.

### Jitter

There are some situations where the reconciliation operation can be delayed because of a large number of applications. We can give more extra time to the refresh operation via the **timeout.reconciliation.jitter** setting.

- Valid values are duration strings (5m, 3h, 5d,..)
- A zero value disables the jitter
- The default value is 60 seconds

> Example: if the sync timeout is 3 minutes and the jitter is 1 minute, then the actual timeout will be between 3 and 4 minutes. The default timeout.reconciliation and timeout.reconciliation.jitter values makes the maximum period to be 3 minutes

### Hard refresh

It is possible to ignore the cached application source when doing a refresh of an application. This is the hard refresh and it forces the repo server to regenerate the application source cache again.

This can be useful in some situations:

- Helm charts with code changes but same version
- External secrets (Vault, etc.) that don't trigger Git changes
- Registry updates where chart digest changes but version stays same
- Cache corruption or stuck sync states

> Hard refresh is an expensive operation as it rebuilds everything from scratch.

By default argocd doesn't do a hard refresh but we can trigger a hard refresh manually.

- Via argocd ui (refresh + hard button)
- Using the argocd cli (argocd app get --hard-refresh)
- Via argocd.argoproj.io/refresh=hard annotation to the application
- Using the api

We can also configure a periodic hard refresh. This is done at controller level with the **timeout.hard.reconciliation** setting in the argocd-cm Configmap.

### Other ways to trigger an Application refresh

- Manually via argocd ui (refresh button)
- Using the argocd cli (argocd app get --refresh)
- Via a webhook (a change in the source notifies a change to argocd)
- Via argocd.argoproj.io/refresh=normal annotation to the application
- Using the api

#### Event driver automatic refresh

There is another mecanism where argocd application controller triggers a refresh.

Application-controller watches Kubernetes resources using watch APIs. When a resource's resourceVersion changes, triggers immediate reconciliation. We can see in the logs strings like "Requesting app refresh caused by object update".
This can cause high CPU with frequently-changing resources and it can be avoid enabling resource.ignoreResourceUpdatesEnabled in the argocd-cm ConfigMap, enabled by default since argocd 3.0

#### Refresh settings table

| Concept        | Default | Environment variable               | argocd-cm ConfigMap           | Binary              |
|----------------|---------|------------------------------------|-------------------------------|---------------------|
| Normal refresh | 120s    | ARGOCD_RECONCILIATION_TIMEOUT      | timeout.reconciliation        | --app-resync        |
| Jitter         | 60s     | ARGOCD_RECONCILIATION_JITTER       | timeout.reconciliation.jitter | --app-resync-jitter |
| Hard refresh   |         | ARGOCD_HARD_RECONCILIATION_TIMEOUT | timeout.hard.reconciliation   | --app-hard-resync   |

### Application controller references

- Application Controller Code

<https://github.com/argoproj/argo-cd/blob/master/cmd/argocd-application-controller/commands/argocd_application_controller.go>

- Command line

<https://argo-cd.readthedocs.io/en/stable/operator-manual/server-commands/argocd-application-controller/>
