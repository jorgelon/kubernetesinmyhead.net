# Sync and compare options

## Sync options

Argocd offer several sync options to configure the Sync process.

This options can be configured at application level, resource level, or both

### At application level

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook
spec:
  syncPolicy:
    syncOptions:
    - OPTION=VALUE
```

### At resource level

At resource level is made using an annotation in the resource. Multiple options can be configured comma separated.

```yaml
metadata:
  annotations:
    argocd.argoproj.io/sync-options: OPTION1=VALUE,OPTION2=VALUE
```

Multiple Sync Options can be configured

## List of sync options

|                             | Explanation                                                                                           |
|-----------------------------|-------------------------------------------------------------------------------------------------------|
| ApplyOutOfSyncOnly          | Only sync OutOfSync resources. Specially relevant in big applications or low resource api servers     |
| CreateNamespace             | Create the spec.destination.namespace namespace. Useful with spec.syncPolicy.managedNamespaceMetadata |
| Delete                      | Configures how a resource will be deleted after the application is deleted                            |
| FailOnSharedResource        | Makes the sync process fail if a resource is managed by other argocd application                      |
| Force                       | Force=true,Replace=true deletes and recreate a resource at every sync                                 |
| Prune                       | Prune resources not declared in the target state but they exist in the application                    |
| PruneLast                   | Moves the prune process at the end of the sync operation                                              |
| PrunePropagationPolicy      | Permits to choose the garbage collection (foreground,background or orphan)                            |
| Replace                     | Converts kubectl apply operation in a kubectl replace or kubectl create operation                     |
| RespectIgnoreDifferences    | Used spec.ignoreDifferences also in the sync process. Don't sync/correct that fields                  |
| ServerSideApply             | With true, we pass --server-side=true parameter to kubectl                                            |
| SkipDryRunOnMissingResource | Ignores if a resource to be created does not have its CRD                                             |
| Validate                    | With false, we pass --validate=false to kubectl                                                       |

## Notes

- Replace=true takes precedence over ServerSideApply=true.
- Prune=false Prevents a resource from being pruned
- Prune=confirm Requires manual confirmation before pruning
- Delete=false Don't delete the resource from the cluster during app deletion
- Delete=confirm Requires manual confirmation before deletion
- RespectIgnoreDifferences sync option is only effective when the resource is already created in the cluster. If the Application is being created and no live state exists, the desired state is applied as-is

## Links

- Sync Options

<https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/>

- Garbage Collection

<https://kubernetes.io/docs/concepts/architecture/garbage-collection/>
