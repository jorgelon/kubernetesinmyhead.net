# AWS Cluster

When deploying a kubernetes cluster under AWS must define the following sections under the cluster resource

## Kubernetes cluster definition (spec.infrastructureRef)

In spec.infrastructureRef we can use a self managed cluster (AWSCluster) or eks cluster (AWSManagedCluster).
This table shows the aws provider resources that can be called here

|          | EKS                       | Self managed       |
|----------|---------------------------|--------------------|
| Resource | AWSManagedCluster         | AWSCluster         |
| Template | AWSManagedClusterTemplate | AWSClusterTemplate |

> It is a lightweight wrapper that delegates most configuration to AWSManagedControlPlane.

## Control plane definition (spec.controlPlaneRef)

In EKS we must use a AWSManagedControlPlane resource. Its template is AWSManagedControlPlaneTemplate

When we want a a self managed control plane, the resource will depend of the chosen controlplane provider, for example, a KubeadmControlPlane resource if using kubeadm provider.

This is a more complex resource that permits to configure:

- credentials to authenticate against aws
- basic stuff like cluster name, kubernetes version, aws region
- network: vpc, subnets
- api access: endpoint access, authentication mode,...
- k8s settings: upgrade policy, addons, imagelookup

## MachineDeployment

A machineDeployment resource is used when the provider does not support autoscaling or we will not use that features. They can be invoked as independent resources or via spec.topology in the cluster resource.

In AWS usually a MachineDeployment calls a **AWSMachineTemplate** resource, that creates **AWSMachine** resources (EC2 instances)

## MachinePool

A machinePool is used when the provider does supports autoscaling. They can be invoked as independent resources or via spec.topology in the cluster resource.

In AWS we can use invoke the following capa resources via MachinePool

- **AWSMachinePool** (AWS AutoScaling Groups ASG)
- **AWSManagedMachinePool** (EKS managed nodes)

| Resource              | Cluster Type | Management       | AWS Service             | Scaling               |
|-----------------------|--------------|------------------|-------------------------|-----------------------|
| AWSMachine            | Self-managed | Individual EC2   | EC2 instances           | Manual/CAPI           |
| AWSMachineTemplate    | Self-managed | Template for EC2 | EC2 instances           | Via MachineDeployment |
| AWSMachinePool        | Self-managed | ASG-based        | AutoScaling Groups      | ASG policies          |
| AWSManagedMachinePool | EKS          | AWS-managed      | EKS Managed Node Groups | EKS scaling           |
