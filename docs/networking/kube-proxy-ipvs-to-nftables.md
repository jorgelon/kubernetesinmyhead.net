# Migrating kube-proxy from IPVS to nftables in kubeadm clusters

kube-proxy IPVS mode was deprecated in Kubernetes v1.35.0 (released December 2025) and is targeted for removal in v1.38. The recommended replacement on Linux is nftables mode, which provides equivalent O(1) lookup performance with incremental rule updates and active upstream development.

nftables reached GA in v1.33 and is the **recommended mode for Linux nodes**. However, **iptables remains the default** for compatibility reasons. Clusters do not migrate automatically on upgrade — you must opt in explicitly by setting `mode: "nftables"` in the kube-proxy configuration.

This guide covers the migration procedure for kubeadm-managed clusters.

## Requirements

- Kubernetes 1.29+ (nftables alpha), 1.31+ (nftables beta), 1.33+ (nftables GA)
- Linux kernel 5.13 or newer on all nodes
- `nft` command-line tool version 1.0.1 or newer on all nodes

Verify on each node:

```bash
uname -r
nft --version
```

## Check current kube-proxy mode

```bash
kubectl get configmap kube-proxy -n kube-system -o jsonpath='{.data.config\.conf}' | grep mode
```

Expected output if IPVS is configured:

```
mode: "ipvs"
```

## Migration steps

**Node drain is not required.** kube-proxy runs as a DaemonSet and restarts node-by-node. When it restarts in nftables mode, it automatically removes all existing IPVS rules. Established connections survive the restart because the kernel's connection tracking (conntrack) table is not affected. No node reboot is required either.

### 1. Edit the kube-proxy ConfigMap

```bash
kubectl edit configmap kube-proxy -n kube-system
```

Locate the `config.conf` key. Change `mode` from `ipvs` to `nftables` and remove any IPVS-specific blocks:

```yaml
# Before
mode: "ipvs"
ipvs:
  strictARP: true

# After
mode: "nftables"
```

> If you had `ipvs.strictARP: true` set for MetalLB L2 compatibility, it is not needed in nftables mode and can be removed.

### 2. Restart the kube-proxy DaemonSet

```bash
kubectl rollout restart daemonset kube-proxy -n kube-system
```

Wait for the rollout to complete:

```bash
kubectl rollout status daemonset kube-proxy -n kube-system
```

kube-proxy performs a node-by-node rolling restart. During the brief window when a node's kube-proxy pod is restarting, existing connections on that node are not disrupted — only new connection setup is affected momentarily. There is no need to cordon or drain nodes.

## Verify the migration

Check kube-proxy logs on any node to confirm nftables mode is active:

```bash
kubectl logs -n kube-system -l k8s-app=kube-proxy | grep -i nftables
```

Expected output:

```
Using nftables Proxier.
```

Confirm that IPVS rules no longer exist on a node:

```bash
# Run on a node
ipvsadm -L --stats 2>/dev/null || echo "No IPVS rules"
```

Confirm that nftables rules are present:

```bash
# Run on a node
nft list ruleset | grep -i kubernetes
```

Check that the `kube-ipvs0` dummy interface is gone from nodes:

```bash
# Run on a node
ip link show kube-ipvs0 2>/dev/null || echo "kube-ipvs0 not present"
```

## Persist the mode across kubeadm upgrades

This is an important step. `kubeadm upgrade apply` regenerates the kube-proxy ConfigMap from its config. If the `KubeProxyConfiguration` is absent from the config passed to the upgrade, kubeadm fills in defaults — which means **your `mode: "nftables"` will be silently overwritten back to iptables**.

There are two ways to prevent this.

### Option A: upgrade without --config (recommended)

If you run `kubeadm upgrade apply` without `--config`, kubeadm reads the in-cluster `kubeadm-config` ConfigMap and does not touch the `kube-proxy` ConfigMap. The mode you set manually is preserved.

```bash
# kubeadm reads in-cluster config, kube-proxy ConfigMap is left untouched
kubeadm upgrade apply v1.3x.x
```

### Option B: include KubeProxyConfiguration in your upgrade config file

If you use `--config`, you must explicitly include the `KubeProxyConfiguration` block in the file, otherwise kubeadm regenerates the kube-proxy config with defaults:

```yaml
apiVersion: kubeadm.k8s.io/v1beta4
kind: ClusterConfiguration
---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "nftables"
```

```bash
kubeadm upgrade apply v1.3x.x --config kubeadm-config.yaml
```

### New node joins

For nodes added after the migration, include the `KubeProxyConfiguration` in the kubeadm join config to ensure they start in nftables mode from the beginning:

```yaml
apiVersion: kubeadm.k8s.io/v1beta4
kind: JoinConfiguration
---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "nftables"
```

## Deprecation timeline

| Kubernetes version | IPVS status                             |
|--------------------|-----------------------------------------|
| v1.34 and earlier  | Supported                               |
| v1.35              | Deprecated (warning emitted at startup) |
| v1.38 (target)     | Removed                                 |

## Links

- KEP-5495: Deprecate IPVS mode in kube-proxy

  <https://github.com/kubernetes/enhancements/issues/5495>

- NFTables mode for kube-proxy

  <https://kubernetes.io/blog/2025/02/28/nftables-kube-proxy/>

- Linux Kernel Version Requirements

  <https://kubernetes.io/docs/reference/node/kernel-version-requirements/>

- IPVS to NFTables migration guide

  <https://dev.to/frozenprocess/ipvs-to-nftables-a-migration-guide-for-kubernetes-v135-24m5>
