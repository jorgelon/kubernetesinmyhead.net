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
