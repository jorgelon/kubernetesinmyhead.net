# Deployment using operator

This example uses kubeadm and vsphere provider

## Deploy cert-manager

It is a requirement

## Deploy the operator

Using the operator-components.yaml file from  <https://github.com/kubernetes-sigs/cluster-api-operator/releases>

This deploys capi-operator-system namespace and the namespaced crds for the providers

## CoreProvider kubeadm

Choose the release from <https://github.com/kubernetes-sigs/cluster-api/releases>
The deployed manifest name is core-components.yaml and includes the capi-system namespace and the following

- Cluster
- ClusterClass
- ClusterResourceSet
- ClusterResourceSetBinding
- ExtensionConfig
- IPAddress
- IPAddressClaim
- Machine
- MachineDeployment
- MachineDrainRule
- MachineHealthCheck
- MachinePool
- MachineSet

For example:

```yaml
apiVersion: operator.cluster.x-k8s.io/v1alpha2
kind: CoreProvider
metadata:
  name: cluster-api
spec:
  version: v1.11.1
```

## BootstrapProvider kubeadm

Use the same release as CoreProvider
The deployed manifest is bootstrap-components.yaml and in kubedm includes the following CRDs:

- KubeadmConfig
- KubeadmConfigTemplate

```yaml
apiVersion: operator.cluster.x-k8s.io/v1alpha2
kind: BootstrapProvider
metadata:
  name: kubeadm
spec:
  version: v1.11.1
```

## ControlPlaneProvider

Use the same release as CoreProvider
The deployed manifest is control-plane-components.yaml and includes the following CRDs

- KubeadmControlPlane
- KubeadmControlPlaneTemplate

```yaml
apiVersion: operator.cluster.x-k8s.io/v1alpha2
kind: ControlPlaneProvider
metadata:
  name: kubeadm
spec:
  version: v1.11.1
```

## InfraestructureProvider vsphere

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
