# Features

## Enable separate roles per EKS cluster

By default, all the EKS cluster share the same IAM roles. [See this if we want to have separate roles per EKS cluster](12-authentication.md)

## Enable MachinePool support

Cluster api has a resource called MachinePool. In CAPA, in order to manage MachinePool resources we need to **enable the MachinePool feature** when deploying the aws provider

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

But CAPA supports 2 machine pool resources:

- AWSMachinePool

These are aws autoescaling groups in order to orquestrate ec2 machines

- AWSManagedMachinePool

These are EKS managed node groups. In this case we need to give permissions to create the default role for managed machine pools in the AWSIAMConfiguration file

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  eks:
    managedMachinePool:
      disable: false 
```

> The MachinePoolMachines features also enables the creation of Machine and AWSMachine objects for nodes created by a AWSMachinePool.

See more here <https://cluster-api-aws.sigs.k8s.io/topics/machinepools>

## Add more control plane roles

## Enable Fargate profiles in EKS

To use Fargate profiles in EKS we need to create the default role for the fargate profiles in the AWSIAMConfiguration

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  eks:
    fargate:
      disable: false
```

And enable that feature in the provider

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

- Using clusterawsadm to fulfill prerequisites

<https://cluster-api-aws.sigs.k8s.io/topics/using-clusterawsadm-to-fulfill-prerequisites>

- Enabling EKS support

<https://cluster-api-aws.sigs.k8s.io/topics/eks/enabling>

- Provider features

<https://cluster-api-aws.sigs.k8s.io/topics/reference/reference.html>
