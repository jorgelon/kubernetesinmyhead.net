# VMware Vsphere (CAPV)

## Requirements

- It needs DHCP in the primary VM Network
- Configure one resource pool across the hosts onto which the workload clusters will be provisioned
- Every host in the resource pool will need access to shared storage, such as VSAN in order to be able to make use of MachineDeployments and high-availability control planes
- To use persistence storage we need the vsphere csi driver
- We can use virtual machines published [in the main README](https://github.com/kubernetes-sigs/cluster-api-provider-vsphere/blob/main/README.md) or build them. The machines must have cloudinit/Ignition, kubeadm and a container runtime.

## Notes

- the default and recomended cloneMode for vsphereMachines is linked clone

## Deployment

We need a vsphere-settings secret with credentials and settings. See the release and configuration options in <https://github.com/kubernetes-sigs/cluster-api-provider-vsphere/>

```yaml
apiVersion: operator.cluster.x-k8s.io/v1alpha2
kind: InfrastructureProvider
metadata:
  name: vsphere
spec:
  version: v1.14.0
  configSecret:
    name: vsphere-settings
```

This adds the following cluster scoped crds

- VSphereClusterIdentity
- VSphereDeploymentZone
- VSphereFailureDomain

and namespace scoped crds

- VSphereCluster
- VSphereClusterTemplate
- VSphereMachine
- VSphereMachineTemplate
- VSphereVM

## Links

Github repo

- <https://github.com/kubernetes-sigs/cluster-api-provider-vsphere/>

Getting started

- <https://github.com/kubernetes-sigs/cluster-api-provider-vsphere/blob/main/docs/getting_started.md>

- Vsphere CSI Driver

<https://github.com/kubernetes-sigs/vsphere-csi-driver>

- Vsphere Cloud Provider

<https://github.com/kubernetes/cloud-provider-vsphere>
