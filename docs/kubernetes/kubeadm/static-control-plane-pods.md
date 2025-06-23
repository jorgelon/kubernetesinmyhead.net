# Static control plane pods

Kubeadm deploy some static control plane pods in using the /etc/kubernetes/manifests directory.

- They are managed directly by the kubelet, not by the Kubernetes API server or controllers and they are not rescheduled to other nodes

- They are not evicted by normal Kubernetes eviction mechanisms (such as those triggered by resource pressure or node taints).

- If killed, kubelet always restarts them

- When draining a node, they are ignored by default and they will remain running unless you use the --force flag

- In this case, kubelet uses the requests values only for internal resource management (e.g., for eviction thresholds and reporting), not for scheduling decisions.

- If a control plane container exceeds its CPU or memory limit, it may be throttled (CPU) or killed (memory), just like any other pod.

> Best Practice: Set appropriate requests and limits to protect both the control plane and other workloads on the node.

## Configure requests and limits

We can use the patches feature

```shell
sudo mkdir /etc/kubernetes/patches
```

## Api server

sudo vi /etc/kubernetes/patches/kube-apiserver.yaml

```yaml
spec:
  containers:
    - name: kube-apiserver
      resources:
        requests:
          cpu: 1000m
        limits:
          memory: 8000Mi
```

## Controller manager

sudo vi /etc/kubernetes/patches/kube-controller-manager.yaml

```yaml
spec:
  containers:
  - name: kube-controller-manager
    resources:
      requests:
        cpu: 200m
      limits:
        memory: 500Mi
```

## Scheduler

Edit the kube scheduler manifest

```shell
sudo vi /etc/kubernetes/patches/kube-scheduler.yaml
```

```yaml
spec:
  containers:
  - name: kube-scheduler
    resources:
      requests:
        cpu: 100m
      limits:
        memory: 300Mi
```

```shell
sudo kubeadm upgrade node --patches /etc/kubernetes/patches/ --dry-run
```

## Etcd

```shell
sudo vi /etc/kubernetes/patches/etcd.yaml
```

```yaml
spec:
  containers:
  - name: etcd
    resources:
      requests:
        cpu: 200m
      limits:
        memory: 500Mi
```

> Remember pass this param in all kubeadm upgrades

Other way is editing the configuration

```shell
kubectl edit cm -n kube-system kubeadm-config
```

## Links

- Reconfiguring a kubeadm cluster

<https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-reconfigure/>

- kubeadm Configuration (v1beta4)

<https://kubernetes.io/docs/reference/config-api/kubeadm-config.v1beta4/>

<https://serverfault.com/questions/1089688/setting-resource-limits-on-kube-apiserver>
