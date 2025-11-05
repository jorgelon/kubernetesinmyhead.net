# Cluster API Resources

## Operator CRDs

This resources are created when deploying the operator and uses the operator.cluster.x-k8s.io/v1alpha2 API Group

| Kind                     | Description                                          |
|--------------------------|------------------------------------------------------|
| AddonProvider            | Manages addon provider installations                 |
| BootstrapProvider        | Manages bootstrap provider installations             |
| ControlPlaneProvider     | Manages control plane provider installations         |
| CoreProvider             | Manages core Cluster API provider installations      |
| InfrastructureProvider   | Manages infrastructure provider installations        |
| IPAMProvider             | Manages IP address management provider installations |
| RuntimeExtensionProvider | Manages runtime extension provider installations     |

## Providers

Once we have the cluster api operator installed, we need to the deploy the chosen providers. Here is the provider list: <https://cluster-api.sigs.k8s.io/reference/providers>

### Core Provider CRDs

This resources are created when deploying the cluster-api Core Provider

| Kind                      | API Group                        | Maturity | Description                                                     |
|---------------------------|----------------------------------|----------|-----------------------------------------------------------------|
| Cluster                   | cluster.x-k8s.io/v1beta2         | Stable   | Represents a Kubernetes cluster managed by Cluster API          |
| ClusterClass              | cluster.x-k8s.io/v1beta2         | Beta     | Defines reusable cluster templates and configurations           |
| MachineDeployment         | cluster.x-k8s.io/v1beta2         | Stable   | Manages declarative updates for machines                        |
| MachineDrainRule          | cluster.x-k8s.io/v1beta2         | Stable   | Defines rules for draining machines before deletion             |
| MachineHealthCheck        | cluster.x-k8s.io/v1beta2         | Stable   | Monitors and remediates unhealthy machines                      |
| MachinePool               | cluster.x-k8s.io/v1beta2         | Beta     | Manages groups of machines with identical configuration         |
| Machine                   | cluster.x-k8s.io/v1beta2         | Stable   | Represents a single machine in the cluster                      |
| MachineSet                | cluster.x-k8s.io/v1beta2         | Stable   | Ensures a specified number of machines are running              |
| ClusterResourceSetBinding | addons.cluster.x-k8s.io/v1beta2  | GA       | Binds ClusterResourceSets to specific clusters                  |
| ClusterResourceSet        | addons.cluster.x-k8s.io/v1beta2  | GA       | Defines resources to be applied to matching clusters            |
| IPAddressClaim            | ipam.cluster.x-k8s.io/v1beta2    | Stable   | Claims an IP address from an IPAM provider                      |
| IPAddress                 | ipam.cluster.x-k8s.io/v1beta2    | Stable   | Represents an allocated IP address                              |
| ExtensionConfig           | runtime.cluster.x-k8s.io/v1beta2 | Alpha    | Configures runtime extensions for lifecycle hook customizations |

### Provider CRDs

When deploying other providers than the Core Provider, every provider installs its own additional CRDs but they all have the same apiVersion, regarding the provider. It only changes the name of the CRD.

| Provider Type  | API Group                       |
|----------------|---------------------------------|
| Bootstrap      | bootstrap.cluster.x-k8s.io      |
| ControlPlane   | controlplane.cluster.x-k8s.io   |
| Infrastructure | infrastructure.cluster.x-k8s.io |
| IPAM           | ipam.cluster.x-k8s.io           |
| Addon          | addons.cluster.x-k8s.io         |
| Runtime        | runtime.cluster.x-k8s.io        |

> To see all installed provider CRDs filtered by provider type we can do a **kubectl api-resources  | grep API_GROUP** command

The provider CRDs permits to configure the different cluster api resources deployed by the core provider.

> This tables exclude IPAM, addon and IPAM resources

| Resource          | Bootstrap Provider       | Infrastructure Provider                               | ControlPlane Provider |
|-------------------|--------------------------|-------------------------------------------------------|-----------------------|
| Cluster           | -                        | Cluster                                               | ControlPlane          |
| ClusterClass      | ConfigTemplate (workers) | ClusterTemplate, MachineTemplate, MachinePoolTemplate | ControlPlaneTemplate  |
| Machine           | Config                   | Machine                                               | -                     |
| MachineSet        | ConfigTemplate           | MachineTemplate                                       | -                     |
| MachineDeployment | ConfigTemplate           | MachineTemplate                                       | -                     |
| MachinePool       | ConfigTemplate           | MachinePoolTemplate                                   | -                     |

#### Provider CRD Reference Examples

**Cluster** resource references:

- **Infrastructure Provider**: `AWSCluster`, `AzureCluster`, `GCPCluster`, `VSphereCluster`
- **ControlPlane Provider**: `KubeadmControlPlane`, `AWSManagedControlPlane`, `AzureManagedControlPlane`, `MicroK8sControlPlane`

**Machine** resource references:

- **Bootstrap Provider**: `KubeadmConfig`, `MicroK8sConfig`
- **Infrastructure Provider**: `AWSMachine`, `AzureMachine`, `GCPMachine`, `VSphereMachine`

**MachineSet, MachineDeployment** resources reference templates:

- **Bootstrap Provider**: `KubeadmConfigTemplate`, `MicroK8sConfigTemplate`
- **Infrastructure Provider**: `AWSMachineTemplate`, `AzureMachineTemplate`, `GCPMachineTemplate`, `VSphereMachineTemplate`

**MachinePool** resource references templates:

- **Bootstrap Provider**: `KubeadmConfigTemplate`
- **Infrastructure Provider**: `AWSMachinePool`, `AzureMachinePool`, `GCPMachinePool`, `VSphereMachinePool`

**ClusterClass** resource references multiple templates:

- **Infrastructure Provider**: `AWSClusterTemplate`, `AzureClusterTemplate`, `GCPClusterTemplate`, `VSphereClusterTemplate` (cluster), and corresponding `MachineTemplate` resources
- **ControlPlane Provider**: `KubeadmControlPlaneTemplate`, `AWSManagedControlPlaneTemplate`
- **Bootstrap Provider**: `KubeadmConfigTemplate` (for workers)
