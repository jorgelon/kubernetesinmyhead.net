# Safe changes to Resources

## Remove from argocd, not from the cluster

If we want to remove a kubernetes resources from an argocd Application we can make it in different ways.

### With the tracking method

When argocd manages a kubernetes marks it to know it is being managed.

Since argocd 3.0 the default tracking method is adding an annotation to the resource

```txt
argocd.argoproj.io/tracking-id
```

Until 3.0 the default tracking method was adding the app.kubernetes.io/instance label, and that can cause some errors because it is a well known label included in some applications. In this case it is a good practice to change the tracking method or changing the label.

> <https://argo-cd.readthedocs.io/en/stable/user-guide/resource_tracking/>

STEPS

- First of all the more secure starting point is to **disable autoSync** in the Application or, at least, **selfHeal to false**

- Then we only need to **delete that tracking method** from the resource, for example the annotation, but autosync and self heal will be add it. So we need

- Next we can edit that resource and remove the tracking annotation. The resource will be shown out of sync. This can be done via kubectl or argocd web interface.

- Then we push the changes to git where we declare we dont want the resource in that Application. Refresh the Application and the resource will dissapear but it will not be deleted from the cluster

### With orphan deletion

This is faster but it is also potentially less secure because implies a deletion.

- First of all disable autosync in the application

- Then remove the resource from the argocd ui using **Non-cascading (Orphan) Delete**. The resource will be shown out of sync.

![alt text](image-1.png)
![alt text](image.png)

- Then we push the changes to git where we declare we dont want the resource in that Application. Refresh the Application and the resource will dissapear but it will not be deleted from the cluster
