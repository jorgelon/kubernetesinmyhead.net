# Kubeadm configuration types

Kubeadm reads its configuration as a multi-document YAML file (documents separated
by `---`). Each document is a typed object with its own `kind` and `apiVersion`.
Which kinds you provide depends on the subcommand you run, because each subcommand
consumes only the kinds that are relevant to it.

## The five kinds and their apiVersion

| Kind                     | apiVersion                         |
|--------------------------|------------------------------------|
| `InitConfiguration`      | `kubeadm.k8s.io/v1beta4`           |
| `ClusterConfiguration`   | `kubeadm.k8s.io/v1beta4`           |
| `JoinConfiguration`      | `kubeadm.k8s.io/v1beta4`           |
| `KubeletConfiguration`   | `kubelet.config.k8s.io/v1beta1`    |
| `KubeProxyConfiguration` | `kubeproxy.config.k8s.io/v1alpha1` |

> The three kubeadm-owned kinds share the `kubeadm.k8s.io/v1beta4` group/version.
> The kubelet and kube-proxy kinds belong to their own component config groups and
> version independently.

## Where each kind is applied

| Kind                     | First control plane (`kubeadm init`) | Extra control plane (`kubeadm join --control-plane`) |  Worker (`kubeadm join`)   |
|--------------------------|:------------------------------------:|:----------------------------------------------------:|:--------------------------:|
| `InitConfiguration`      |                  ✅                   |                          ❌                           |             ❌              |
| `ClusterConfiguration`   |                  ✅                   |                          ❌                           |             ❌              |
| `KubeletConfiguration`   |                  ✅                   |                     ⚠️ optional                      |        ⚠️ optional         |
| `KubeProxyConfiguration` |                  ✅                   |                          ❌                           |             ❌              |
| `JoinConfiguration`      |                  ❌                   |                ✅ (`controlPlane` set)                | ✅ (`controlPlane` omitted) |

- ✅ applies / expected
- ⚠️ optional (usually inherited from the cluster instead)
- ❌ ignored — does not apply to this subcommand

## First control plane node — `kubeadm init --config`

Provide `InitConfiguration`, `ClusterConfiguration`, `KubeletConfiguration` and
`KubeProxyConfiguration`. Only one of `InitConfiguration` or `ClusterConfiguration`
is strictly mandatory, but in practice both are supplied.

- `InitConfiguration` — settings for bootstrapping this specific first node
  (node registration, bootstrap tokens, local API endpoint, patches).
- `ClusterConfiguration` — cluster-wide settings that are stored in the cluster and
  reused by every future node: `kubernetesVersion`, `clusterName`, networking,
  and `controlPlaneEndpoint` (required for high availability).
- `KubeletConfiguration` / `KubeProxyConfiguration` — component config written to
  the cluster so joining nodes inherit them.

```yaml
apiVersion: kubeadm.k8s.io/v1beta4
kind: InitConfiguration
patches:
  directory: /etc/kubernetes/patches/
---
apiVersion: kubeadm.k8s.io/v1beta4
kind: ClusterConfiguration
kubernetesVersion: <K8S_RELEASE>
clusterName: <CLUSTER_NAME>
# controlPlaneEndpoint is required for HA (load balancer FQDN):
# controlPlaneEndpoint: "<CONTROL_PLANE_FQDN>:6443"
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: systemd
---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
```

> For HA, `controlPlaneEndpoint` must live in `ClusterConfiguration`. Kubeadm rejects
> the `--control-plane-endpoint` flag when `--config` is used, so it cannot be passed
> on the command line together with a config file.

## Additional control plane node — `kubeadm join --control-plane --config`

Provide only `JoinConfiguration`, with the `controlPlane` field present (non-nil).
That field is what tells kubeadm to deploy an additional control-plane instance on
the joining node. `InitConfiguration`, `ClusterConfiguration` and
`KubeProxyConfiguration` do not apply here — `join` fetches `ClusterConfiguration`
and kube-proxy settings from the cluster's `kubeadm-config` ConfigMap.

```yaml
apiVersion: kubeadm.k8s.io/v1beta4
kind: JoinConfiguration
controlPlane:
  localAPIEndpoint:
    advertiseAddress: "<NODE_IP>"
    bindPort: 6443
discovery:
  bootstrapToken:
    apiServerEndpoint: "<CONTROL_PLANE_FQDN>:6443"
    token: "<BOOTSTRAP_TOKEN>"
    caCertHashes:
      - "sha256:<CA_CERT_HASH>"
nodeRegistration:
  name: "<NODE_NAME>"
patches:
  directory: /etc/kubernetes/patches/
```

## Worker node — `kubeadm join --config`

Provide only `JoinConfiguration`, with `controlPlane` omitted (nil). The kubelet and
kube-proxy configuration are downloaded from the running cluster, so
`InitConfiguration` and `ClusterConfiguration` do not apply.

```yaml
apiVersion: kubeadm.k8s.io/v1beta4
kind: JoinConfiguration
discovery:
  bootstrapToken:
    apiServerEndpoint: "<CONTROL_PLANE_FQDN>:6443"
    token: "<BOOTSTRAP_TOKEN>"
    caCertHashes:
      - "sha256:<CA_CERT_HASH>"
nodeRegistration:
  name: "<NODE_NAME>"
patches:
  directory: /etc/kubernetes/patches/
```

## Summary

- `InitConfiguration` and `ClusterConfiguration` are **init-only**.
- `JoinConfiguration` is **join-only**; the presence of the `controlPlane` field is
  the single switch between joining a control plane node and a worker node.
- `KubeletConfiguration` and `KubeProxyConfiguration` are primarily set at `init`
  time and stored in the cluster; joining nodes inherit them rather than redefining
  them.
- Config files can be validated before applying with the `--dry-run` flag
  (`kubeadm init --config ... --dry-run`).

## Links

- kubeadm Configuration (v1beta4)

<https://kubernetes.io/docs/reference/config-api/kubeadm-config.v1beta4/>

- kubeadm init

<https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/>

- kubeadm join

<https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/>
