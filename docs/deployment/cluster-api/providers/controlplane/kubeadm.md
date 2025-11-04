# Kubeadm

Deploy the provider

```yaml
apiVersion: operator.cluster.x-k8s.io/v1alpha2
kind: ControlPlaneProvider
metadata:
  name: kubeadm
spec:
  version: v1.11.2
```

The deployed manifest is control-plane-components.yaml and includes the following CRDs

- KubeadmControlPlane
- KubeadmControlPlaneTemplate

## Settings

We can configure the following settings

- The kubernetes version
- How to replace the control plane machines with new oness
- The number of control plane nodes
- How to initialize and join the control plane nodes, with spec.kubeadmConfigSpec
- A Infraestructure Provider template, with spec.machineTemplate (AWSMachineTemplate, VSphereMachineTemplate...)

## Links

<https://cluster-api.sigs.k8s.io/tasks/bootstrap/kubeadm-bootstrap/kubelet-config>
<https://cluster-api.sigs.k8s.io/tasks/control-plane/kubeadm-control-plane>
