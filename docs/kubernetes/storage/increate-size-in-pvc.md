# Increase the pvc size in a statefulset

In order to increase the desired size of a volumeClaimTemplates in a kubernetes statefulset, if we only change the size, we wil get this error:

```txt
recreating StatefulSet because the update operation wasn't possible
...
Forbidden: updates to statefulset spec for fields other than 'replicas', 'ordinals', 'template', 'updateStrategy', 'persistentVolumeClaimRetentionPolicy' and 'minReadySeconds' are forbidden"
```

This is because that field is inmutable.

If we can lose data, we can simply delete the statefulset and create it again with the desired size. But if we want to maintain the data the steps can be:

## Disable autosync

If using autosync in argocd or similar tools, disable autosync

## Increase the size in the PVC

Edit the PVC manually and change the size with

```shell
kubectl edit pvc NAME-OF-THE-PVC
```

And the wait until it has been resized.

```shell
kubectl get pvc NAME-OF-THE-PVC -w
```

> This step needs to have an storageclass with allowVolumeExpansion supported by the storagebackend and enabled in our storageclass definition

## Do an orphan delete of the statefulset
  
Next we will delete the statefulset via

```shell
kubectl delete sts --cascade=orphan STATEFULSET
```

This will not delete the pods and PVC

## Reapply the statefulset with the new size

Finally apply the manifest with the new size

```shell
kubectl apply -f STATEFULSET
```

> If using argocd or similar tool, change the size in the manifest, and do a syn of the statefulset. Enable autosync again
