# Cluster api core provider

Deploy the provider

```yaml
apiVersion: operator.cluster.x-k8s.io/v1alpha2
kind: CoreProvider
metadata:
  name: cluster-api
spec:
  version: v1.11.2 # Choose the release from <https://github.com/kubernetes-sigs/cluster-api/releases>
```

The deployed manifest name is core-components.yaml and includes the capi-system namespace and the following resources

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
