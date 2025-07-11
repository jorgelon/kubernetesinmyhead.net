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

|                             | Application level | Resource level |
|-----------------------------|-------------------|----------------|
| Validate                    |                   | X              |
| ServerSideApply             | X                 | X              |
| FailOnSharedResource        | X                 |                |
| CreateNamespace             | X                 |                |
| ApplyOutOfSyncOnly          | X                 |                |
| Replace                     | X                 | X              |
| Force                       | X                 | X              |
| Prune                       | X                 | X              |
| PrunePropagationPolicy      | X                 |                |
| PruneLast                   | X                 | X              |
| Delete                      |                   | X              |
| RespectIgnoreDifferences    |                   |                |
| SkipDryRunOnMissingResource |                   | X              |

### Validate

We can pass to "kubectl apply" the --validate=false parameter with this Sync option

### FailOnSharedResource

Enabling this makes the sync process fail if a resource is managed by other argocd application

### Replace

Enabling it converts kubectl apply operation in a kubectl replace or kubectl create operation

### Force and Replace

If we want to delete and recreate a resource at every sync, we can use Force=true,Replace=true as sync options

### ServerSideApply

Argocd by default uses a client side kubectl apply operation. This stores the last operation under the kubectl.kubernetes.io/last-applied-configuration annotation. See the server side apply document

Enabling this Sync option make argocd use the --server-side=true kubectl parameter

> Replace=true takes precedence over ServerSideApply=true.

### CreateNamespace

If the application definition has a namespace configured under spec.destination.namespace, enabling this Sync option will create it.

> Under spec.syncPolicy.managedNamespaceMetadata we can configure some labels and annotations to add to that created namespace. But if we configure managedNamespaceMetadata with an existing namespace with metadata, we must upgrade the resource to server-side apply to preserve the existing metadata.

### ApplyOutOfSyncOnly

Enabling ApplyOutOfSyncOnly the sync operation will only affect the OutOfSync resources. This makes the sync operation lighter for the api server. Specially relevant in big applications or low resource api servers.

### Prune settings

When a resource is not declared in the target state but it exists in the live state, we can configure the sync process to prune that resource.

#### Prune

- Prune=true

The Sync operation will delete the resource

- Prune=false

Prevents a resource from being pruned

- Prune=confirm

Requires manual confirmation before pruning

#### PrunePropagationPolicy

PrunePropagationPolicy permits to choose the garbage collection option. The default value is foreground

- PrunePropagationPolicy=foreground
- PrunePropagationPolicy=background
- PrunePropagationPolicy=orphan

Garbage Collection

<https://kubernetes.io/docs/concepts/architecture/garbage-collection/>

#### PruneLast

If enabled, moves the prune process at the end of the sync operation

```txt
PruneLast=true
PruneLast=false
```

### Delete

The Delete Sync options configures how a resource will be deleted after the application is deleted

- Delete=false

Don't delete the resource from the cluster during app deletion

- Delete=confirm

Requires manual confirmation before deletion

### RespectIgnoreDifferences

We can configure under spec.ignoreDifferences some fields of the manifests we want to ignore when checking the target (desired state) and the live state and showing the sync state.
Enabling the RespectIgnoreDifferences Sync option, applies that ignoreDifferences also to the sync process. This is, the fields declared under spec.ignoreDifferences will not be applied to the cluster.

> RespectIgnoreDifferences sync option is only effective when the resource is already created in the cluster. If the Application is being created and no live state exists, the desired state is applied as-is

### SkipDryRunOnMissingResource

When we want to apply a resource but the CRD does not exists in the cluster but both are located in the sync operation, argocd solves it. But if the CRDs are created dynamically during the sync operation, we can enable SkipDryRunOnMissingResource in the resource to avoid an error when argocd discovers if the CRD exists.

## Compare options

## argocd.argoproj.io/compare-options: IgnoreExtraneous

This annotation makes argocd ignore if a kubernetes resource is not synced in terms of considering the whole argocd application like synced or not.

This is useful when a different controller is making modifications in the resource and avoids unnecessary syncs.

## Links

- Sync Options

<https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/>

- Compare Options

<https://argo-cd.readthedocs.io/en/stable/user-guide/compare-options/>
