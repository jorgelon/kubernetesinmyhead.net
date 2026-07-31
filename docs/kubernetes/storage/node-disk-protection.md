# Node disk protection

Kubernetes has 2 mechanisms to protect a node because of disk usage problems, using imagefs an using nodefs

## Imagefs (image garbage collection)

**Imagefs** is the storage space used by the container runtime for its operations. For example containerd uses **/var/lib/containerd/** by default. It includes:

- Image layers/blobs pulled from registries (the content store)
- The unpacked, read-only image filesystem layers (snapshots) shared by containers
- Image metadata and index information

> When imagefs and containerfs are not split into separate disks, the container writable layers and logs also count against imagefs (see containerfs below).

Kubelet talks with the container runtime to determine imagefs and publish the results in the Summary API at /stats/summary under .node.runtime.imageFs
This command reports information about space and inodes (total, used and available)

```shell
kubectl get --raw "/api/v1/nodes/NODE/proxy/stats/summary" | jq '.node.runtime.imageFs'
```

With crictl in the node

```shell
crictl imagefsinfo -o table
crictl images
```

### Autoclean via Image Garbage Collector

We can configure at kubelet level an auto clean of imagefs. The following settings are available:

| Settings                    | Default       | Explanation                                                                                         |
|-----------------------------|---------------|-----------------------------------------------------------------------------------------------------|
| imageGCHighThresholdPercent | 85            | When imagefs usage reaches this %, GC starts deleting unused images. 100 disables it.               |
| imageGCLowThresholdPercent  | 80            | GC keeps deleting until usage falls to this %. GC never runs if usage is below this. Must be < high |
| imageMinimumGCAge           | 2m0s          | An unused image must be at least this old before it's eligible. It protects freshly pulled images   |
| imageMaximumGCAge           | 0s (disabled) | Time-based autoclean: any unused image older than this is deleted regardless of disk usage          |

- Some operating systems like Bottlerocket put imagefs and nodefs in the same disk
- Karpenter permits to configure spec.kubelet.imageGCHighThresholdPercent and spec.kubelet.imageGCLowThresholdPercent in a nodeclass. Age based settings must be configured under userdata

## nodefs (Eviction)

Nodefs is the filesystem kubelet uses for local ephemeral storage (the kubelet root dir /var/lib/kubelet) and the node/pod logs. It includes:

- emptyDir volumes (unless medium: Memory, which is tmpfs/RAM)
- Pod and container logs (/var/log/pods, /var/log/containers)
- Pod ephemeral scratch and the ephemeral-storage request/limit accounting
- kubelet bookkeeping, projected-volume working dirs, plugin data

> nodefs is reported as whole-filesystem usage, so when it shares a disk with imagefs/containerfs (e.g. Bottlerocket) its used value also includes those.

The status can be obtained this way.

```shell
kubectl get --raw "/api/v1/nodes/NODEproxy/stats/summary" | jq '.node.fs'
```

> We can also get information about ephemeral-storage usage via kubectl describe node NODE

### Autoclean via Eviction

Kubernetes has a process to terminate pods when some conditions are met in order to reclaim resources in the node. We have 2 methods here

- Soft eviction

Node-pressure eviction can remove pods because a threshold has been reached, and there are 3 filesystem identifiers that can be used with eviction signals:

- **nodefs**

Is the directory path defined under --root-dir kubelet setting. The default is /var/lib/kubelet

> nodefs.available is calculated via node.stats.fs.available

- **imagefs**

Here we have the container images. In containerd this is located in /var/lib/containerd/images/

> imagefs.available eviction signal is calculated via node.stats.runtime.imagefs.available

- **containerfs**

Here we have the writeable layers and logs. In containerd this is located in /var/lib/containerd/containers/

> containerfs.available eviction signal is calculated via node.stats.runtime.containerfs.available

We can get this 3 data for a node with:

```shell
kubectl get --raw /api/v1/nodes/NODE/proxy/stats/summary | jq '.node.fs'
kubectl get --raw /api/v1/nodes/NODE/proxy/stats/summary | jq '.node.runtime'
```

> In BottleRocket OS or Flatcar all paths are under the same / overlay partition so the result is the same.

### Soft and hard eviction

- The soft eviction has a grace period until kubelet start to evict pods.
- The hard eviction has no grace period
- By default, only hard evictions are configured: imagefs.available<15%,memory.available<100Mi,nodefs.available<10%
This can be a good situation for spot instances, stateless workloads or environments with constant pod creation/deletion
- For production environments, define eviction soft settings with higher values and trigger some automatic and proactive cleanup during grace period
- Setup soft and hard prometheus alerts

```yaml
evictionHard: # default
    nodefs.available: "10%" 
    imagefs.available: "15%"
evictionSoft:
    nodefs.available: "20%"    # 5% buffer before hard eviction
    imagefs.available: "25%"   # 10% buffer before hard eviction
evictionSoftGracePeriod:
    nodefs.available: "2m"     # Allow 2 minutes for cleanup/migration
    imagefs.available: "2m"
```

## With or without ephemeral storage

When a container writes data, the bytes land in a different filesystem depending on whether an emptyDir volume is mounted at the write path. Declaring emptyDir does not reduce total usage, it relocates it and changes the lifecycle and the controls available.

|                                     | No emptyDir (writes to container FS)                                 | emptyDir mounted at the write path                     |
|-------------------------------------|----------------------------------------------------------------------|--------------------------------------------------------|
| Physical location                   | Container writable layer (containerfs) in /var/lib/containerd        | /var/lib/kubelet/pods/UID/volumes/kubernetes.io~empty-dir/ |
| Kubelet accounting                  | imagefs / containerfs                                                | nodefs                                                 |
| Counts against pod ephemeral-storage| Yes                                                                  | Yes (default medium)                                   |
| Survives container restart          | No, restart creates a fresh writable layer and the data is lost      | Yes, persists across container restarts within the pod |
| Survives pod deletion/eviction      | No                                                                   | No                                                     |
| Size guardrail                      | resources.limits.ephemeral-storage only                             | emptyDir.sizeLimit and/or ephemeral-storage limit      |
| Can move off disk to RAM            | No                                                                   | Yes, with medium: Memory                               |

## Links

- [Imagefs and nodefs](imagefs-nodefs.md)

- Node-pressure Eviction

<https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/>

- Garbage collection of unused containers and images

<https://kubernetes.io/docs/concepts/architecture/garbage-collection/#containers-images>

- Local ephemeral storage

<https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#local-ephemeral-storage>
