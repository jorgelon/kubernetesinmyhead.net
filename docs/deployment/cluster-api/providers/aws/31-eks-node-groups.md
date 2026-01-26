# EKS node groups

In order to deploy an EKS node group we need to create a cluster api resource called  MachinePool that loads 2 Kubernetes Cluster API Provider AWS resources:

- AWSMachinePool, that configures the nodes

- EKSConfig, that configure the node bootstrappin

```yaml
apiVersion: cluster.x-k8s.io/v1beta2
kind: MachinePool
metadata:
  name: bottlerocket
spec:
  template:
    spec:
      clusterName: demo-capi
      infrastructureRef:
        apiGroup: infrastructure.cluster.x-k8s.io
        kind: AWSManagedMachinePool
        name: bottlerocket
      bootstrap:
        configRef:
          apiGroup: infrastructure.cluster.x-k8s.io
          kind: EKSConfig
          name: demo-capi-bootstrap
```

Both CRDs are installed EKSConfig when deploying the Kubernetes Cluster API Provider AWS (CAPA)

## AWSMachinePool

## EKSConfig

## Links

- Cluster api MachinePool

<https://cluster-api.sigs.k8s.io/tasks/experimental-features/machine-pools>

- AWSMachinePool

<https://cluster-api-aws.sigs.k8s.io/topics/machinepools>
