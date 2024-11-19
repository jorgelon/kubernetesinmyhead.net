# Tips

## failed to attach disk. The resource volume is in use

Because of some solved network errors, a container cannot start and keeps in containercreating state

We can inspect the pvc and the VolumeAttachment

```shell
kubectl get pvc
kubectl get VolumeAttachment | grep MYPVC
kubectl describe VolumeAttachment OURVOLUMEATTACHMENT
```

Here we get that error

```txt
... failed to attach disk .. The resource 'volume' is in use...
```

A solution can be to delete the VolumeAttachment related with our pvc and the finalizer in that VolumeAttachment but that didn't work.

Finally I found something was not working in the node. In the Vcenter Server interface in one node where that pod lived, the "See all disks" link under "VM Hardware" was missing. But in all the other nodes there is a link with all the csi disks attached.
The solution was drain that node (the pod started ok in other node), restart the node and uncordon it.
