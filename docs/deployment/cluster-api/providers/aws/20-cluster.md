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

- In EKS we must use a **AWSManagedControlPlane** resource. Its template is **AWSManagedControlPlaneTemplate**

- When we want a a **self managed control plane**, the resource will depend of the chosen controlplane provider, for example, a KubeadmControlPlane resource if using kubeadm provider.

This is a more complex resource that permits to configure:

- credentials to authenticate against aws
- basic stuff like cluster name, kubernetes version, aws region
- network: vpc, subnets
- api access: endpoint access, authentication mode,...
- k8s settings: upgrade policy, addons, imagelookup
