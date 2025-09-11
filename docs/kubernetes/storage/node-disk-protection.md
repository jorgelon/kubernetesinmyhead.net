# Node disk protection

Kubernetes has 2 mechanisms to protect a node because of disk usage problems

## Image Garbage Collector

- Container runtime

**Imagefs** is the storage space used by the container runtime (containerd/cri-o,docker) for its operations.
Containerd tracks and reports usage of its own storage directories, this is /var/lib/containerd/

```txt
/var/lib/containerd/
├── io.containerd.content.v1.content/     # Image blobs. This is what Image GC primarily targets for removal
├── io.containerd.snapshotter.v1.overlayfs/ # Layer snapshots. NOT cleaned by Image GC - requires container restart/cleanup
├── io.containerd.metadata.v1.bolt/       # Metadata database
└── other containerd directories...
```

- Kubelet

Then kubelet queries containerd for storage stats via CRI and receives imageFs data

- Image Garbage Collector

Then kubelet removes unused images when some thresholds are reaches.

When the imageFS usage reaches the **HighThresholdPercent** setting, kubelet starts to delete container images ordered by last time they were used until the **LowThresholdPercent** is reached

> Since kubernetes 1.30 (beta) we can configure a **imageMaximumGCAge** as the maximum time a local image can be unused for

- Metrics

This metrics are exposed under /proxy/stats/summary API

You can see this in the kubelet metrics:

```shell
kubectl get --raw /api/v1/nodes/<node>/proxy/stats/summary | jq '.node.runtime.imageFs'
```

## Pod eviction

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

## Links

- Node-pressure Eviction

<https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/>

- Garbage collection of unused containers and images

<https://kubernetes.io/docs/concepts/architecture/garbage-collection/#containers-images>

- Local ephemeral storage

<https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#local-ephemeral-storage>
