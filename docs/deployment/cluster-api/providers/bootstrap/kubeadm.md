# Kubeadm (CABPK)

The full name for CABPK is Cluster Api Bootstrap Provider Kubeadm and it is configured via a KubeadmConfig resource

> This bootstrap provider translates the KubeadmConfig resource into a cloud-init/ignition scripts that will convert a virtual machine into a kubernetes node

## Deploying the provider

```yaml
apiVersion: operator.cluster.x-k8s.io/v1alpha2
kind: BootstrapProvider


metadata:
  name: kubeadm
spec:
  version: v1.11.2
```

The deployed manifest is bootstrap-components.yaml and includes the following CRDs:

### KubeadmConfig

- Immutable resource tied to a specific Machine
- Created automatically from a KubeadmConfigTemplate when a Machine is provisioned
- Contains the actual kubeadm configuration for that single machine instance
- Cannot be reused across multiple machines

### KubeadmConfigTemplate

- Template resource defining the configuration pattern
- Referenced by MachineDeployment, MachineSet, or MachinePool
- Used to generate individual KubeadmConfig objects for each machine
- Reusable across multiple machines with the same configuration needs

## Using KubeadmConfig or KubeadmConfigTemplate

Manual KubeadmConfig Creation Usage

- Control plane machines - Often created manually or via KubeadmControlPlane
- One-off machines - Single machines that don't need templating
- Testing/debugging - Direct configuration without template layer

KubeadmConfigTemplate Usage

- Worker node pools - Multiple machines with identical configuration
- MachineDeployments - Scalable machine groups
- MachineSets/MachinePools - Any scenario requiring multiple machines from a template

## KubeadmConfig fields

We can configure the following settings with this provider

Boot method

- spec.format permits to choose between cloud-init or ignition
- spec.files permits to pass files to the user data
- spec.ignition permits to pass ignition configuration

Kubeadm settings

- the joinConfiguration
- the initConfiguration
- the ClusterConfiguration
- kubeadm verbosity

Commands

- spec.bootCommands run very early in the cloud init boot process
- spec.preKubeadmCommands run before kubeadm runs
- spec.postKubeadmCommands run after kubeadm

Node

- spec.diskSetup to configure partitions and filesystems
- spec.mounts to configure mounts
- spec.ntp to configure ntp settings
- spec.users to add additional users

## Links

<https://cluster-api.sigs.k8s.io/tasks/bootstrap/kubeadm-bootstrap/>
