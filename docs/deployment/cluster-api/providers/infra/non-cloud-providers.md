# Non-Cloud Infrastructure Providers

Cluster API provides several infrastructure providers designed for environments outside of major cloud platforms. This document explores bare metal, virtualization, and nested cluster providers that enable Kubernetes deployment without dependency on AWS, Azure, GCP, or similar cloud services.

## Overview

Non-cloud infrastructure providers enable Kubernetes cluster provisioning across diverse environments:

- **Bare Metal**: Physical servers without virtualization layers
- **Virtualization**: Virtual machines on platforms like KubeVirt, vSphere
- **Nested/Virtual Clusters**: Kubernetes clusters running within existing Kubernetes clusters

These providers handle infrastructure lifecycle management, OS provisioning (when applicable), and Kubernetes node bootstrapping.

## Virtualization and Nested Cluster Providers

### KubeVirt

Run VMs as Kubernetes resources alongside containerized workloads.

**Key Features:**

- Native Kubernetes API for VM management
- VMs run as pods with KVM virtualization
- Live migration support
- Integration with Kubernetes networking and storage
- PCI passthrough support
- **CNCF Status:** Incubating (since April 2022)

**Links:**

- <https://github.com/kubernetes-sigs/cluster-api-provider-kubevirt>
- <https://kubevirt.io/>

### vcluster

Virtual Kubernetes clusters running inside existing Kubernetes clusters.

**Key Features:**

- Lightweight virtual clusters
- Full Kubernetes API compatibility
- Certified Kubernetes distribution (100% conformance tests)
- Resource isolation and multi-tenancy
- Syncs only necessary resources to host cluster
- No performance overhead
- **CNCF Status:** Not a CNCF project (as of 2025)

**Links:**

- <https://github.com/loft-sh/cluster-api-provider-vcluster>
- <https://www.vcluster.com/>

### Harvester

Open source hyperconverged infrastructure (HCI) built on Kubernetes.

**Key Features:**

- Built on Kubernetes, KubeVirt, and Longhorn
- Hyperconverged infrastructure (compute, storage, networking)
- VM lifecycle management
- Web UI and API
- Rancher integration
- Live migration and backup
- **CNCF Status:** Not a CNCF project (built on CNCF projects)

**Links:**

- <https://github.com/harvester/harvester>
- <https://harvesterhci.io/>

## Dedicated Bare Metal Providers

### Metal3

The most mature and widely adopted bare metal provider for Cluster API.

**Key Features:**

- Uses OpenStack Ironic for bare metal provisioning
- Supports hardware introspection and discovery
- Handles firmware and BIOS configuration
- Provides power management capabilities (IPMI, Redfish)
- Network boot support (PXE, iPXE)
- **CNCF Status:** Incubating (since August 2025)

**Links:**

- <https://github.com/metal3-io/cluster-api-provider-metal3>
- <https://metal3.io/>

### Tinkerbell

A bare metal provisioning framework designed for scalability and flexibility.

**Key Features:**

- Workflow-based provisioning system
- Microservices architecture
- Hardware data management
- DHCP and TFTP services included
- Custom workflow definitions
- **CNCF Status:** Sandbox (since November 2020)

**Links:**

- <https://github.com/tinkerbell/cluster-api-provider-tinkerbell>
- <https://tinkerbell.org/>

### Sidero (Community Maintained)

> **Note:** Sidero Labs is no longer actively developing Sidero Metal. The project is now community-maintained. For new deployments, Sidero Labs recommends using **Omni** as the alternative.

A bare metal provider built specifically for Talos Linux.

**Key Features:**

- Talos Linux native integration
- API-driven bare metal management
- Automatic hardware discovery
- Secure boot support
- Immutable infrastructure approach
- **CNCF Status:** Not a CNCF project

**Status:**

- No longer actively developed by Sidero Labs
- Community-maintained (Slack support available)
- Supports Kubernetes v1.34 and Talos v1.11
- Recommended to use Omni for new deployments

**Links:**

- <https://github.com/siderolabs/sidero>
- <https://www.sidero.dev/>

### Omni (Sidero Labs Alternative)

The successor to Sidero from Sidero Labs, providing a SaaS platform for Talos Linux cluster management.

**Key Features:**

- Managed Talos Linux platform
- Multi-cluster management
- Works with bare metal, cloud, and edge
- Web-based UI and API
- Secure by default (WireGuard-based)
- GitOps integration
- **CNCF Status:** Not a CNCF project

