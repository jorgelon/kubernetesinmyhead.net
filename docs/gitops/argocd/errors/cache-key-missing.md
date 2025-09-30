# cache: key is missing

After an update we get this error in the web interface

```txt
error getting cached app managed resources: cache: key is missing
```

It seems the solution is restarting the argocd-application-controller

```shell
kubectl rollout restart statefulset -n argocd argocd-application-controller
```
