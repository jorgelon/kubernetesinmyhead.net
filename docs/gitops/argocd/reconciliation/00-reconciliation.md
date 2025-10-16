# Reconciliation

## Application sources

Argocd permits to define 3 repository types (Application sources) and we can use them to define the desired state of the cluster:

- Git repositories
- Helm repositories
- Oci registries

## What is the reconciliation process

The reconcilation is a discovery process where some tasks are done:

- argocd-repo-server checks if there are changes in the application sources (and update the stored cache)
- argocd-repo-server generates the final manifests (desired state)
- argocd-application-controller checks if there are differences with the live state (drift detection)

> If there are any Git changes, Argo CD will only update applications with the auto-sync setting enabled

## argocd-repo-server operations

### Recheck repository and store in cache

argocd-repo-server checks every certain time if there are changes in the Application source (repository) and stores the most recent one in the redis cache

The frequency is controlled this way:

```txt
CLI parameter: --revision-cache-expiration
Default: 3m
Setting: timeout.reconciliation in argocd-cm ConfigMAp
ENV: ARGOCD_RECONCILIATION_TIMEOUT
```

- In a **git source** checks if the latest commit SHA for the desired branch/tag has changed
- In a helm source, checks for the index.yaml file
- In an OCi repository checks the tag list

### Render manifests and store in cache

Using that Application source cache, the argocd-repo-server:

- Generates the final manifests that represents the desired (target) state using the  the proper tool (kustomize, helm template, ...)
- Stores them in the redis cache.

This is done for every application and returns the generated manifests to the application-controller.

It is possible to control the expiration of that cache with this:

```txt
CLI parameter: --repo-cache-expiration  
Default: 24h
Setting: reposerver.repo.cache.expiration  in argocd-cmd-params-cm ConfigMAp
ENV: ARGOCD_REPO_CACHE_EXPIRATION
```

> There is an additional  **per application** tunning that makes a new commit be ignored and consider our cache as valid, so no new manifests generation will be launched.
This is done via **argocd.argoproj.io/manifest-generate-paths** annotation, that tells argocd the paths in the git repo must change to trigger a new manifest generation in our application.

- Repo Server Cache Code

<https://github.com/argoproj/argo-cd/blob/master/reposerver/cache/cache.go>

- Command line

<https://argo-cd.readthedocs.io/en/stable/operator-manual/server-commands/argocd-repo-server/>

### Drift detection (application controller)

The application-controller compares that final manifests (desired/target state) with the live (real) state in the cluster in order to detect drift.

- If a drift is detected, the application is consideres "Out of Sync"
- Applying the desired state is part of the Sync process, not the reconciliation process and it can triggered automatically enabl AutoSync

In the application controller, the ARGOCD_RECONCILIATION_TIMEOUT (timeout.reconciliation in the argocd-cm ConfigMap) controls how often the application-controller checks all applications for drift, regardless of whether any changes occurred. This is:

- If no timeout.reconciliation is configured, the default value is 120s
- Valid values are duration strings (5m, 3h, 5d,..)
- A zero value disables this reconciliation operation
- The argocd-repo-server and argocd-application-controller must be restarted to apply this setting

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
- Undocummented behaviour accessing applications the web UI.

### Event driven automatic refresh

There is another mecanism where argocd application controller triggers a refresh.

Application-controller watches Kubernetes resources using watch APIs. When a resource's resourceVersion changes, triggers immediate reconciliation. We can see in the logs strings like "Requesting app refresh caused by object update".
This can cause high CPU with frequently-changing resources and it can be avoid enabling resource.ignoreResourceUpdatesEnabled in the argocd-cm ConfigMap, enabled by default since argocd 3.0

### Refresh settings table

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