**Note:** Omni is not a traditional Cluster API provider but rather a complete cluster management platform that can work alongside or instead of Cluster API.

**Links:**

- <https://github.com/siderolabs/omni>
- <https://omni.siderolabs.com/>

### Hivelocity

A commercial bare metal cloud provider with Cluster API integration.

**Key Features:**

- Managed bare metal infrastructure
- Global data center presence
- API-driven provisioning
- Network configuration management
- Storage options
- **CNCF Status:** Not a CNCF project

**Links:**

- <https://github.com/hivelocity/cluster-api-provider-hivelocity>
- <https://www.hivelocity.net/>

## Flexible/Hybrid Providers

### BYOH (Bring Your Own Host)

> **Note:** The original VMware Tanzu BYOH provider is no longer actively maintained. An actively maintained fork is available from Platform9.

The most flexible option for existing bare metal infrastructure.

**Key Features:**

- SSH-based host registration
- No special hardware requirements
- Works with Ubuntu 20.04 and 22.04
- Agent-based approach
- Supports existing infrastructure
- **CNCF Status:** Not a CNCF project

**Status:**

- Alpha stage (not production-ready)
- Platform9 fork actively maintained
- Supports Kubernetes v1.31.*
- No backwards-compatibility guarantee

**Links:**

- <https://github.com/platform9/cluster-api-provider-bringyourownhost> (Active fork)
- <https://github.com/vmware-tanzu/cluster-api-provider-bringyourownhost> (Original, unmaintained)

### MAAS (Metal as a Service)

Canonical's bare metal provisioning solution.

**Key Features:**

- Comprehensive hardware management
- Network configuration automation
- Storage configuration
- Integration with Juju
- Web UI and API
- **CNCF Status:** Not a CNCF project

**Links:**

- <https://github.com/spectrocloud/cluster-api-provider-maas>
- <https://maas.io/>

### k0smotron RemoteMachine

SSH-based remote machine provisioning.

**Key Features:**

- SSH connectivity
- k0s distribution focus
- Simple deployment model
- No agent required on target
- **CNCF Status:** Not a CNCF project

**Links:**

- <https://github.com/k0sproject/k0smotron>

## Provider Comparison

### Virtualization and Nested Providers

| Provider  | Maturity | Complexity | CNCF Status                   | Infrastructure Type | Special Requirements |
|-----------|----------|------------|-------------------------------|---------------------|----------------------|
| KubeVirt  | High     | Medium     | Incubating                    | VM in K8s           | Existing K8s cluster |
| vcluster  | Medium   | Low        | Not CNCF                      | Virtual K8s in K8s  | Existing K8s cluster |
| Harvester | Medium   | Medium     | Not CNCF (uses CNCF projects) | HCI on bare metal   | Bare metal servers   |

### Bare Metal and Hybrid Providers

| Provider   | Maturity           | Complexity  | Hardware Discovery | Boot Method | Self-Hosted | CNCF Status | Special Requirements                 |
|------------|--------------------|-------------|--------------------|-------------|-------------|-------------|--------------------------------------|
| Metal3     | High               | Medium-High | Yes                | PXE/iPXE    | Yes (BM)    | Incubating  | IPMI/Redfish                         |
| Tinkerbell | Medium             | Medium      | Yes                | PXE         | Yes (BM)    | Sandbox     | DHCP/TFTP infrastructure             |
| Sidero     | Medium (Community) | Medium      | Yes                | PXE         | Yes (BM)    | Not CNCF    | Talos Linux (not actively developed) |
| Omni       | Medium             | Low         | No                 | Agent-based | Optional    | Not CNCF    | Talos Linux, Omni account            |
| Hivelocity | Medium             | Low         | N/A                | Managed     | No          | Not CNCF    | Hivelocity account                   |
| BYOH       | Low (Alpha)        | Low         | No                 | N/A         | Yes (Both)  | Not CNCF    | SSH access (Platform9 fork)          |
| MAAS       | High               | Medium-High | Yes                | PXE         | Yes (BM)    | Not CNCF    | MAAS server                          |
| k0smotron  | Low-Medium         | Low         | No                 | N/A         | Yes (Both)  | Not CNCF    | SSH access                           |

**Legend:**

- **Self-Hosted**: Yes (BM) = Bare metal only, Yes (Both) = Bare metal and cloud, Optional = SaaS or self-hosted, No = Managed service only
- **CNCF Status**: Incubating/Sandbox = Official CNCF project level, Not CNCF = Independent project, Part of CAPI = Kubernetes subproject
