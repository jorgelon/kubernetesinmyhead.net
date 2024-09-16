# Increase the pvc size in a statefulset

This is an argocd controlled statefulset

## Disable autosync

Disable autosync in argocd

## Change the size

```shell
kubectl edit pvc STS_NAME
```

or via argocd

## Delete the STS with orphan

```shell
kubectl delete sts --cascade=orphan STS_NAME
```

## Reapply the STS

Sync the statefulset via argocd

## Restart the sts

```shell
kubectl rollout restart sts STS_NAME
```

## Reactivate autosync

If all it is working, enable autosync again in argocd
