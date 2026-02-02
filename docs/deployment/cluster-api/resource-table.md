# Resource Table

This table shows the gateway api resource and how it can be created using provider specific resources

Cluster

|                        | AWS EKS                | AWS Self   | AWS ROSA         | Vsphere        | Kubeadm             | Talos             |
|------------------------|------------------------|------------|------------------|----------------|---------------------|-------------------|
| spec.infrastructureRef | AWSManagedCluster      | AWSCluster | ROSACluster      | VSphereCluster |                     |                   |
| spec.controlPlaneRef   | AWSManagedControlPlane |            | ROSAControlPlane |                | KubeadmControlPlane | TalosControlPlane |

MachinePool

|                   | AWS EKS               | AWS Self       | AWS ROSA        | Vsphere | Kubeadm       | Talos       |
|-------------------|-----------------------|----------------|-----------------|---------|---------------|-------------|
| infrastructureRef | AWSManagedMachinePool | AWSMachinePool | ROSAMachinePool |         |               |             |
| bootstrap         | EKSConfig             |                |                 |         | KubeadmConfig | TalosConfig |

MachineDeployment

|                   | AWS EKS               | AWS Self       | AWS ROSA        | Vsphere | Kubeadm       | Talos       |
|-------------------|-----------------------|----------------|-----------------|---------|---------------|-------------|

Machine

|   | AWS EKS | AWS Self | AWS ROSA | Vsphere        | Kubeadm | Talos |
|---|---------|----------|----------|----------------|---------|-------|
|   |         |          |          | VSphereMachine |         |       |
|   |         |          |          |                |         |       |
