# IP Address Management (IPAM)

## Pods

In Kubernetes, the CNI (Container Network Interface) plugin/driver is responsible for assigning IP addresses to pods. So read your network plugin documentation to know the different options and settings it has.

When a pod is created, the Kubelet on the node asks the configured CNI plugin to set up networking for the pod.

### Kubelet cluster mode

In kubelet cluster mode it is possible to enable and specify the global cidr range using the following settings:

kube controller manager configuration file

```yaml
AllocateNodeCIDRs: true
ClusterCIDR
```

kube controller manager parameter

```txt
--allocate-node-cidrs=true
--cluster-cidr 
```

> The default cilium IPAM mode "Cluster Scope" ignores this setting and uses ipam.operator.clusterPoolIPv4PodCIDRList (default 10.0.0.0/8)

### Kubelet standalone mode

If we have an standalone kubelet nodes, it is possible to configure the pod cidr range using the following setting:

```yaml
podCIDR # kubelet configuration file
--pod-cidr # kubelet parameter
```

## Services

The kube-apiserver is configured to assign IP addresses to Services.

pending

## Nodes

pending
