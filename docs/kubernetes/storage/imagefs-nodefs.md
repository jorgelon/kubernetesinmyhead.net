# Imagefs and nodefs

A pod can write inside the container or in a persistent volume. The data written inside the container is written in the node and the data written in a persistent volume goes to the storage backend.

Lets focus in the data written in node (imagefs and nodefs)

## imagefs

Imagefs is the filesystem used by the container runtime to store container image layers and read-only data. This includes the writable layers where a container write files by default.

> In containerd by default imagefs is located in the /var/lib/containerd folder of the node

Its usage can be controlled at node level via the following eviction thresholds:

- imagefs.available
- imagefs.inodesFree

Writes go through the runtime snapshotter (overlayfs by default), so writing into the container's writable layer triggers a copy-up of the whole file, adding overhead for write-heavy workloads.

> The imagefs path is configured in the **container runtime** via its `root` directory (`root` in `/etc/containerd/config.toml` for containerd, or under `[crio]` in `/etc/crio/crio.conf` for CRI-O). To move it to a separate disk, mount that disk at the `root` path.

### containerfs

We can move that writable layers to a new filesystem called **containerfs**

Its usage can be controlled at node level via the following eviction thresholds:

- containerfs.available
- containerfs.inodesFree

> Splitting containerfs (KEP-4191, kubelet Beta behind the `KubeletSeparateDiskGC` feature gate) is only supported by **CRI-O** (v1.29+). **containerd does not implement it yet** ([issue #10517](https://github.com/containerd/containerd/issues/10517)), so the feature cannot graduate to stable until containerd lands support.

## nodefs

Nodefs is the node's main filesystem, used for local disk volumes, emptyDir volumes not backed by memory, log storage, ephemeral storage, and more.

> In containerd by default imagefs is located in the /var/lib/kubelet folder of the node

Its usage can be controlled at node level via the following eviction thresholds:

- nodefs.available
- nodefs.inodesFree

Writes hit a plain directory on the filesystem with no copy-on-write layering, so an emptyDir/PVC avoids the overlayfs overhead of the writable layer.

> The nodefs path is configured in the **kubelet** via its `rootDirectory` (or the `--root-dir` flag), default `/var/lib/kubelet`. To move it to a separate disk, mount that disk at the `rootDirectory` path.

But nodefs give us an additional way to control its usage per pod. If we configure a folder where a pod writes its data as an **emptyDir volume**, this data is considered as nodefs (local ephemeral storage) so we can include it under the pod spec resources:

- resources.requests.ephemeral-storage
- resources.limits.ephemeral-storage

Where **requests** is the amount reserved for scheduling (the scheduler only places the pod on a node with that much ephemeral storage available), and **limits** is the ceiling the pod may use before the kubelet evicts it for exceeding its ephemeral storage.

> Depending of the case both nodefs and imagefs can be written in the same node disk.

## Filesystem comparison

| Filesystem      | Default path          | Configured in     | Eviction thresholds                               | Pod resources | Performance                                     |
|-----------------|-----------------------|-------------------|---------------------------------------------------|---------------|-------------------------------------------------|
| **imagefs**     | `/var/lib/containerd` | container runtime | `imagefs.available`, `imagefs.inodesFree`         | No            | CoW writable layer (overlayfs copy-up overhead) |
| **containerfs** | separate filesystem   | container runtime | `containerfs.available`, `containerfs.inodesFree` | No            | CoW writable layer (overlayfs copy-up overhead) |
| **nodefs**      | `/var/lib/kubelet`    | kubelet           | `nodefs.available`, `nodefs.inodesFree`           | Yes           | Plain directory, no CoW overhead                |

## Container runtime table

| Topic                  | Containerd                                                           | Cri-O                                    |
|------------------------|----------------------------------------------------------------------|------------------------------------------|
| Configuration **file** | `/etc/containerd/config.toml`                                        | `/etc/crio/crio.conf` (+ `crio.conf.d/`) |
| Default imagefs path   | `/var/lib/containerd`                                                | `/var/lib/containers/storage`            |
| Default nodefs path    | `/var/lib/kubelet`                                                   | `/var/lib/kubelet`                       |
| Separate containerfs   | No ([#10517](https://github.com/containerd/containerd/issues/10517)) | Yes (v1.29+)                             |

## Conclusions

1. If we want to **persist** the data written by the container, move it to a **persistent volume**.
2. If the data written by the pod can **grow**, move it to an **emptyDir volume** and define its `resources.requests`/`resources.limits.ephemeral-storage`. Enforce those limits cluster-wide with **`LimitRange`/`ResourceQuota`**, including `emptyDir.sizeLimit`, so no workload can skip them.
3. Moving writes to an **emptyDir volume** also gives a little **performance increase**, since it avoids the overlayfs copy-on-write overhead of the container's writable layer.
4. If using **CRI-O**, consider using a separate **containerfs** to keep the writable layers off the image filesystem.
5. Control the data written on the nodes at node level via **eviction thresholds** (`nodefs`, `imagefs`, `containerfs`).
6. Configure kubelet **log rotation** (`containerLogMaxSize`, `containerLogMaxFiles`) so a chatty container can't fill nodefs via logs.
7. **Monitor inodes** (`*.inodesFree`) separately from bytes, and alert at ~80% usage — inode exhaustion is just as disruptive and harder to diagnose.
8. Consider **soft eviction thresholds** with grace periods so pods shut down cleanly instead of being hard-killed.
9. For truly transient hot data, use **`emptyDir` with `medium: Memory`** (RAM-backed, no disk overhead — but it counts against the pod's memory).
10. **Right-size the imagefs disk** to hold the node's image working set and garbage-collect unused images to avoid GC thrashing.
11. **Clean up evicted pods** — they linger in the API as `Failed/Evicted`; delete them after resolving the disk consumer.

## Links

- Node-pressure Eviction

<https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/>

- Local ephemeral storage

<https://kubernetes.io/docs/concepts/storage/ephemeral-storage/>
