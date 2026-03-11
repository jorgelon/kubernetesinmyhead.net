# Upgrade

## Pre-upgrade checklist

### 1. Read the Kubernetes changes

Check the changes between releases:

- [Releases](https://kubernetes.io/releases/)
- [Blog](https://kubernetes.io/blog/)

### 2. Read the upgrade documentation

- [Upgrade a Cluster](https://kubernetes.io/docs/tasks/administer-cluster/cluster-upgrade/)
- [Upgrading kubeadm clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)
- [Upgrading Linux nodes](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/upgrading-linux-nodes/)

### 3. Check compatibility

Verify compatibility between all your applications and the new Kubernetes release:

- CNI plugin (Cilium, Calico, ...)
- CSI driver (NFS, vSphere, ...)
- Ingress controllers, operators, and other cluster add-ons

### 4. Check deprecated APIs

Kubernetes APIs can change between releases:

- [Deprecation Guide](https://kubernetes.io/docs/reference/using-api/deprecation-guide/)

Tools to detect deprecated API usage:

- [Pluto](https://github.com/FairwindsOps/pluto)

## Upgrade procedure

!!! warning
    Only upgrade **one minor version at a time**
    (e.g., 1.29 → 1.30, never 1.29 → 1.31).

### Control plane node

Run these steps on the first control plane node. For additional control plane nodes,
replace `kubeadm upgrade apply` with `kubeadm upgrade node`.

1. **Upgrade the `kubeadm` binary** to the target version using your package manager
   (apt/yum).

2. **Verify the upgrade plan**:

    ```shell
    sudo kubeadm upgrade plan
    ```

3. **Apply the upgrade** (first control plane node only):

    ```shell
    sudo kubeadm upgrade apply v<TARGET_VERSION>
    ```

4. **Drain the node**:

    ```shell
    kubectl drain <control-plane-node> --ignore-daemonsets
    ```

5. **Upgrade `kubelet` and `kubectl`** to the target version using your package manager.

6. **Restart kubelet**:

    ```shell
    sudo systemctl daemon-reload
    sudo systemctl restart kubelet
    ```

7. **Uncordon the node**:

    ```shell
    kubectl uncordon <control-plane-node>
    ```

### Additional control plane nodes

Repeat steps 1 and 4–7 for each additional control plane node, replacing step 3 with:

```shell
sudo kubeadm upgrade node
```

### Worker nodes

Perform these steps for each worker node:

1. **Drain the node** from a machine with `kubectl` access:

    ```shell
    kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
    ```

2. **Upgrade the `kubeadm` binary** on the node.

3. **Upgrade the node configuration**:

    ```shell
    sudo kubeadm upgrade node
    ```

4. **Upgrade `kubelet` and `kubectl`** on the node.

5. **Restart kubelet**:

    ```shell
    sudo systemctl daemon-reload
    sudo systemctl restart kubelet
    ```

6. **Uncordon the node**:

    ```shell
    kubectl uncordon <node-name>
    ```

## Version skew policy

- `kubelet` can be up to **3 minor versions behind** `kube-apiserver`.
- In-place minor version upgrades of `kubelet` are **not supported** —
  drain the node first.
- See [Version Skew Policy](https://kubernetes.io/docs/setup/release/version-skew-policy/).
