# Safe changes to Resources

## Remove from argocd, not from the cluster

If we want to remove a kubernetes resources from an argocd Application we can make it in different ways.

First of all the more secure starting point is to **disable autoSync** in the Application

### With the tracking method

When argocd manages a kubernetes marks it to know it is being managed.

Since argocd 3.0 the default tracking method is adding an annotation to the resource

```txt
argocd.argoproj.io/tracking-id
```

Until 3.0 the default tracking method was adding the app.kubernetes.io/instance label, and that can cause some errors because it is a well known label included in some applications. In this case it is a good practice to change the tracking method or changing the label.

> <https://argo-cd.readthedocs.io/en/stable/user-guide/resource_tracking/>

- With autosync disabled or, at least, **selfHeal to false**, we only need to **delete that tracking method** from the resource, for example the annotation, but autosync and self heal will be add it. So we need

- Next we cat edit that resource and remove the tracking annotation. The resource will be shown out of sync.

- Then we push the changes to git where we declare we dont want the resource in that Application. Refresh the Application and the resource will dissapear from but it will not be deleted

### With orphan deletion

pending
