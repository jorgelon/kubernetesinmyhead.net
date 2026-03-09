# IP Address Management (IPAM)

## Pods

The CNI (Container Network Interface) plugin is responsible for assigning IP addresses to pods.
When a pod is created, the Kubelet on the node calls the CNI plugin to set up networking.

The CIDR ranges Kubernetes makes available to CNI plugins depend on how the cluster is configured.

### kube-controller-manager (cluster mode)

In a standard cluster, `kube-controller-manager` slices the global pod CIDR into per-node subnets
and writes them to each `node.spec.podCIDR`. Most CNI plugins then read that field.

Configuration file:

```yaml
allocateNodeCIDRs: true
clusterCIDR: "10.244.0.0/16"
nodeCIDRMaskSize: 24        # per-node prefix length, default /24 for IPv4
nodeCIDRMaskSizeIPv4: 24
nodeCIDRMaskSizeIPv6: 64
```

Equivalent CLI flags:

```txt
--allocate-node-cidrs=true
--cluster-cidr=10.244.0.0/16
--node-cidr-mask-size=24
```

Each node gets a `/24` carved out of `10.244.0.0/16`, giving 254 usable pod IPs per node.

### kubelet (standalone mode)

When the kubelet runs without a cluster (no kube-controller-manager), set the pod CIDR directly:

```txt
--pod-cidr=10.244.1.0/24          # kubelet flag
# podCIDR: "10.244.1.0/24"        # kubelet config file equivalent
```

### CNI IPAM modes

Each CNI plugin has its own IPAM modes that may override or complement the Kubernetes settings
above.

#### Cilium

Cilium supports several IPAM modes configured via Helm:

| Mode                     | Description                                                                            |
|--------------------------|----------------------------------------------------------------------------------------|
| `cluster-pool` (default) | Cilium operator assigns per-node CIDRs from its own pool, ignoring `node.spec.podCIDR` |
| `kubernetes`             | Cilium reads `node.spec.podCIDR` set by kube-controller-manager                        |
| `eni`                    | AWS ENI assigns IPs directly (one IP per ENI secondary address)                        |
| `azure`                  | Azure CNI integration                                                                  |
| `crd`                    | IPs defined via `CiliumNode` CRDs                                                      |

The mode is set at install time via Helm and **cannot be changed on a running cluster** without
a full Cilium reinstall. Choose based on:

- **On-premise / generic cloud** → `cluster-pool` (default). Cilium is self-contained.
- **Need kube-controller-manager to own node CIDRs** (e.g. some managed K8s integrations)
  → `kubernetes`.
- **AWS, want VPC-native IPs or Security Groups per Pod** → `eni`.
- **AKS with Azure CNI** → `azure`.

**Cluster Pool (default)** — Cilium manages its own CIDR pool independently of
kube-controller-manager:

```yaml
ipam:
  mode: cluster-pool
  operator:
    clusterPoolIPv4PodCIDRList:
      - "10.0.0.0/8"        # global pool (default)
    clusterPoolIPv4MaskSize: 24   # per-node allocation size (default)
```

> With `cluster-pool`, the `--cluster-cidr` flag in kube-controller-manager is ignored by Cilium.

**Kubernetes mode** — Cilium delegates CIDR allocation to kube-controller-manager:

```yaml
ipam:
  mode: kubernetes
```

Requires kube-controller-manager to have `--allocate-node-cidrs=true` and `--cluster-cidr` set.

#### Flannel / Calico (host-local IPAM)

These CNIs use the `host-local` IPAM plugin with `"subnet": "usePodCidr"`, which reads
`node.spec.podCIDR`. Requires `--allocate-node-cidrs=true` in kube-controller-manager.

---

## Services

`kube-apiserver` allocates ClusterIP addresses for Services from a dedicated CIDR.

```txt
--service-cluster-ip-range=10.96.0.0/12   # default in many distros
```

```yaml
# kube-apiserver configuration file
serviceClusterIPRange: "10.96.0.0/12"
```

Key points:

- The first IP in the range (e.g. `10.96.0.1`) is always reserved for the internal
  `kubernetes` Service.
- The range must not overlap with the pod CIDR or node CIDR.
- Dual-stack clusters set two ranges: `--service-cluster-ip-range=10.96.0.0/12,fd00::/108`.

### NodePort range

```txt
--service-node-port-range=30000-32767   # default
```

### LoadBalancer IPs

`LoadBalancer` type Services get an external IP assigned by:

- The cloud provider (EKS, AKS, GKE) via the cloud controller manager.
- On-premise: MetalLB, or similar — see [On-premise load balancers](onpremise-loadbalancers.md).

---

## Nodes

Node IPs are assigned by the underlying infrastructure (cloud provider, DHCP, static config).
The kubelet selects which IP to advertise to the cluster:

```txt
--node-ip=192.168.1.10   # force a specific IP (useful on multi-homed nodes)
```

In cloud environments, the cloud controller manager populates `node.status.addresses` with
the node's internal and external IPs after registration.
