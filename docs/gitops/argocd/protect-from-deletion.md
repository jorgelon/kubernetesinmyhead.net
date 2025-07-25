# Protection for deleting things

There are several ways to disable automatic deletion of things in argocd

## Disable autoSync

The first thing to consider is disabling autoSync. This will make argocd not doing anything in the application resources when some changes in the target state. In order to do thatl disable that section in the application definition

```txt
spec.syncPolicy.automated
```

## Prevent application deletion via applicationset

We can can prevent an applicationset the ability to delete its applications. An applicationset can be configured do the following actions in the managed applications:

- sync (default)

It can do all operations: create, update an delete

- create-only

It only creates applications. It cannot modify or delete applications

- create-delete

The applicationset creates and deletes applications but it cannot modify them.

- create-update

The applicationset cannot delete applications. It only can create and modify it.

So a way to prevent that deletion we can use, for example

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
spec:
  syncPolicy:
    applicationsSync: create-update
```

### At controller level

This also can be configured at **applicationset controller level** via --policy parameter. This setting exists in the **data.applicationsetcontroller.policy** key in the **argocd-cmd-params-cm ConfigMap**. This setting takes precedence over all applicationsets configuration although we can change this behaviour via data.**applicationsetcontroller.enable.policy.override** in the **argocd-cmd-params-cm ConfigMap**

> Also, we can disable all operations enabling the dryrun mode (--dryrun parameter) in the **argocd-cmd-params-cm ConfigMap**  using the **data.applicationsetcontroller.dryrun** key.

## Prevent application resources deletion via applicationset

If an applicationset deletes an application, we can skip deletion of its resources with this annotation in the applicationset definition.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
spec:
  syncPolicy:
    preserveResourcesOnDeletion: true
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

## Links

- Controlling if/when the ApplicationSet controller modifies Application resources

<https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Controlling-Resource-Modification/>

- Sync Options

<https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/>

- Automated Sync Policy

<https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/>

- App Deletion

<https://argo-cd.readthedocs.io/en/stable/user-guide/app_deletion/>

- Application Pruning & Resource Deletion

<https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Application-Deletion/>
