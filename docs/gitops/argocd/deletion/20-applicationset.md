# ApplicationSet

## Relation between the the ApplicationSet and generated Applications

The generated Applications by an ApplicationSet have:

- In .metadata.ownerReferences, a reference to the ApplicationSet as owner
- In .metadata.finalizers a **resources-finalizer.argocd.argoproj.io** finalizer if the ApplicationSet has .syncPolicy.preserveResourcesOnDeletion as false
- By default they have the resources-finalizer.argocd.argoproj.io finalizer

## Deleting an ApplicationSet

When an ApplicationSet is deleted, this will occur in order

- the ApplicationSet is deleted

- the generated Applications are deleted (because of the owner reference)

- the deployed resources created in that Application are deleted

There are 3 ways to control how this deletion is done via finalizers

### Default (no finalizer)

By default an ApplicationSet has not finalizer. This means the argocd applicationset controller will not manage the deletion of the ApplicationSet. It will be done using **kubernetes garbage collector**.

- Nothing blocks or delays its deletion. The ApplicationSet is deleted inmediately
- This performs a cascade deletion of the Applications and resources, because of the owner reference

<https://kubernetes.io/docs/concepts/architecture/garbage-collection/>

If we want to delete an ApplicationSet resource, while preventing Applications (and their deployed resources) from being deleted, we can use a non-cascading delete:

```shell
kubectl delete ApplicationSet (NAME) --cascade=orphan
```

### Using argocd finalizer

We can add a finalizer an ApplicationSet. This makes the applicationset controller responsible to manage how the Applications and resources are deleted

- Foreground

The foreground finalizer blocks deletion until all Applications are deleted and ensures complete and ordered cleanup.

- Background

The background finalizer initiates the deletion in the background. Faster, but may leave resources if deletion of child resources fails.

### Preserve Application's resources

If we want to **preserve the deletion of the Application's resources** we can enable spec.syncPolicy.preserveResourcesOnDeletion in the ApplicationSet.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
spec:
  syncPolicy:
    preserveResourcesOnDeletion: true
```

> This removes the resources-finalizer.argocd.argoproj.io finalizer in the generated Applications so a non cascading (orphan) deletion is performed in the Application

## ApplicationSet permissions

We can configure if an ApplicationSet can create, update and delete its discovered applications.

> This is different than when an ApplicationSet is deleted.

### Dry run

At controller level we can disable all modifications that the ApplicationSets can do in Application in an argocd instance.

This is done enabling the dryrun mode (--dryrun parameter) via the **data.ApplicationSetcontroller.dryrun** key in the **argocd-cmd-params-cm ConfigMap**

### Policy at ApplicationSet level

Also we can control the individual actions an ApplicationSet can to in its applications via the spec.syncPolicy.applicationsSync setting with the following values:

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
