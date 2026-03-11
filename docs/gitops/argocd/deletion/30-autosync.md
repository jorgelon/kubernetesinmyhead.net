# At application level

## Disable autoSync

The first thing to consider is disabling autoSync. This will make argocd not doing anything in the application resources when some changes in the target state. In order to do that disable that section in the application definition

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
