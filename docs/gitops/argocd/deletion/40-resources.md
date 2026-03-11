# At resource level

## Disable autoSync

The first thing to consider is disabling autoSync. This will make argocd not doing anything in the application resources when some changes in the target state. In order to do thatldisable that section in the application definition

```txt
spec.syncPolicy.automated
```

## Prevent individual Resources

We can protect a kubernetes resource managed by argocd to be **deleted** using the following annotation in the resource

```yaml
metadata:
  annotations:
    argocd.argoproj.io/sync-options: Delete=false
```

Also, we can protect a kubernetes resource managed by argocd to be **pruned** using the following annotation in the resource

```yaml
metadata:
  annotations:
    argocd.argoproj.io/sync-options: Prune=false
```

This option only has sense with autoSync and prune enabled when definig the application

```yaml
spec:
  syncPolicy:
    automated:
      prune: true
```

> In both cases, **Prune=confirm** requires manual confirmation before deletion/pruning

## Manual deletion

When we delete an application manually using kubectl or argocd binary, we can choose to delete or not its resources:

- Dont delete resources

```shell
# argocd binary
argocd app delete APPNAME --cascade=false
# via kubectl
kubectl patch app APPNAME  -p '{"metadata": {"finalizers": null}}' --type merge
kubectl delete app APPNAME
```

- Delete resources (default):

```shell
# argocd binary
argocd app delete APPNAME --cascade # or
argocd app delete APPNAME
# via kubectl
kubectl patch app APPNAME  -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}}' --type merge
kubectl delete app APPNAME
```

Propagation policy (pending)

```txt
  -p, --propagation-policy string   Specify propagation policy for deletion of application's resources. One of: foreground|background (default "foreground")
```

## Settings table

| Setting                                                    | Level                       | Goal                                                      |
|------------------------------------------------------------|-----------------------------|-----------------------------------------------------------|
| spec.syncPolicy.automated                                  | Application                 | Disable applying new changes in the                       |
| spec.syncPolicy.automated.prune                            | Application                 | Disable pruning resources not defined in the target state |
| dry-run mode                                               | Controller                  | Prevent all ApplicationSet doing actions                  |
| spec.syncPolicy.applicationsSync                           | ApplicationSet / Controller | Prevent an/all ApplicationSet delete applications         |
| metadata.finalizers.resources-finalizer.argocd.argoproj.io | ApplicationSet              | Prevent delete application when ApplicationSet is deleted |
| spec.syncPolicy.preserveResourcesOnDeletion                | ApplicationSet              | Prevent resource deletion when application is deleted     |
| argocd.argoproj.io/sync-options: Delete=false              | Resource                    |                                                           |
| argocd.argoproj.io/sync-options: Prune=false               | Resource                    |                                                           |

## Links

- Controlling if/when the ApplicationSet controller modifies Application resources

<https://argo-cd.readthedocs.io/en/stable/operator-manual/ApplicationSet/Controlling-Resource-Modification/>

- Application Pruning & Resource Deletion

<https://argo-cd.readthedocs.io/en/stable/operator-manual/ApplicationSet/Application-Deletion/>

- Automated Sync Policy

<https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/>

- Sync Options

<https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/>

- App Deletion

<https://argo-cd.readthedocs.io/en/stable/user-guide/app_deletion/>
