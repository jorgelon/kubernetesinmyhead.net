# Cluster

This is the goal of cluster api.

When creating a cluster we need to define:

- The control plane configuration
  no
This is done with a resource provided by a control plane provider

Examples: `KubeadmControlPlane`, `AWSManagedControlPlane`, `AzureManagedControlPlane`, `MicroK8sControlPlane`

- The kubernetes cluster configuration

This is done with a resource provided by an infraestructure provider

Examples: `AWSCluster`, `AzureCluster`, `GCPCluster`, `VSphereCluster`
