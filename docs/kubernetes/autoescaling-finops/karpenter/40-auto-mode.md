# In auto mode

There are some differences between community Karpenter and karpenter deployed in EKS Auto mode

## Built-in Nodepools and node claseses

2 builtin node pools are available: system and general purpose.

- If you choose to deploy at least a built-in nodepool, also a built-in nodeclass called "default"
  will be deployed
- If you choose to not deploy a built-in node pool, no nodeclass will be deployed

## Custom node class

The nodeclass also needs to create an EKS Access Entry to permit the nodes to join the
cluster.

> See more here about here if you want to create a custom node class: <https://docs.aws.amazon.com/eks/latest/userguide/create-node-class.html>

## Custom node pools

### Labels

In order to create a custom nodepool in EKS auto mode, the labels you can use are slightly
different from community karpenter. See this table:

| Purpose                  | Community Karpenter                                          | EKS Auto Mode                                                |
|--------------------------|--------------------------------------------------------------|--------------------------------------------------------------|
| Availability zone        | `topology.kubernetes.io/zone`                                | `topology.kubernetes.io/zone`                                |
| Instance type            | `node.kubernetes.io/instance-type`                           | `node.kubernetes.io/instance-type`                           |
| Architecture             | `kubernetes.io/arch`                                         | `kubernetes.io/arch`                                         |
| OS                       | `kubernetes.io/os`                                           | Not supported (Linux only)                                   |
| Windows build            | `node.kubernetes.io/windows-build`                           | Not supported (Linux only)                                   |
| Capacity type            | `karpenter.sh/capacity-type`                                 | `karpenter.sh/capacity-type`                                 |
| Compute type             | -                                                            | `eks.amazonaws.com/compute-type`                             |
| Hypervisor               | `karpenter.k8s.aws/instance-hypervisor`                      | `eks.amazonaws.com/instance-hypervisor`                      |
| In-transit encryption    | `karpenter.k8s.aws/instance-encryption-in-transit-supported` | `eks.amazonaws.com/instance-encryption-in-transit-supported` |
| Instance category        | `karpenter.k8s.aws/instance-category`                        | `eks.amazonaws.com/instance-category`                        |
| Instance generation      | `karpenter.k8s.aws/instance-generation`                      | `eks.amazonaws.com/instance-generation`                      |
| Instance family          | `karpenter.k8s.aws/instance-family`                          | `eks.amazonaws.com/instance-family`                          |
| Instance size            | `karpenter.k8s.aws/instance-size`                            | `eks.amazonaws.com/instance-size`                            |
| CPU count                | `karpenter.k8s.aws/instance-cpu`                             | `eks.amazonaws.com/instance-cpu`                             |
| CPU manufacturer         | `karpenter.k8s.aws/instance-cpu-manufacturer`                | `eks.amazonaws.com/instance-cpu-manufacturer`                |
| CPU speed (MHz)          | `karpenter.k8s.aws/instance-cpu-sustained-clock-speed-mhz`   | Not supported                                                |
| Memory (MiB)             | `karpenter.k8s.aws/instance-memory`                          | `eks.amazonaws.com/instance-memory`                          |
| EBS bandwidth (Mbps)     | `karpenter.k8s.aws/instance-ebs-bandwidth`                   | `eks.amazonaws.com/instance-ebs-bandwidth`                   |
| Network bandwidth (Mbps) | `karpenter.k8s.aws/instance-network-bandwidth`               | `eks.amazonaws.com/instance-network-bandwidth`               |
| GPU name                 | `karpenter.k8s.aws/instance-gpu-name`                        | `eks.amazonaws.com/instance-gpu-name`                        |
| GPU manufacturer         | `karpenter.k8s.aws/instance-gpu-manufacturer`                | `eks.amazonaws.com/instance-gpu-manufacturer`                |
| GPU count                | `karpenter.k8s.aws/instance-gpu-count`                       | `eks.amazonaws.com/instance-gpu-count`                       |
| GPU memory (MiB)         | `karpenter.k8s.aws/instance-gpu-memory`                      | `eks.amazonaws.com/instance-gpu-memory`                      |
| Local NVMe (GiB)         | `karpenter.k8s.aws/instance-local-nvme`                      | `eks.amazonaws.com/instance-local-nvme`                      |

### Instances

The instances you can get are also restricted.

- Only instances with more that 1 CPU are avaialble
- nano, micro or small are not available

More info here about instances in eks auto mode:

<https://docs.aws.amazon.com/eks/latest/userguide/automode-learn-instances.html>

See more info here about creating a custom nodepool for EKS Auto Mode

<https://docs.aws.amazon.com/eks/latest/userguide/create-node-pool.html>
