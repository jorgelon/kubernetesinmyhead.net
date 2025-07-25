# ApplicationSet

## ApplicationSet deletion

An ApplicationSet can generate Application resources. We can see in the .metadata.ownerReferences field the Application the ApplicationSet that generated it.

By default, when an ApplicationSet is deleted, this will occur by order

- The ApplicationSet is deleted

- Any Application resource created with this ApplicationSet (ownerreference) will be deleted. This is based in the kubernetes garbage collector. Kubernetes automatically garbage-collects resources when their owner is deleted.

- The Application's resources will also be deleted.

### Changing this behaviour

- ApplicationSet finalizer

We can also configure the foreground and background finalizer in an ApplicationSet.
The foreground finalizer blocks deletion until all Applications are deleted and ensures complete cleanup.
The background finalizer initiates the deletion in the background. Faster, but may leave resources if deletion fails

- Don't delete Applications

To delete an ApplicationSet resource, while preventing Applications (and their deployed resources) from also being deleted, using a non-cascading delete:

```shell
kubectl delete ApplicationSet (NAME) --cascade=orphan
```

- Preserve Application's resources

If we want to **preserve the deletion of the Application's resources** we can enable spec.syncPolicy.preserveResourcesOnDeletion. This prevents the ApplicationSet controller from setting up a finalizer during application generation.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
spec:
  syncPolicy:
    preserveResourcesOnDeletion: true
```

## ApplicationSet permissions in apps

We can configure if an ApplicationSet can create, update and delete its discovered applications.

> This is different than when an ApplicationSet is deleted.

### Dry run

At controller level we can disable all modifications that the ApplicationSets can do in Application in an argocd instance.

This is done enabling the dryrun mode (--dryrun parameter) via the **data.ApplicationSetcontroller.dryrun** key in the **argocd-cmd-params-cm ConfigMap**

### Policy at ApplicationSet level

Also we can control the individual actions an ApplicationSet can to in its applications via the spec.syncPolicy.applicationsSync setting with the following values:

- sync
- create-only
- create-delete
- create-update

| Action         | create   | update   | delete   |
|----------------|----------|----------|----------|
| sync (default) | &#x2611; | &#x2611; | &#x2611; |
| create-only    | &#x2611; | &#x2612; | &#x2612; |
| create-delete  | &#x2611; | &#x2612; | &#x2611; |
| create-update  | &#x2611; | &#x2611; | &#x2612; |
| dry run mode   | &#x2612; | &#x2612; | &#x2612; |

So a to prevent that deletion we can use, for example

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
spec:
  syncPolicy:
    applicationsSync: create-update
```

> This also can be configured at **ApplicationSet controller level** via --policy parameter. This setting exists in the **data.ApplicationSetcontroller.policy** key in the **argocd-cmd-params-cm ConfigMap**. This setting takes precedence over all ApplicationSets configuration although we can change this behaviour via data.**ApplicationSetcontroller.enable.policy.override** in the **argocd-cmd-params-cm ConfigMap**
