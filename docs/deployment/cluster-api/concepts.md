# Concepts

## CoreProvider

A component responsible for providing the fundamental building blocks of the Cluster API. It defines and implements the main Cluster API resources such as Clusters, Machines, and MachineSets, and manages their lifecycle. This includes:

Defining the main Cluster API resources and their schemas.
Implementing the logic for creating, updating, and deleting these resources.
Managing the overall lifecycle of Clusters, Machines, and MachineSets.
Providing the base upon which other providers like BootstrapProvider and InfrastructureProvider build.

Only the cluster-api CoreProvider is available

## BootstrapProvider

A component responsible for turning a server into a Kubernetes node as well as for:

- Generating the cluster certificates, if not otherwise specified
- Initializing the control plane, and gating the creation of other nodes until it is complete
- Joining control plane and worker nodes to the cluster

Get all:

```shell
clusterctl config repositories | grep BootstrapProvider
```

Examples: kubeadm, talos, microk8s, rke2,...

## ControlPlaneProvider

A component responsible for managing the control plane of a Kubernetes cluster. This includes:

Provisioning the control plane nodes.
Managing the lifecycle of the control plane, including upgrades and scaling.

Get all:

```shell
clusterctl config repositories | grep ControlPlaneProvider
```

Examples: kubeadm, talos, microk8s, rke2,...

## InfrastructureProvider

A component responsible for the provisioning of infrastructure/computational resources required by the Cluster or by Machines (e.g. VMs, networking, etc.). For example, cloud Infrastructure Providers include AWS, Azure, and Google, and bare metal Infrastructure Providers include VMware, MAAS, and metal3.io.

Examples: aws, azure, gcp, harvester, vsphere, metal3, vcluster, openstack, docker, byoh, ...

Get all:

```shell
clusterctl config repositories | grep InfrastructureProvider
```

## IPAMProvider

A component that manages pools of IP addresses using Kubernetes resources. It serves as a reference implementation for IPAM providers, but can also be used as a simple replacement for DHCP.

Get all:

```shell
clusterctl config repositories | grep IPAMProvider
```

Examples: in-cluster, nutanix

## RuntimeExtensionProvider

Get all:

```shell
clusterctl config repositories | grep RuntimeExtensionProvider
```

Examples: nutanix

## AddonProvider

A component that extends the functionality of Cluster API by providing a solution for managing the installation, configuration, upgrade, and deletion of Cluster add-ons using Helm charts.

Get all:

```shell
clusterctl config repositories | grep AddonProvider
```
