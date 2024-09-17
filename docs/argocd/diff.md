# Manage differences

If there are differences between the desired and the live state the application is in an OutOfSync statu

In the UI it is posibble to filter the applications in this state

![filter](img/outofsyncfilter.png)

There are a lot of reasons why an applicatiion can be shown as OutOfSync. The most tipical case is that there are some intentional changes in the manifests or there are resources that need to be pruned. A simple sync/prune operation fixes this.

But there are some cases where this operation does not fixes it. For example, if a kubernetes process (controller, mutating webhook,...) has modified a resource in the cluster. That and another situations causes a permanent OutOfSync status of the application and it needs to be customized.

## ignoreDifferences at application level

It is possible to ignore that differences at application level making argocd show that application as synced. There are some ways to tell argocd what needs to be ignored, like indicating the path of field in the manifest.

```yaml
spec:
  ignoreDifferences:
  - group: apps
    kind: Deployment
    jsonPointers:
    - /spec/replicas
```

## ignoreDifferences at argocd instance level

It is possible to ignore that in all applications in the argocd-cm ConfigMap. The format is different. The resource must be specified with **resource.customizations.ignoreDifferences.GROUP_RESOURCE** or use **resource.customizations.ignoreDifferences.all** for ignoring all resources

```yaml
data:
  resource.customizations.ignoreDifferences.apps_Deployment: |
    managedFieldsManagers:
    - kube-controller-manager
```

## RespectIgnoreDifferences

That ignoreDifferences by default keeps syncing that fields in a sync operation. If also you want to ignore that differences in the sync processs you must use the RespectIgnoreDifferences setting.

At application level

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
spec:
  ignoreDifferences:
  - group: "apps"
    kind: "Deployment"
    jsonPointers:
    - /spec/replicas
  syncPolicy:
    syncOptions:
    - RespectIgnoreDifferences=true
```

## Links

See these links for more information

- Diffing Customization

<https://argo-cd.readthedocs.io/en/stable/user-guide/diffing/>

- Diff Strategies

<https://argo-cd.readthedocs.io/en/stable/user-guide/diff-strategies/>
