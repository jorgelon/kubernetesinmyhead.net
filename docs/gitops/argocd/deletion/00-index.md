# Deletion

There are several ways to disable automatic deletion of things in argocd

## Settings table

| Setting                                       | Level                       | Goal                                                                              |
|-----------------------------------------------|-----------------------------|-----------------------------------------------------------------------------------|
| finalizer                                     | ApplicationSet              | Permits to enable foreground/background deletion of Application                   |
| spec.syncPolicy.applicationsSync              | ApplicationSet / Controller | Prevent an/all ApplicationSet delete applications                                 |
| spec.syncPolicy.preserveResourcesOnDeletion   | ApplicationSet              | Does not delete Application resources whe the Applicationset is deleted           |
| finalizer                                     | Application                 | Non-cascade does not delete Application resources when the Application is deleted |
| spec.syncPolicy.automated                     | Application                 | If ommited, disables applying new changes                                         |
| spec.syncPolicy.automated.prune               | Application                 | "False" disables pruning resources not defined in the target state                |
| dry-run mode                                  | Controller                  | Prevent all ApplicationSet doing actions                                          |
| argocd.argoproj.io/sync-options: Delete=false | Resource                    |                                                                                   |
| argocd.argoproj.io/sync-options: Prune=false  | Resource                    |                                                                                   |

## Best practices

### ApplicationSet foreground cascade deletion

Enable the foreground cascade deletion the ApplicationSet resources:

Benefits:

- Controlled deletion: Ensures Applications are properly deleted before the ApplicationSet is removed

- Prevents orphaned resources: Makes sure all generated resources are cleaned up properly

- Explicit behavior: Makes the deletion behavior clear and predictable rather than relying on Kubernetes garbage collection alone

- Complete cleanup: Guarantees that all resources are removed in the correct order

Exceptions:

- Where quick deletion might be preferred (use background finalizer)
- Very large ApplicationSets: Where deletion speed is a concern (background might be better)
- Migration scenarios: Where you want to keep Applications (use --cascade=orphan instead)
