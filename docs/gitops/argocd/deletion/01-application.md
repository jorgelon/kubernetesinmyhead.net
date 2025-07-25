# Application deletion

## Finalizers

A kubernetes finalizer gives the responsability to a controller to prevent resource deletion. In argocd we can specify a finalizer in an Application via metadata.finalizers field.

In this case, the  finalizer configures how the kubernetes resources defined in the application will be deleted.

### Cascade deletion

Configuring a finalizer in an Application enables the cascade deletion. The application is not deleted is not deleted inmediately. Kubernetes marks the resource for deletion, but delegates the deletion of the child resources to the Argocd controller, that performs cleanup before allowing the resource to be deleted.

There are 2 ways to perform a cascade deletion, also called propagation policies:

#### foreground cascade propagation policy

This is a synchronous deletion. The deletion of the Application is locked until all child resources are successfully deleted, when the controller removes the finalizer. Slower, but this does a clean an ordered deletion of child resources.

The foreground cascade deletion finalizer is **resources-finalizer.argocd.argoproj.io**

```yaml
metadata:
  finalizers:
    - resources-finalizer.argocd.argoproj.io
```

#### background cascade propagation policy

This is an asynchronous deletion. The Argocd controller initiates the deletion of the child resources in the background, but the deletion of the Application is not locked. It is a faster but may leave orphaned resources if deletion fails.

The background cascade deletion finalizer is **resources-finalizer.argocd.argoproj.io/background**

```yaml
metadata:
  finalizers:
    - resources-finalizer.argocd.argoproj.io/background
```

### Non cascading (orphan) deletion

When deleting Application with no finalizer, no resources will be deleted, only the Application

This can be useful:

- when we want to keep resources running but manage them differently
- moving resources between Application or ApplicationSet without downtime
- remove the Application but don't want to risk deleting critical resources

> The default finalizer for an Application is foreground cascade deletion

- The ApplicationSet has no default finalizer

## Application manual deletion

Via argocd binary

```shell
# foreground
argocd app delete APPNAME 
argocd app delete APPNAME --cascade # or
argocd app delete APPNAME --cascade --propagation-policy foreground # or
# background
argocd app delete APPNAME --cascade --propagation-policy background # or
# orphan
argocd app delete APPNAME --cascade=false
```

Via kubectl

```shell
# foreground
kubectl patch app APPNAME  -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}}' --type merge
kubectl delete app APPNAME
# background
kubectl patch app APPNAME  -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io/background"]}}' --type merge
kubectl delete app APPNAME
# orphan
kubectl patch app APPNAME  -p '{"metadata": {"finalizers": null}}' --type merge
kubectl delete app APPNAME
```
