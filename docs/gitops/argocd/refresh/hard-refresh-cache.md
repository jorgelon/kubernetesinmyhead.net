# Hard refresh and cache expiration

A hard refresh invalidates the Application's cache and force to get the git repo / helm chart again and generate the final manifests
This can be useful in some situations:

- Helm charts with code changes but same version
- External secrets (Vault, etc.) that don't trigger Git changes
- Registry updates where chart digest changes but version stays same
- Cache corruption or stuck sync states

> Hard refresh is an expensive operation as it rebuilds everything from scratch.

## How to do a hard refresh

By default argocd doesn't do a hard refresh but we can trigger a hard refresh manually.

- Via argocd ui (refresh + hard button)
- Using the argocd cli (argocd app get --hard-refresh)
- Via argocd.argoproj.io/refresh=hard annotation to the application
- Using the api

And also enable a periodic hard refresh. This is done at controller level with the **--app-hard-resync** setting

> We can specify a timeout for hard refresh operations with the **timeout.hard.reconciliation** setting in the argocd-cm Configmap.

## About cache expiration

The Application cached manifests expire in redis after a day by default and it can be changed with the argocd-cmd-params-cm Configmap with **reposerver.repo.cache.expiration** setting.

This setting controls the cache expiration for repo state, including app lists, app details, manifest generation and revision meta-data and it makes to regenerate the manifests after 24 hours, so a periodic hard refresh is not needed most of the times.

> The default cache TTL for other cached data is controlled by reposerver.default.cache.expiration
