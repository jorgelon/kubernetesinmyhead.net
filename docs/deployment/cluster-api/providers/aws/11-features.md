# Features

## Enable separate roles per EKS cluster

By default, all EKS clusters share the same IAM roles. To use separate roles per cluster,
enable `iamRoleCreation` in the `AWSIAMConfiguration`:

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  eks:
    iamRoleCreation: true
```

Then enable the `EKSEnableIAM` feature gate in the provider, which allows automatic
creation of unique IAM roles for each individual EKS cluster:

```yaml
apiVersion: operator.cluster.x-k8s.io/v1alpha2
kind: InfrastructureProvider
metadata:
  name: aws
spec:
  manager:
    featureGates:
      EKSEnableIAM: true
```

See [Management Cluster](10-management-cluster.md) for the full provider setup.

## Enable MachinePool support

Cluster API has a resource called `MachinePool`. In CAPA, the MachinePool feature must be
**enabled** when deploying the AWS provider:

```yaml
apiVersion: operator.cluster.x-k8s.io/v1alpha2
kind: InfrastructureProvider
metadata:
  name: aws
spec:
  manager:
    featureGates:
      MachinePool: true
```

CAPA supports 2 machine pool resources:

- `AWSMachinePool` — AWS Auto Scaling groups used to orchestrate EC2 machines
- `AWSManagedMachinePool` — EKS managed node groups; requires permissions to create the
  default role for managed machine pools in the `AWSIAMConfiguration`:

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  eks:
    managedMachinePool:
      disable: false
```

> The `MachinePoolMachines` feature also enables the creation of `Machine` and `AWSMachine`
> objects for nodes created by an `AWSMachinePool`.

See more here <https://cluster-api-aws.sigs.k8s.io/topics/machinepools>

## Enable Fargate profiles in EKS

To use Fargate profiles in EKS, create the default role for Fargate profiles in the
`AWSIAMConfiguration`:

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  eks:
    fargate:
      disable: false
```

And enable that feature in the provider:

```yaml
apiVersion: operator.cluster.x-k8s.io/v1alpha2
kind: InfrastructureProvider
metadata:
  name: aws
spec:
  manager:
    featureGates:
      EKSFargate: true
```

## Links

- [Using clusterawsadm to fulfill prerequisites](https://cluster-api-aws.sigs.k8s.io/topics/using-clusterawsadm-to-fulfill-prerequisites)
- [Enabling EKS support](https://cluster-api-aws.sigs.k8s.io/topics/eks/enabling)
- [Provider features reference](https://cluster-api-aws.sigs.k8s.io/topics/reference/reference.html)
