# Deployment using operator

This example uses kubeadm and vsphere provider

## Deploy the operator

Using the operator-components.yaml file from  <https://github.com/kubernetes-sigs/cluster-api-operator/releases>

## CoreProvider kubeadm

Choose the release from <https://github.com/kubernetes-sigs/cluster-api/releases>

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
